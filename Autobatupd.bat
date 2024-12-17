@echo off
TITLE DayZ SA Server - Status
COLOR 0A
    :: DEFINE the following variables where applicable to your install
    SET SteamLogin=anonymous
    SET DayZBranch=223350
    SET DayZServerPath="C:\daisy\DayZServerNam"
    SET SteamCMDPath="C:\daisy\DayZServerNam\SteamCMD"
    SET BECPath="C:\daisy\BEC"
    :: DayZ Mod Parameters
    set DayZModList=(C:\daisy\DayZServerNam\Modlist.txt)
    set SteamCMDWorkshopPath="C:\daisy\DayZServerNam\SteamCMD\steamapps\workshop\content\221100"
    set SteamCMDDelay=5
    set serverName=Brains Buffet Namalsk
    set serverPort=2302
    set serverConfig=serverDZ.cfg
    set serverProfile=profile
    set serverCPU=12
    setlocal EnableDelayedExpansion

    :: _______________________________________________________________
 
goto checkServer
pause
 
:checkServer
tasklist /fi "imagename eq DayZServer_x64.exe" 2>NUL | find /i /n "DayZServer_x64.exe">NUL
if "%ERRORLEVEL%"=="0" goto checkBEC
cls
echo Server is not running, taking care of it..
goto killServer
 
:checkBEC
tasklist /fi "imagename eq BEC.exe" 2>NUL | find /i /n "BEC.exe">NUL
if "%ERRORLEVEL%"=="0" goto loopServer
cls
echo Bec is not running, taking care of it..
goto startBEC
 
:loopServer
FOR /L %%s IN (30,-1,0) DO (
    cls
    echo Server is running. Checking again in %%s seconds.. 
    timeout 1 >nul
)
goto checkServer
 
:killServer
taskkill /f /im Bec.exe
taskkill /f /im DayZServer_x64.exe
goto updateServer
 
:updateServer
cls
echo Updating DayZ SA Server.
timeout 1 >nul
cls
echo Updating DayZ SA Server..
timeout 1 >nul
cls
echo Updating DayZ SA Server...
cd "%SteamCMDPath%"
steamcmd.exe +login %SteamLogin% +force_install_dir %DayZServerPath% +"app_update %DayZBranch%" +quit
goto updateMods
 
:startServer
cls
echo Starting DayZ SA Server.
timeout 1 >nul
cls
echo Starting DayZ SA Server..
timeout 1 >nul
cls
echo Starting DayZ SA Server...
cd "%DayZServerPath%"
::start DayZServer_x64.exe -instanceId=1 -config=serverDZ.cfg -profiles=profile -port=2302 -mod=!MODS_TO_LOAD!% -cpuCount=8 -noFilePatching -dologs -adminlog -freezecheck
start "DayZ Server" /min "C:\daisy\DayZServerNam\DayZServer_x64.exe" -config=%serverConfig% -mod=!MODS_TO_LOAD!% -port=%serverPort% -profiles=%serverProfile% -cpuCount=%serverCPU% -dologs -adminlog -netlog -freezecheck"-mod=@Namalsk Survival (server);@Namalsk Island (server);@Treasure;@TreasurePhotosNamalsk;@RaG_Evil_Snowman;@Namalsk_Igloo;@CF;@GRW ER7 Gauss Rifle;@RedFalcon Buildings;@Namalsk Clothing Expansion;@BaseBuildingPlus;@dbo_creatures;@EDO_WEAPONS;@AmmunitionExpansion;@Gas-Pump-Refueling;@GoreZ;@Unlimited Stamina;@The Last of Us Mutant's;@Perishable Food (Fixed);@ArrakisAmmoCurrency;@CJ187-Fridges;@CJ187-PokemonCards;@CannabisPlus;@DrugsPLUS;@MoreFood;@Mass'sManyItemOverhaul;@CodeLock to ExpansionCodeLock Bridge;@OP_BaseItems;@FlipTransport;@DHGS Hunting;@Huffy's Cocaine Bear;@TNL Dead Bodies;@Community-Online-Tools;@Dabs FrameWork;@DayZ Editor Loader;@DayZ-Expansion-Bundle;@BrainBuffetNamalsk;@zombiesampling;@DayZ-Expansion-Licensed"
FOR /l %%s IN (45,-1,0) DO (
    cls
    echo Initializing server, wait %%s seconds to initialize BEC.. 
    timeout 1 >nul
)
goto startBEC
 
:startBEC
cls
echo Starting BEC.
timeout 1 >nul
cls
echo Starting BEC..
timeout 1 >nul
cls
echo Starting BEC...
timeout 1 >nul
cd "%BECPath%"
start Bec.exe -f Config.cfg --dsc
goto checkServer
 
:updateMods
cls
FOR /L %%s IN (%SteamCMDDelay%,-1,0) DO (
    cls
    echo Checking for mod updates in %%s seconds.. 
    timeout 1 >nul
)
echo Updating Steam Workshop Mods...
@ timeout 1 >nul
cd %SteamCMDPath%
for /f "tokens=1,2 delims=," %%g in %DayZModList% do steamcmd.exe +login %SteamLogin% +workshop_download_item 221100 "%%g" +quit
cls
echo Steam Workshop files are up-to-date! Syncing Workshop source with server destination...
@ timeout 2 >nul
cls
@ for /f "tokens=1,2 delims=," %%g in %DayZModList% do robocopy "%SteamCMDWorkshopPath%\%%g" "%DayZServerPath%\%%h" *.* /mir
@ for /f "tokens=1,2 delims=," %%g in %DayZModList% do forfiles /p "%DayZServerPath%\%%h" /m *.bikey /s /c "cmd /c copy @path %DayZServerPath%\keys"
cls
echo Sync complete!
@ timeout 3 >nul
cls
set "MODS_TO_LOAD="
for /f "tokens=1,2 delims=," %%g in %DayZModList% do (
set "MODS_TO_LOAD=!MODS_TO_LOAD!%%h;"
)
set "MODS_TO_LOAD=!MODS_TO_LOAD:~0,-1!"
ECHO Will start DayZ with the following mods: !MODS_TO_LOAD!%
@ timeout 3 >nul
goto startServer