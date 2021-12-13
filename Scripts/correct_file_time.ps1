$ArgDir = $Args[0]

# If $ArgDir is $null, Get-ChildItem defaults to using current directory.
$ChildItems = Get-ChildItem -Recurse $ArgDir
$CurrTime = Get-Date
foreach ($Item in $ChildItems) {
    if ($Item -is [System.IO.FileInfo]) {
        if ($Item.LastWriteTime -gt $CurrTime) {
            Write-host "$($Item.FullName): $($Item.LastWriteTime)"
            $Item.LastWriteTime = $CurrTime
        }
    }
}
