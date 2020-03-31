Function Add-OSCCredential
{
	$target = Read-Host "Internet or network address"
	$userName = Read-Host "UserName"
	$Password = Read-Host "Password" -AsSecureString
	If($target -and $userName)
	{
		If($Password)
		{
			[string]$result = cmdkey /add:$target /user:$userName /pass:$Password
		}
		Else
		{
			[string]$result = cmdkey /add:$target /user:$userName 
		}
		If($result -match "The command line parameters are incorrect")
		{
			Write-Error "Failed to add Windows Credential to Windows vault."
		}
		ElseIf($result -match "CMDKEY: Credential added successfully")
		{
			Write-Host "Credential added successfully."
		}
	}
	Else
	{
		Write-Error "Internet(network address) or username can not be empty,please try again."
		Add-OSCCredential
	}
	
}

Add-OSCCredential
