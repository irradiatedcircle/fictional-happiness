[CmdletBinding()]
Param(
    $Path = "D:\ExternalDNS"
)

"can-i-haz"
"    .___                    .__                        .__          "
"  __| _/____   _____ _____  |__| ____           ______ |  | ________"
" / __ |/  _ \ /     \\__  \ |  |/    \   ______ \____ \|  | \___   /"
"/ /_/ (  <_> )  Y Y  \/ __ \|  |   |  \ /_____/ |  |_> >  |__/    / "
"\____ |\____/|__|_|  (____  /__|___|  /         |   __/|____/_____ \"
"     \/            \/     \/        \/          |__|              \/`n"


Write-Host "[*] Retireving can-i-take-over-xyz fingerprints..."
$Fingerprints = Invoke-RestMethod "https://raw.githubusercontent.com/EdOverflow/can-i-take-over-xyz/master/fingerprints.json"
Write-Host "[*] Retrieved information for $(($Fingerprints | ? { $_.vulnerable -eq $True}).Count) vulnerable services!`n"

If ((Get-Item $Path) -is [System.IO.DirectoryInfo]) {
    Write-Host "[*] Loading DNS files from $Path"
    $Files = Get-ChildItem $Path -Recurse
} else { 
    Write-Host "[*] Loading records from $Path"
    $Files = Get-ChildItem $Path
}

## Lets loop through the zone files...

$PotentiallyVulnerable = @()

ForEach ($ZoneFileLocation in $Files) {
    Write-Host "[*]`tSearching $($ZoneFileLocation.BaseName)"

    $ZoneFile = Parse-DNSZone -Domain $ZoneFileLocation.BaseName -FilePath $ZoneFileLocation.FullName
    $ZoneCNAMEs = $ZoneFile.Records | ? { $_.Type -eq "CNAME" }

    ForEach ($CNAME in $ZoneCNAMEs) {
        ForEach ($Service in $Fingerprints | ? { $_.status -eq "Vulnerable" -and $_.cname -ne "" }) {
            ForEach ($ServiceCNAME in $Service.cname) {
                If ($CNAME.Value -match $ServiceCNAME) {
                    Write-Host "[!] $($CNAME.Name) -> $($CNAME.Value) "
                    $PotentiallyVulnerable += New-Object PSObject -Property @{
                        URL = "$($CNAME.Name).$($ZoneFileLocation.BaseName)"
                        Value = $CNAME.Value
                        Service = $Service.service
                    }
                }
            }
        }
    }
}

$Results = $PotentiallyVulnerable
$VulnerableResults = @()
ForEach ($Result in $Results) {

    $OurDNSQuery = Try {
        Resolve-DnsName -Name $Result.URL -DnsOnly -ErrorAction Stop
    } Catch {
        Write-Host "[>] [WARNING] [$($Result.URL)] DNS Record does not resolve, outdated zone file."
        Continue
    }
    If ($OurDNSQuery.Name -contains ($Result.Value.TrimEnd("."))) {
        Write-Host "[>] [INFO] [$($Result.URL)] DNS Record exists."

        $Request = Try {
            Invoke-WebRequest ($Result.Value.TrimEnd("."))
        } Catch [System.Net.WebException] {
            Write-Verbose "An exception was caught: $($_.Exception.Message)"
            $_.Exception 
        }

        If ($Request -match "not be resolved") {
            Write-Host "[>] [WARNING] [$($Result.URL)] $($Result.Service) is vulnerable." -ForegroundColor Red
            Continue
        } else {

            Switch ($Request.Response.StatusCode) {
                200 {
                    Write-Host "[>] [INFO] [$($Result.URL)] $($Result.Service) exists."
                }

                "NotFound" {
                    Write-Host "[>] [INFO] $($Result.URL)] $($Result.Service) exists."
                    Continue
                }
            }
        }


  
    }    
}
