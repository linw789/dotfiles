$Dir = $Args[0]

if ($Dir -ne $null) {
    Get-ChildItem -Force -Path $Dir
} else {
    Get-ChildItem -Force .
}

