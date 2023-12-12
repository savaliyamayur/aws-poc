Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value True
Set-Item WSMan:\localhost\Service\Auth\Basic  -Value True
Set-Item WSMan:\localhost\Client\AllowUnencrypted -Value True
Set-Item WSMan:\localhost\Client\Auth\Basic  -Value True
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -Profile Any -Enabled true
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP -Profile Any -Enabled true
New-NetFirewallRule -Name Terraform-http -DisplayName "Terraform http" -Enabled True -Profile Any -Action Allow -protocol tcp -RemotePort 5985
New-NetFirewallRule -Name Terraform-https -DisplayName "Terraform https" -Enabled True -Profile Any -Action Allow -protocol tcp -RemotePort 5986
net user Administrator some0thingG?me5
Set-ExecutionPolicy Bypass -Force

