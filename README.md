# fictional-happiness
A collection of scripts that were developed for one reason or another. Feel free to contribute or request features, just know that these are worked on during spare time or as necessary.

## Get-AndroidFirmware
Retrieve both factory and OTA firmware download links from https://developers.google.com/android/
```
PS C:\Users\User> Get-AndroidFirmware | ? { $_.Codename -eq "Cheetah" }

Link     : https://dl.google.com/dl/android/aosp/panther-up1a.231005.007.a1-factory-2ce509e3.zip
Build    : 14.0.0 (UP1A.231005.007.A1, Oct 2023, Japan)
Checksum : 2ce509e386453d857c7544b85ab2c3e4d4fa22c42dcdb3e1f65aceaec78cfde4
Codename : cheetah
```

## Generate-ShiftPattern
Generate the DuPont shift pattern that you are able to import into Microsoft Teams. The output needs to be exported to an excel spreadsheet to be able to be imported into Teams.
 
```
Generate-ShiftPattern -Member "John Smith" -MemberEmail "john.smith@example.com" -Group "Support Desk" -Date "01/01/2023"
```

## Hive4PS
A PowerShell wrapper for TheHive allowing the automation of creating alerts and modifying tickets via it's API.

## Parse-DNSZone
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

## domain-plz
A draft variation of the can-i-haz-xyz to look up dangling subdomains. Only currently supports services with CNAMEs.

## ImposterAI
A [Google Chrome extension](https://chromewebstore.google.com/detail/imposterai/dglanhchpmkhoiinklkdjlkjkjpopilh) that actively reads and modifies the content of the [CultureAI](https://www.culture.a) platform. In it's current state, the extension adds a 'triage' button for analysts to use to search their own Microsoft Sentinel instance. Example configuration options are as follows:

```
Subsciption ID                       Resource Group Workspace Name
--------------                       -------------- --------------
49170a36-4033-430c-a464-3830749df2ca prod-sentinel  prod-sentinel

Query
-----
MessageTrace | where TimeGenerated > ago(7d) | where Subject_s startswith "{0}" | project TimeGenerated, MessageId_s, SenderAddress_s, RecipientAddress_s, Subject_s, Status_s, FromIP_s, Size_d, ToIP_s
```

### To-do
- [x] Create extension that monitors table
- [x] Add button to dynamic rows
- [x] Implement a pop up to add user's configuration
- [x] Add Microsoft Sentinel integration
- [ ] Add URLScan integration
- [ ] Add VirusTotal integration
- [ ] Replace CultureAI with ImposterAI logo
