@echo off
setlocal enabledelayedexpansion
if not exist "%USERPROFILE%\Documents\WindowsPowerShell" (
    mkdir "%USERPROFILE%\Documents\WindowsPowerShell"
    mkdir "%USERPROFILE%\Documents\WindowsPowerShell\Modules"
)
if not exist "%USERPROFILE%\Documents\WindowsPowerShell\Modules" (
    mkdir "%USERPROFILE%\Documents\WindowsPowerShell\Modules"
)

if exist "%USERPROFILE%\Documents\WindowsPowerShell\Modules\Cobalt" (
    rmdir /S /Q "%USERPROFILE%\Documents\WindowsPowerShell\Modules\Cobalt"
)
for /f "tokens=7 delims=/" %%i in ('curl -s -I "https://github.com/craeckor/Cobalt/releases/latest" 2^>^&1 ^| findstr "Location:"') do (
    set cobalt_tag=%%i
)
mkdir "%USERPROFILE%\Documents\WindowsPowerShell\Modules\Cobalt"
mkdir "%USERPROFILE%\Documents\WindowsPowerShell\Modules\Cobalt\%cobalt_tag%"
curl -o "%Temp%\cobalt.zip" "https://github.com/craeckor/Cobalt/releases/download/%cobalt_tag%/cobalt.zip" -L -s
Powershell Expand-Archive -Path "$ENV:TEMP\cobalt.zip" -DestinationPath "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\Cobalt\%cobalt_tag%"
del /F /S /Q "%Temp%\cobalt.zip"
endlocal