###
#   Generate a shift pattern
#
#   Examples:
#       - Generate-ShiftPattern -Member "John Smith" -MemberEmail "john.smith@example.com" -Group "Support Desk" -Date "01/01/2023"
###

Function Add-Shift() {
    [CmdletBinding()]
    Param(
        [String]$Member,
        [String]$WorkEmail,
        [String]$Group,
        [DateTime]$ShiftStartDateTime,
        [String]$Shared = "2. Not Shared",
        [String]$CustomisedLabel = "",
        [Int]$UnpaidBreak = "60",
        [String]$Theme = "2. Blue")

        Return New-Object PSObject -Property @{
            "Member" = $Member
            "Work Email" = $WorkEmail
            "Group" = $Group
            "Shift Start Date" = $ShiftStartDateTime.ToShortDateString()
            "Shift Start Time" = $ShiftStartDateTime.ToShortTimeString()
            "Shift End Date" = $ShiftStartDateTime.AddHours(12).ToShortDateString()
            "Shift End Time" = $ShiftStartDateTime.AddHours(12).ToShortTimeString()
            "Theme Colour" = $Theme
            "Customised Label" = $CustomisedLabel
            "Unpaid Break (minutes)"= $UnpaidBreak
            "Notes" = ""
            "Shared" = $Shared
        }
}

Function Generate-ShiftPattern() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][String]$Member,
        [Parameter(Mandatory=$False)][String]$MemberEmail,
        [Parameter(Mandatory=$False)][String]$Group,
        [Parameter(Mandatory=$False)][DateTime]$Date,
        [Parameter(Mandatory=$False)][Int]$Months = 12,
        [Parameter(Mandatory=$False)][String]$TimeZone,
        [Parameter(Mandatory=$False)][String]$Theme
    )

    $ArrayofDates = @()

    for ($i = 1; $i -le $Months; $i++) {

        Write-Host "Week 1 Starting: $($Date.ToString('dd/MM/yyyy'))"

        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddHours(19) -CustomisedLabel "Night" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(1).AddHours(19) -CustomisedLabel "Night" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(2).AddHours(19) -CustomisedLabel "Night" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(3).AddHours(19) -CustomisedLabel "Night" -Theme $Theme

        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(7).AddHours(7) -CustomisedLabel "Day" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(8).AddHours(7) -CustomisedLabel "Day" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(9).AddHours(7) -CustomisedLabel "Day" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(11).AddHours(19) -CustomisedLabel "Night" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(12).AddHours(19) -CustomisedLabel "Night" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(13).AddHours(19) -CustomisedLabel "Night" -Theme $Theme

        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(17).AddHours(7) -CustomisedLabel "Day" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(18).AddHours(7) -CustomisedLabel "Day" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(19).AddHours(7) -CustomisedLabel "Day" -Theme $Theme
        $ArrayofDates += Add-Shift -Member $Member -WorkEmail $MemberEmail -Group $Group -ShiftStartDateTime $Date.AddDays(20).AddHours(7) -CustomisedLabel "Day" -Theme $Theme

        $Date = $Date.AddDays(28)

    }

    Return $ArrayofDates
}