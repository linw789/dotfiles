$ArgName = $Args[0]

$ProjectNames_WorkPC = @{ `
    "dd" = "C:\AMD_Repos\devdriver"; `
    "tools" = "C:\AMD_Repos\internal-tools"; `
    "pal" = "C:\AMD_Repos\pal"; `
    "dot" = "C:\Projects\DotFiles"; `
    "d3dsamples" = "C:\Projects\D3D12_Samples\Samples\Desktop"; `
    "prj" =  "C:\Projects"
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

$HostName = [System.Net.Dns]::GetHostName()

if ($HostName -eq "LAPTOP-F9KFD4OS") {
    $ProjectNames = $ProjectNames_PersonalLaptop
} elseif ($HostName -eq "workpc") {
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
