<# : batch portion
title Initialization..
mode con: lines=5
@echo off & (for %%I in ;(%*) do @echo(%%~I) | ^
powershell.exe -noexit -noprofile -command "$argv = $input | ?{$_}; iex (${%~f0} | out-string)"
: end batch / begin powershell #>

Get-ChildItem $argv | ForEach-Object {

    $round++

    $Host.UI.RawUI.WindowTitle = "[$($round)/$($argv.count)] Encoding $($_.Name)"

    [String]$Out = Join-Path $_.Directory ($_.BaseName + ' - comp.mp4')

    ffmpeg -i `"$($_.FullName)`" -loglevel warning -stats -c:v libx264 -crf 35 -tune fastdecode -preset ultrafast `"$($out)`"
    if ($LASTEXITCODE -ne 0){pause}

    if ($round -ne $argv.count){Clear-Host}
}
exit
