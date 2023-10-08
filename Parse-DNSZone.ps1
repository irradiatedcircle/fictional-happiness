###
#   Convert a DNS Zone to an object in PowerShell
#
#   Examples:
#       - Parse-DNSZone -FilePath ..\Downloads\example.com.txt
###
Function Parse-DNSZone() {
    [CmdletBinding()]
    Param(
        $Domain,
        $FilePath
    )

    $DNSFile = Get-Content -Path $FilePath
    $Records = @()
    ForEach ($Line in $DNSFile) {

        If ([String]::IsNullOrEmpty($Line) -or [String]::IsNullOrWhiteSpace($Line)) { Continue } ## Skip blank or empty lines
        If ($Line.StartsWith(";")) { Continue } ## Skip lines beginning with ';'
        If ($Line -match ";") { $Line = $Line.Split(";")[0] } ## Only return string before ';'
        $Array = -split $Line -join ' ' -split ' ' ## Remove all of extra blanks space and then split by them
        If ($Line -match "[0-9]+`n") { Continue } ## Remove SOA information
        
        If ($Array[0] -match 'ORIGIN' -and !$Domain) { $Domain = $Array[1]; } ## Record domain name
        If ($Array[0] -eq "IN") { $Array =  @($Records[-1].Name) + $Array } ## If record name blank, then return record name above it
        If ($Array[1] -notin @("IN","CS","CH","HS")) { $Array = @($Array[0]) + @("IN") + @($Array[1..($Array.Length - 1)]) } ## Add a class if one doesn't exist

        ## Removes the following: Records that are only numbers, empty lines.
        [System.Collections.ArrayList]$ArrayList = $Array
        $RemovalList = @()
        ForEach ($Value in $ArrayList) { If ($Value -match "^[\d]+$") { $RemovalList += $Value } }
        ForEach ($Item in $RemovalList) { $ArrayList.Remove($Item) }
        If ($ArrayList.Count -eq 0) { Continue }
        [System.Array]$Array = $ArrayList

        ## Skip any unsupported records
        If ($Array[2] -notin @("NS", "MX", "A", "AAAA", "CNAME", "SRV")) { 
            Continue 
        } 

        # Add record to array
        $Records += New-Object PSObject -Property @{
            Name = $Array[0]
            Class = $Array[1]
            Type = $Array[2]
            Value = $Array[3..($Array.Length - 1)]
        }    
    }

    Return New-Object PSObject -Property @{
        Domain = $Domain
        Records = $Records
    }
}

