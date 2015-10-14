# Use at your own risk.  For Windows only.  This will script will attempt to do the following 
# Download Chocolatey if not installed
# Download matching applications text file
# Read your installed apps
# Update your applications based on a match in the Chocolatey repository.  

if ((Get-Command "chocolatey.exe" -ErrorAction SilentlyContinue) -eq $null) 
{ 
   Write-Host "Unable to find chocolatey, let's install"
   (iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
}

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
