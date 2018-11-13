$slackDir = "C:\Users\$env:UserName\AppData\Local\slack\app-3.3.3\resources\app.asar.unpacked\src\static"
$slackFile = "$slackDir\ssb-interop.js"
$slackBackup = "$slackDir\ssb-interop.js.bak"

If(!(Test-Path "$slackDir\ssb-interop.js.bak" -PathType Leaf)) {
  Copy-Item $slackFile -Destination $slackBackup
  Write-Output "Created a backup of your ssb-interop.js file at $slackBackup"
} Else {
  Write-Output "Verified there is already a backup of the ssb-interop.js file at $slackBackup"
}

$slackContent = Get-Content -Path $slackFile
If($slackContent -like "*https://raw.githubusercontent.com/dkbrookie/slackDarkmode/master/darkmode.css*") {
  Write-Warning "You already have the dark theme applied! Make sure to paste the exact text in a message to yourself on Slack, then click the 'Switch sidebar theme' button that appears."
  Write-Output  "#363636,#444A47,#8c8c8c,#FEFEFE,#434745,#FEFEFE,#99D04A,#DB6668"
} Else {
  "document.addEventListener('DOMContentLoaded', function () {$.ajax({url: 'https://raw.githubusercontent.com/dkbrookie/slackDarkmode/master/darkmode.css', success: function (css) {`$(""<style></style>"").appendTo('head').html(css);}});});" | Out-File $slackFile -Append -Encoding ASCII
  Stop-Process -Name slack -Force -EA 0 | Out-Null
  &"C:\Users\$env:UserName\AppData\Local\slack\slack.exe"
  Write-Warning "Paste the exact text in a message to yourself on Slack, then click the 'Switch sidebar theme' button that appears."
  Write-Output  "#363636,#444A47,#8c8c8c,#FEFEFE,#434745,#FEFEFE,#99D04A,#DB6668"
}
