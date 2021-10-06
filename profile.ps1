function Prompt {
    $CmdPromptFullPath = $pwd
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $LastCmdFinishTime = Get-Date -Format 'hh:mm:ss tt'

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    #Calculate execution time of last cmd and convert to milliseconds, seconds or minutes
    $LastCommand = Get-History -Count 1
    if ($lastCommand) { $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime) }

    if ($RunTime.Minutes -gt 0) {
        $ElapsedTime = -join ($RunTime.Minutes, " min ", $RunTime.Seconds, " sec")
    } elseif ($RunTime.Seconds -gt 0) {
        $ElapsedTime = -join ($RunTime.Seconds, " sec ", $RunTime.Milliseconds, " ms")
    } else {
        $ElapsedTime = -join ($RunTime.Milliseconds, " ms")
    }

    #Decorate the CMD Prompt
    Write-host ""
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
	Write-host "$CmdPromptFullPath"  -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    Write-host " $LastCmdFinishTime " -ForegroundColor White
    Write-host "[$elapsedTime] " -NoNewline -ForegroundColor Green
    return "> "
}

# Script Aliases 
$ScriptsDir = "C:\Projects\DotFiles\Scripts"
Set-Alias -Name pd -Value $ScriptsDir\projects_dir.ps1
Set-Alias -Name ll -Value $ScriptsDir\list.ps1

# PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
