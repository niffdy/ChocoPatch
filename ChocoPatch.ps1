# to do 
# test if chocolatey is installed, if not install it

$url = "https://raw.githubusercontent.com/niffdy/ChocoPatch/master/appmatch.csv"
$csvapplist = "$env:TEMP\appmatchtemp.csv"
# $csvapplist
(New-Object System.Net.WebClient).DownloadFile($url, $csvapplist)

$installedapps = gp HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | ? {![string]::IsNullOrWhiteSpace($_.DisplayName) } | Select DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString -Unique| sort DisplayName 
$appmatch  =  ((get-content $csvapplist) -replace ",","=") -join "`n" | convertfrom-stringdata
$cupblock="cup "

foreach ($thisapp in $installedapps.DisplayName) {
   If($appmatch.ContainsKey($thisapp) -eq $True)
    {$cupblock=$cupblock+ ' ' + $appmatch.Get_Item($thisapp)}
 }
 $cupblock =  $cupblock + " -y"
 $cupblock
cmd /c $cupblock
