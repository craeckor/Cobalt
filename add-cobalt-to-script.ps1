$url = curl.exe -s -I "https://github.com/craeckor/Cobalt/releases/latest" | Select-String "Location:"
$cobalt_tag = $url -split "/" | Select-Object -Last 1
If(!(test-path -PathType container "$ENV:APPDATA\Cobalt")) {
    New-Item -ItemType Directory -Path "$ENV:APPDATA\Cobalt"
    New-Item -ItemType Directory -Path "$ENV:APPDATA\Cobalt\$cobalt_tag"
    curl.exe -o "$ENV:TEMP\cobalt.zip" "https://github.com/craeckor/Cobalt/releases/download/$cobalt_tag/cobalt.zip" -L -s
    Expand-Archive -Path "$ENV:TEMP\cobalt.zip" -DestinationPath "$ENV:APPDATA\Cobalt\$cobalt_tag"
    Remove-Item -Path "$ENV:TEMP\cobalt.zip" -Recurse -Force
} elseif (!(test-path -PathType container "$ENV:APPDATA\Cobalt\$cobalt_tag")) {
    New-Item -ItemType Directory -Path "$ENV:APPDATA\Cobalt\$cobalt_tag"
    curl.exe -o "$ENV:TEMP\cobalt.zip" "https://github.com/craeckor/Cobalt/releases/download/$cobalt_tag/cobalt.zip" -L -s
    Expand-Archive -Path "$ENV:TEMP\cobalt.zip" -DestinationPath "$ENV:APPDATA\Cobalt\$cobalt_tag"
    Remove-Item -Path "$ENV:TEMP\cobalt.zip" -Recurse -Force
} elseif (!(test-path -PathType Leaf "$ENV:APPDATA\Cobalt\$cobalt_tag\Cobalt.psm1")) {
    Remove-Item -Path "$ENV:APPDATA\Cobalt\$cobalt_tag" -Recurse -Force
    New-Item -ItemType Directory -Path "$ENV:APPDATA\Cobalt\$cobalt_tag"
    curl.exe -o "$ENV:TEMP\cobalt.zip" "https://github.com/craeckor/Cobalt/releases/download/$cobalt_tag/cobalt.zip" -L -s
    Expand-Archive -Path "$ENV:TEMP\cobalt.zip" -DestinationPath "$ENV:APPDATA\Cobalt\$cobalt_tag"
    Remove-Item -Path "$ENV:TEMP\cobalt.zip" -Recurse -Force
}
Import-Module -Name "$ENV:APPDATA\Cobalt" -Global -Force