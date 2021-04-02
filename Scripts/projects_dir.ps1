$ArgName = $Args[0]

$ProjectNames = @{ `
    "dd" = "C:\DevDriver\devdriver"; `
    "dot" = "C:\Projects\DotFiles"; `
    "cmds" = "C:\Projects\Cmds" `
}

if ($ArgName -ne $null -and $ProjectNames.ContainsKey($ArgName)) {
    Set-Location -Path $ProjectNames[$ArgName]
} else {
    Write-Output "Invalid project name. Available project names:"
    Write-Output $ProjectNames
}
