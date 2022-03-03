# This file is required by the PasswordNotifierVersion Script

[Int] $DaysLeft = 1 

# Initialising variables that will be used later in the script
[string] $displayname = $null
[string] $remainingdays = $null

# Variables for Writing to Event Viewer
[int] $EventID = "10001"
[string] $Source = "Password Expiring"
[string] $LogName = "Application"
[string] $EventMessage1 = "Sending email to user with the following details:"
[string] $EventMessage2 = "`n`nPassword will expire in "

# Variables revolving around the E-Mail
$smtpServer = “” # Change this to be your mail relay
$EmailFrom = "" # Change this to be the email that you want the email to come from

$Body1=@"
<html>
<head>
<style>
<-- /* Font Definitions */
@font-face
{font-family:Calibri;
panose-1:2 15 5 2 2 2 4 3 2 4;
mso-font-charset:0;
mso-generic-font-family:swiss;
mso-font-pitch:variable;
mso-font-signature:-469750017 -1073732485 9 0 511 0;}
p.MsoNormal, li.MsoNormal, div.MsoNormal
{mso-style-unhide:no;
mso-style-qformat:yes;
mso-style-parent:"";
margin:0cm;
margin-bottom:.0001pt;
mso-pagination:widow-orphan;
font-size:11.0pt;
font-family:"Calibri",sans-serif;
mso-fareast-font-family:Calibri;
mso-fareast-theme-font:minor-latin;
mso-fareast-language:EN-US;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
{mso-style-priority:34;
mso-style-unhide:no;
mso-style-qformat:yes;
margin-top:0cm;
margin-right:0cm;
margin-bottom:0cm;
margin-left:36.0pt;
margin-bottom:.0001pt;
mso-pagination:widow-orphan;
font-size:11.0pt;
font-family:"Calibri",sans-serif;
mso-fareast-font-family:Calibri;
mso-fareast-theme-font:minor-latin;
mso-fareast-language:EN-US;}
-->
</style>
</head>
<body>
<p class=MsoNormal>Hello 
"@
$Body2 = @"
</p>
<p class=MsoNormal><o:p>&nbsp;</o:p></p>
<p class=MsoNormal>Please note that your password will expire in 
"@
$Body3 = @"
 days`&apos` time, to change it now please follow the instructions below, please be aware that these instructions require you to be on the VPN or in the office connected to the Corporate network:-</p>
<p class=MsoNormal><o:p>&nbsp;</o:p></p>
<ol style='margin-top:0cm' start=1 type=1>
<li class=MsoListParagraph style='margin-left:0cm;mso-list:l0 level1 lfo3'><span style='mso-fareast-font-family:"Times New Roman"'>Press <i>Control + Alt + Delete</i><o:p></o:p></span></li>
<li class=MsoListParagraph style='margin-left:0cm;mso-list:l0 level1 lfo3'><span style='mso-fareast-font-family:"Times New Roman"'>Click <i>Change a password</i><o:p></o:p></span></li>
<li class=MsoListParagraph style='margin-left:0cm;mso-list:l0 level1 lfo3'><span style='mso-fareast-font-family:"Times New Roman"'>Enter your current password and then enter your new password using the following criteria:- Your password must not use any part of your name, or company name and it must contain 3 out of the 4 of, upper case, lower case, numbers and special characters ( &, !, etc). Please do not use 	&pound;, $ or @ as it interferes with certain apps.<o:p></o:p></span></li>
</ol>
<br /><p class=MsoNormal>Best regards,</p>
<p class=MsoNormal><b><span lang=NL style='font-size:18.0pt;font-family:"Microsoft Sans Serif",sans-serif;
color:#262626;mso-ansi-language:NL;mso-fareast-language:EN-GB'>IT<o:p></o:p></span></b></p> <br /><br />
</body>
</html>
"@