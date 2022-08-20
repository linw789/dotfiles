$ArgName = $Args[0]

$ProjectNames_WorkPC = @{ `
    "dd" = "C:\develop\devdriver"; `
    "tools" = "C:\develop\internal-tools"; `
    "pal" = "C:\develop\pal"; `
    "dot" = "C:\Projects\DotFiles"; `
    "dxcp" = "C:\develop\dxcp\drivers\dx\dxcp"
}

$ProjectNames_WorkLaptop = @{ `
    "dd" = "C:\develop\amd\devdriver"; `
    "tools" = "C:\develop\amd\internal-tools"; `
    "pal" = "C:\develop\amd\pal"; `
    "dot" = "C:\develop\dotfiles"; `
    "d3dsamples" = "C:\develop\D3D12_Samples\Samples\Desktop"; `
    "prj" =  "C:\develop"; `
    "dxcp" = "C:\develop\amd\dxcp\drivers\dx\dxcp"; `
    "dxxp" = "C:\develop\amd\dxxp\drivers\dx\dxxp"
}

$ProjectNames_PersonalLaptop = @{ `
    "prj" =  "C:\Projects"; `
    "dot" = "C:\Projects\DotFiles"; `
    "super" = "C:\Projects\SuperCleo"; `
    "vkrust" = "C:\Projects\VulkanExamplesRust"; `
    "vkcpp" = "C:\Projects\VulkanExamplesCpp"
}

$ProjectNames_PersonalPC = @{ `
    "prj" =  "C:\Projects"; `
    "dot" = "C:\Projects\dotfiles";
}

$HostName = [System.Net.Dns]::GetHostName()

if ($HostName -eq "LAPTOP-F9KFD4OS") {
    $ProjectNames = $ProjectNames_PersonalLaptop
} elseif ($HostName -eq "DESKTOP-388OQ16") {
    $ProjectNames = $ProjectNames_PersonalPC
} elseif ($HostName -eq "DESKTOP-N9CIN42") {
    $ProjectNames = $ProjectNames_WorkPC
} elseif ($HostName -eq "BDCLX-LINWANG") {
    $ProjectNames = $ProjectNames_WorkLaptop
} else {
    Write-Output "Unrecognized host name: $HostName."
}

if ($ArgName -ne $null -and $ProjectNames.ContainsKey($ArgName)) {
    Set-Location -Path $ProjectNames[$ArgName]
} else {
    Write-Output "Invalid project name. Available project names:"
    Write-Output $ProjectNames
}
