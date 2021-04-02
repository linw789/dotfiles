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
        $ElapsedTime = -join ($RunTime.Seconds, " sec", $RunTime.Milliseconds, " ms")
    } else {
        $ElapsedTime = -join ($RunTime.Milliseconds, " ms")
    }

    #Decorate the CMD Prompt
    Write-Host ""
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
	Write-Host " $CmdPromptFullPath"  -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    Write-Host " $LastCmdFinishTime " -ForegroundColor White
    Write-Host "[$elapsedTime] " -NoNewline -ForegroundColor Green
    return "> "
}
