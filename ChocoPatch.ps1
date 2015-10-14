# to do 
# test if chocolatey is installed, if not install it
# pull csv from github url

$installedapps = gp HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | ? {![string]::IsNullOrWhiteSpace($_.DisplayName) } | Select DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString -Unique| sort DisplayName 
$appmatch  =  ((get-content "S:\PowerShell\appmatch.csv") -replace ",","=") -join "`n" | convertfrom-stringdata
$cupblock="cup "

foreach ($thisapp in $installedapps.DisplayName) {
   If($appmatch.ContainsKey($thisapp) -eq $True)
    {$cupblock=$cupblock+ ' ' + $appmatch.Get_Item($thisapp)}
 }
 $cupblock =  $cupblock + " -y"
 $cupblock
# Invoke-Command -ScriptBlock $cupblock
cmd /c $cupblock
# $p = Start-Process choco -ArgumentList $cupblock -wait -NoNewWindow -WindowStyle Normal
# $p.HasExited
# $p.ExitCode