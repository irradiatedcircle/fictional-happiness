Function Get-AndroidFirmware() {
    [CmdletBinding()]
    Param(
        [Switch]$OTA)

    
    If (!$OTA) {
        $URL = "https://developers.google.com/android/images"
    } else {
        $URL = "https://developers.google.com/android/ota"
    }

    $UserAgent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
    $Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    $Cookie = New-Object System.Net.Cookie 

    $Cookie.Name = "devsite_wall_acks"
    $Cookie.Value = "`"nexus-image-tos,nexus-ota-tos`""
    $Cookie.Domain = "developers.google.com"

    $Session.Cookies.Add($Cookie);

    $WebRequest = Invoke-WebRequest $URL  -UserAgent $UserAgent -WebSession $Session
    $Titles = $WebRequest.ParsedHtml.getElementsByTagName("h2") | % { $_ }
    $Tables = $WebRequest.ParsedHtml.getElementsByTagName("table") | % { $_ }

    $Firmware = @()
    For ($i = 3; $i -lt $Titles.count; $i++) {
        $Codename = $Titles[$i].id
        Write-Output "Retrieving $($Titles[$i].innerText)..."
        $DeviceFirmwareList = $Tables[$i - 3]
    
        ForEach($Row in $DeviceFirmwareList.getElementsByTagName("tr")) {
            $Cells = $Row.getElementsByTagName("td") | % { $_ }
        
            If (!$Cells) {
                Continue
            }

            $Firmware += New-Object PSObject -Property @{
                Codename = $Codename
                Build = $Cells[0].innerText
                Link = ($Cells | ? { $_.innerText -eq "Link" }).children | % { $_.href }
                Checksum = $Cells[-1].innerText
            }
        }
    }

    Return $Firmware
}
