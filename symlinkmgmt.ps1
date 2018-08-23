function New-Symlink {
    <#
    .SYNOPSIS
        Creates a symbolic link, of a type
    #>
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Link,
        [Parameter(Position=1, Mandatory=$true)]
        [string] $Target,
        [Parameter(Position=2, Mandatory=$true)]
        [ValidateSet("Hard", "Soft", "Junk")]
        [string] $Type
    )

    Write-Host "New-Symlink $Type from $Link to $Target"
    
    Invoke-MKLINK -Link $Link -Target $Target -Type $Type
}

function Invoke-MKLINK {
    <#
    .SYNOPSIS
        Creates a symbolic link.
    #>
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Link,
        [Parameter(Position=1, Mandatory=$true)]
        [string] $Target,
        [Parameter(Position=2, Mandatory=$true)]
        [ValidateSet("Hard", "Soft", "Junk")]
        [string] $Type
    )
    
    # Resolve the paths incase a relative path was passed in.
    $Link = (Force-Resolve-Path $Link)
    $Target = (Force-Resolve-Path $Target)

    # Ensure target exists.
    if (-not(Test-Path $Target)) {
        throw "Target does not exist.`nTarget: $Target"
    }

    # Ensure link does not exist.
    if (Test-Path $Link) {
        Write-Host "A file or directory already exists at the link path.`nLink: $Link"
        return
    }

    $isDirectory = (Get-Item $Target).PSIsContainer
    
    if ($Type = "Hard"){
        $Itype = "Hardlink"
    }elseif ($Type = "Soft") {
        $Itype = "SymbolicLink"
    }else {
        $Itype = "Junction"
    }

    New-Item -ItemType SymbolicLink -Name $Link -Target $Target 

    # Capture the MKLINK output so we can return it properly.
    # Includes a redirect of STDERR to STDOUT so we can capture it as well.
    #$output = cmd /c mklink /D `"$Link`" `"$Target`" 2>&1
    
    #Write-Host "output : $output"
    #if ($lastExitCode -ne 0) {
    #    Write-Host "MKLINK failed. Exit code: $lastExitCode`n$output"
    #    throw "MKLINK failed. Exit code: $lastExitCode`n$output"
    #}
    #else {
    #    Write-Output $output
    #}
}

function Force-Resolve-Path {
    <#
    .SYNOPSIS
        Calls Resolve-Path but works for files that don't exist.
    .REMARKS
        From http://devhawk.net/2010/01/21/fixing-powershells-busted-resolve-path-cmdlet/
    #>
    param (
        [string] $FileName
    )
    
    $FileName = Resolve-Path $FileName -ErrorAction SilentlyContinue `
                                       -ErrorVariable _frperror
    if (-not($FileName)) {
        $FileName = $_frperror[0].TargetObject
    }
    
    return $FileName
}
$link_path = 'C:\Test\Symtests\current\'
$target_path = 'C:\Test\Symtests\0.0.0.1\'
New-Symlink $link_path $target_path -Type "Soft"