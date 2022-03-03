# PasswordExpiringNotifier

A simple PowerShell script to send people email alerts when their password is expiring. Currently configured to send emails when the password is expiring in 5 3 and 1 day/s.

The email server IP is stored in the Variables file and so is the email address that the emails will come from.

## Requirements

As the script now logs to Event Viewer it needs to have a source setup in Event Viewer, the source name is decided in the Variables.ps1 file. If the source doesn't exist the script will fail. To check if the source name exists you can run the following command from and Administrator PowerShell prompt:

    [System.Diagnostics.EventLog]::SourceExists("PutYourSourceNameHere")

If the above command returns *"False"* then run the following command to create the source, this also has to be run from an Administrator PowerShell prompt:

    [System.Diagnostics.EventLog]::CreateEventSource("PutYourSourceNameHere", "Application")

To check that the source was created correctly you can run the first command again, and now it should return *"True"*.

This script has only been tested using [PowerShell 7](https://github.com/PowerShell/powershell/releases) and requires the [Active Directory PowerShell module](https://docs.microsoft.com/en-us/powershell/module/addsadministration/?view=win10-ps) to to be installed.

## Usage

This script was intended to be run automatically, the best way to do this is to create a secheduled task to run it. I'd suggest every morning.
