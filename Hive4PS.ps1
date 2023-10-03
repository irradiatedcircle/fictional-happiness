Class Hive4PS {
    [String]$Endpoint
    [HashTable]$Headers

    Hive4PS($Endpoint, $Key) {

        $This.Endpoint = $Endpoint
        $This.Headers = @{
            "Authorization" = "Bearer $Key"
            "Content-Type" = "application/json"
        }

    }

    [Object]Get_Current_User() {
        $URL = $This.Endpoint + "/api/user/current"
        $Result = Invoke-RestMethod $URL -Headers $This.Headers

        Return $Result
    }

    [Object]Create_Case($Case) {
        
        If ($Case -is [HashTable]) {
            $Case = $Case | ConvertTo-Json
        }

        $URL = $This.Endpoint + "/api/v1/case"
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers -Body $Case

        Return $Result
    }

    [Object]Delete_Case($CaseID) {

        $URL = $This.Endpoint + "/api/v1/case/$CaseID"
        $Result = Invoke-RestMethod $URL -Method Delete -Headers $This.Headers

        Return $Result
    }

    [Object]Create_Observable($CaseID, $Observable) {

        If ($Observable -is [HashTable]) {
            $Observable = $Observable | ConvertTo-Json
        }
 
        $URL = $This.Endpoint + "/api/case/" + $CaseID + "/artifact"
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers -Body $Observable

        Return $Result
    }

    [Object]Create_Observable_File($CaseID, $FilePath, $Description) {

        Add-Type -AssemblyName "System.Web"
        $FileName = $FilePath.Substring($FilePath.LastIndexOf("/") + 1)
        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
       
        $MimeType = [System.Web.MimeMapping]::GetMimeMapping($FilePath)

        $fileEnc = [System.Text.Encoding]::GetEncoding('iso-8859-1').GetString($fileBytes)
        $boundary = [System.Guid]::NewGuid().ToString()
        $lineFeed = "`r`n"

        $Body = ( 
            "--$boundary",
            "Content-Disposition: form-data; name=`"dataType`";",
            "Content-Type: text/plain$lineFeed",
            "file",
            "--$boundary",
            "Content-Disposition: form-data; name=`"message`";",
            "Content-Type: text/plain$lineFeed",
            "$Description",
            "--$boundary",
            "Content-Disposition: form-data; name=`"attachment`"; filename=`"$($FileName)`"",
            "Content-Type: $MimeType" + $lineFeed,
            $fileEnc,
            "--$boundary--$lineFeed" 
        ) -join $lineFeed


        $URL = $This.Endpoint + "/api/case/" + $CaseID + "/artifact"

        $This.Headers."Content-Type" = "multipart/form-data; boundary=`"$boundary`""
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers  -Body $Body
        $This.Headers."Content-Type" = "application/json"

        Return $Result
    }

    [Object]Delete_Observable($ObservableID) {

        $URL = $This.Endpoint + "/api/case/artifact/$ObservableID"
        $Result = Invoke-RestMethod $URL -Method Delete -Headers $This.Headers

        Return $Result
    }

    [Object]Create_Task($CaseID, $Task) {

        If ($Task -is [HashTable]) {
            $Task = $Task | ConvertTo-Json
        }

        $URL = $This.Endpoint + "/api/case/" + $CaseID + "/task"
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers -Body $Task

        Return $Result
    }

    [Object]Delete_Task($TaskID) {
        
        $Data = @{ status = "Cancel" } | ConvertTo-Json

        $URL = $This.Endpoint + "/api/case/task/" + $TaskID
        $Result = Invoke-RestMethod $URL -Method Patch -Headers $This.Headers -Body $Data

        Return $Result
    }

    [Object]Create_Task_Log($TaskID, $Message) {

        $Log = @{ message = $Message } | ConvertTo-Json
        
        $URL = $This.Endpoint + "/api/v1/task/" + $TaskID + "/log"
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers -Body $Log

        Return $Result
    }

    [Object]Create_Alert($Alert) {
        
        If ($Alert -is [HashTable]) {
            $Alert = $Alert | ConvertTo-Json
        }

        $URL = $This.Endpoint + "/api/alert"
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers -Body $Alert

        Return $Result
    }

    [Object]Delete_Alert($AlertID) {

        $URL = $This.Endpoint + "/api/alert/$AlertID"
        $Result = Invoke-RestMethod $URL -Method Delete -Headers $This.Headers

        Return $Result
    }

    [Object]Create_Alert_Observable($AlertID, $Artifact) {
        
        If ($Artifact -is [HashTable]) {
            $Artifact = $Artifact | ConvertTo-Json
        }

        $URL = $This.Endpoint + "/api/alert/" + $AlertID + "/artifact"
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers -Body $Artifact

        Return $Result
    }

    [Object]Create_Alert_Observable_File($AlertID, $FilePath, $Description) {

        Add-Type -AssemblyName "System.Web"
        $FileName = $FilePath.Substring($FilePath.LastIndexOf("/") + 1)
        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
       
        $MimeType = [System.Web.MimeMapping]::GetMimeMapping($FilePath)

        $fileEnc = [System.Text.Encoding]::GetEncoding('iso-8859-1').GetString($fileBytes)
        $boundary = [System.Guid]::NewGuid().ToString()
        $lineFeed = "`r`n"

        $Body = ( 
            "--$boundary",
            "Content-Disposition: form-data; name=`"dataType`";",
            "Content-Type: text/plain$lineFeed",
            "file",
            "--$boundary",
            "Content-Disposition: form-data; name=`"message`";",
            "Content-Type: text/plain$lineFeed",
            "$Description",
            "--$boundary",
            "Content-Disposition: form-data; name=`"attachment`"; filename=`"$($FileName)`"",
            "Content-Type: $MimeType" + $lineFeed,
            $fileEnc,
            "--$boundary--$lineFeed" 
        ) -join $lineFeed


        $URL = $This.Endpoint + "/api/alert/" + $AlertID + "/artifact"

        $This.Headers."Content-Type" = "multipart/form-data; boundary=`"$boundary`""
        $Result = Invoke-RestMethod $URL -Method Post -Headers $This.Headers  -Body $Body
        $This.Headers."Content-Type" = "application/json"

        Return $Result
    }

    [Object]Delete_Alert_Observable($ObservableID) {

        $URL = $This.Endpoint + "/api/alert/artifact/$ObservableID"
        $Result = Invoke-RestMethod $URL -Method Delete -Headers $This.Headers

        Return $Result
    }
}
