# fictional-happiness
Collection of scripts that were developed for one reason or another

## PowerShell

### Get-AndroidFirmware
Retrieve both factory and OTA firmware download links from https://developers.google.com/android/

### Generate-ShiftPattern
Generate the DuPont shift pattern that you are able to import into Microsoft Teams

### Hive4PS
A PowerShell wrapper for TheHive allowing the automation of creating alerts and modifying tickets via it's API.

### Parse-DNSZone
Convert DNS Zones to objects in PowerShell
```
PS C:\Users\User> $DNS = Parse-DNSZone -Domain "example.com" -FilePath "$env:USERPROFILE\Documents\example.com.zone"

Domain      Records
------      -------
example.com {@{Type=NS; Name=; Value=System.Object[]; Class=IN...

PS C:\Users\User> $DNS.Records

Name Class Type  Value
---- ----- ----  -----
     IN    NS    {ns1.example.com.}
     IN    NS    {ns2.smokeyjoe.com.}
     IN    MX    {mail.another.com.}
ns1  IN    A     {192.168.0.1}
www  IN    A     {192.168.0.2}
ftp  IN    CNAME {www.example.com.}
bill IN    A     {192.168.0.3}
fred IN    A     {192.168.0.4}
```