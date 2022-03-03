Clear-Host # Clear the screen before the script outputs anything

# Setting up PowerShell
# Import AD Module
Import-Module ActiveDirectory 
# Remove all variables
Remove-Variable * -ErrorAction SilentlyContinue 

# Source the file where the variables are stored Write-Output "Outside the function but in the loop" Write-Output "Variable To: $To"
. "$PSScriptRoot\Variables.ps1" 

# Defining functions
function Send-Email 
{
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $local:To,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $local:Subject,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $local:Body
    )
    # Testing
    Write-Output "Variable To: $To"
    Write-Output "Variable Subject: $Subject"
    # Creating the email object and setting it up
    $Message = New-Object Net.Mail.MailMessage
    $Message.From = $EmailFrom
    $Message.To.Add($To)
    $Message.Subject = $Subject
    $Message.Body = $local:Body
    $Message.IsBodyHtml = $True
    
    # Actually sending the email
    $smtpclient = New-Object Net.Mail.SmtpClient($SMTPServer)
    $smtpclient.Send($Message)
}

function Write-EventLogEntry
{
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [int] $local:EventID,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $local:EventMessage,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $local:LogName,
        [Parameter(Mandatory=$true, Position=3)]
        [string] $local:Source,
        [Parameter(Mandatory=$true, Position=4)]
        [int] $local:Type
    )

    # Setup the Event Types, the only one that the script is currently using is Information, however they are all here for a reference
    # [System.Diagnostics.EventLogEntryType]::Information   Argument 'Type'  number: 1
    # [System.Diagnostics.EventLogEntryType]::Error         Argument 'Type'  number: 2
    # [System.Diagnostics.EventLogEntryType]::Warning       Argument 'Type'  number: 3
    # [System.Diagnostics.EventLogEntryType]::SuccessAudit  Argument 'Type'  number: 4
    # [System.Diagnostics.EventLogEntryType]::FailureAudit  Argument 'Type'  number: 5

    if ( $type -eq 1 ) { $local:EventType = [System.Diagnostics.EventLogEntryType]::Information }
    elseif ( $type -eq 2 ) { $local:EventType = [System.Diagnostics.EventLogEntryType]::Error }
    elseif ( $type -eq 3 ) { $local:EventType = [System.Diagnostics.EventLogEntryType]::Warning }
    elseif ( $type -eq 4 ) { $local:EventType = [System.Diagnostics.EventLogEntryType]::SuccessAudit }
    elseif ( $type -eq 5 ) { $local:EventType = [System.Diagnostics.EventLogEntryType]::FailureAudit }

    # Create Event Log object
    $EventLog=New-Object System.Diagnostics.EventLog($LogName)
    # Declare Event Source; must be 'registered' with Windows
    $EventLog.Source=$Source 
    
    # Write the event in the format "Event message",EventType,EventID
    $EventLog.WriteEntry($EventMessage,$EventType,$EventID)
}

# The main script
While ($DaysLeft -le 5) {   
    Write-Output "Days left: $daysleft"
    ForEach-Object { Get-ADUser -filter * -Properties "msDS-UserPasswordExpiryTimeComputed",passwordneverexpires,userprincipalname,passwordexpired,displayname | Where-Object { $_.Enabled -eq $True} | Where-Object { $_.PasswordExpired -eq $False} | Where-Object { $_.PasswordNeverExpires -eq $False } } | Select-Object name,userprincipalname,displayname,samaccountname,@{Name="Expiry";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},@{Name="RemainingDays";Expression={(new-timespan -start $(Get-Date) -end ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed"))).Days}} | Where-Object { $_.remainingdays -eq $DaysLeft} | ForEach-Object { # Get AD users with expiring passwords
        $displayname = $_.displayname
        $remainingdays = $_.remainingdays
        $private:To = $_.userprincipalname 
        $private:Subject = "Password expiring in $remainingdays days"
        Send-Email $To $Subject "$Body1 $displayname, $Body2 $remainingdays $Body3"
        Write-Output "Display name: $displayname`n To: $To`n Subject: $Subject`n" # For testing purposes
        Start-Sleep(10)
        Write-EventLogEntry 10001 "$EventMessage1 $DisplayName $To $EventMessage2 $remainingdays days" $LogName $Source 1
    }
    $DaysLeft = $daysleft + 2
} 