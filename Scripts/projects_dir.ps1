$ArgName = $Args[0]

$ProjectNames = @{ `
    "dd" = "C:\AMD_Repos\devdriver"; `
    "ddtool" = "C:\AMD_Repos\dd-internal-tools"; `
    "dot" = "C:\Projects\DotFiles"; `
    "d3dsamples" = "C:\Projects\D3D12_Samples\Samples\Desktop"; `
    "prj" =  "C:\Projects"
}

if ($ArgName -ne $null -and $ProjectNames.ContainsKey($ArgName)) {
    Set-Location -Path $ProjectNames[$ArgName]
} else {
    Write-Output "Invalid project name. Available project names:"
    Write-Output $ProjectNames
}
