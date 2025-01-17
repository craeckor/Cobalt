[![CI](https://github.com/ethanbergstrom/Cobalt/actions/workflows/CI.yml/badge.svg)](https://github.com/ethanbergstrom/Cobalt/actions/workflows/CI.yml)

# Cobalt
Cobalt is a simple PowerShell Crescendo wrapper for WinGet

## Requirements
In addition to PowerShell 5.1+ and an Internet connection on a Windows machine, WinGet must also be installed. Microsoft recommends installing WinGet from the Windows Store as part of the [App Installer](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1?activetab=pivot:overviewtab) package.

## Install Cobalt
With NuGet
```PowerShell
Install-Module Cobalt -Force
```

Without NuGet
```
Run install-cobalt-alluers.bat for All Users or install-cobalt-currentuser.bat for the Current User
```

## Script usage

For using Cobalt in a Script add this to the top of your Script
```powershell
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
```

## Sample usages
### Search for a package
```PowerShell
Find-WinGetPackage -ID openJS.nodejs

Find-WinGetPackage -ID Mozilla.Firefox -Exact
```

### Get a package's detailed information from the repository
```PowerShell
Get-WinGetPackageInfo -ID CPUID.CPU-Z -Version 1.95

Find-WinGetPackage -ID Mozilla.Firefox -Exact | Get-WinGetPackageInfo
```

### Get all available versions of a package
```PowerShell
Get-WinGetPackageInfo -ID CPUID.CPU-Z -Versions

Find-WinGetPackage -ID Mozilla.Firefox -Exact | Get-WinGetPackageInfo -Versions
```

### Install a package
```PowerShell
Find-WinGetPackage OpenJS.NodeJS -Exact | Install-WinGetPackage

Install-WinGetPackage 7zip.7zip
```

### Install a list of packages
```PowerShell
@('CPUID.CPU-Z','7zip.7zip') | ForEach-Object { Install-WinGetPackage $_ }
```

### Install a specific version of a package
```PowerShell
Install-WinGetPackage CPUID.CPU-Z -Version 1.95
```

### Install multiple packages with specific versions
```PowerShell
@(
    @{
        id = 'CPUID.CPU-Z'
        version = '1.95'
    },
    @{
        id = 'putty.putty'
        version = '0.74'
    }
) | Install-WinGetPackage
```

### Get list of installed packages
```PowerShell
Get-WinGetPackage nodejs
```

### Get list of installed packages that can be upgraded
```PowerShell
Get-WinGetPackageUpdate
```

### Upgrade a package
```PowerShell
Update-WinGetPackage CPUID.CPU-Z
```

### Upgrade a list of packages
```PowerShell
@('CPUID.CPU-Z','7zip.7zip') | ForEach-Object { Update-WinGetPackage -ID $_ }
```

### Upgrade all packages
> :warning: **Use at your own risk!** WinGet will try to upgrade all layered software it finds, may not always succeed, and may upgrade software you don't want upgraded.
```PowerShell
Update-WinGetPackage -All
```

### Uninstall a package
```PowerShell
Get-WinGetPackage nodejs | Uninstall-WinGetPackage

Uninstall-WinGetPackage 7zip.7zip
```

### Manage package sources
```PowerShell
Register-WinGetSource privateRepo -Argument 'https://somewhere/out/there/api/v2/'
Find-WinGetPackage nodejs -Source privateRepo -Exact | Install-WinGetPackage
Unregister-WinGetSource privateRepo
```

Cobalt integrates with WinGet.exe to manage and store source information

## Known Issues
### Stability
WinGet's behavior and APIs are still very unstable. Do not be surprised if this module stops working with newer versions of WinGet.

### Retrieving package upgrade list hangs on first use
Due to [a bug](https://github.com/microsoft/winget-cli/issues/1869) that [is resolved](https://github.com/microsoft/winget-cli/pull/1874) in WinGet v1.3 preview releases, if `Get-WinGetPackageUpdate` is ran with WinGet v1.2.x or below without having first accepted source license agreements, the cmdlet will hang indefinitely due to source agreements not having been accepted.

Available workarounds include:
* Running another cmdlet that invokes correctly-behaving WinGet behavior (ex: `Get-WinGetPackage`)
* Manually accepting the source agreement via the WinGet CLI

After WinGet v1.3 is generally available with the bug fixed, a new version of this module will be released to resolve this issue.

## Legal and Licensing
Cobalt is licensed under the [MIT license](./LICENSE.txt).
