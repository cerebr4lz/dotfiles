# My user level config file for ms powershell

# ====ALIASES====
# see below for related function definitions
Set-Alias rc Reload-Profile
Set-Alias grf Get-RecentFiles
Set-Alias bkp Backup-Files
Set-Alias mkgo Make-Go
Set-Alias os Get-SystemInfo
Set-Alias la List-AllDirs

# ====IMPORTS====
#Import-Module PSColor
Import-Module platyPS
#Import-Module Pansies
Import-Module posh-git
Import-Module Terminal-Icons

#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression
#oh-my-posh init pwsh | Invoke-Expression

# ====FUNCTIONS====

#function prompt {"PS $($PSVersionTable.PSVersion.ToString()) $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1))"}

# quick source [refresh] this config file.
function Reload-Profile {
        . $profile
}

# simple `grep` alternative
function grep($regex, $file) {
        select-string -Pattern $regex -Path $file -AllMatches | % { $_.Matches } | % { $_.Value }
}

# mkdir and cd in one command, a personal favorite
function Make-Go {
    param (
        [string]$Name
    )
    $NewDir = New-Item -Path $PWD -Name $Name -ItemType Directory
    Set-Location $NewDir
}

# Useful shortcuts for traversing directories
function .. { cd .. }
function ... { cd ..\.. }
function .... { cd ..\..\.. }

# Show hidden files when listing
function List-AllDirs {
    param([string]$Except)
    Get-ChildItem -Force
}

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepads
function n      { notepads $args }

# Drive shortcuts
function HKLM:  { Set-Location HKLM: }
function HKCU:  { Set-Location HKCU: }
function Env:   { Set-Location Env: }

function Get-RecentFiles {
    param (
        [string]$Path = (Get-Location),
        [int]$Count = 10
    )
    Get-ChildItem -Path $Path -File | Sort-Object LastWriteTime -Descending | Select-Object -First $Count
}

function Backup-Files {
    param (
        [string]$Source,
        [string]$Destination = 'Backups'
    )
    # TODO: Create backup logic (e.g., copy files to destination)
    # ...
    Write-Host "Backup completed."
}

function Get-SystemInfo {
    param (
        [switch]$Detailed
    )
    $OS = Get-CimInstance Win32_OperatingSystem
    $CPU = Get-CimInstance Win32_Processor
    $RAM = Get-CimInstance Win32_PhysicalMemory
    $Disk = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

    $RAMGB = ($RAM | Measure-Object -Property Capacity -Sum).Sum / 1GB
    $DiskFree = ($Disk | Measure-Object -Property FreeSpace -Sum).Sum / 1GB
    $DiskSize = ($Disk | Measure-Object -Property Size -Sum).Sum / 1GB

    [PSCustomObject]@{
        OSName = $OS.Caption
        OSVersion = $OS.Version
        CPU = $CPU.Name
        #RAM = "$($RAM.Capacity / 1GB) GB"
        RAM = "$RAMGB GB"
        #DiskSpace = "$($Disk.FreeSpace / 1GB) GB free of $($Disk.Size / 1GB) GB"
        DiskSpace = "$DiskFree GB free of $DiskSize GB"
        DetailedInfo = if ($Detailed) { $OS | Format-List } else { $null }
    }
}