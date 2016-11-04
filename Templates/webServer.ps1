Configuration MyService
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration, xNetworking, cChoco
	
	Node webServer
	{
		cChocoInstaller installChoco 
        { 
            InstallDir = "C:\choco" 
        }

		WindowsFeature webServer
		{
			Ensure = 'Present'
			Name = 'Web-Server'
		}
		xFirewall HTTP
		{
			Name = 'WebServer-HTTP-In-TCP'
			Group = 'Web Server'
			Ensure = 'Present'
			Action = 'Allow'
			Enabled = 'True'
			Profile = 'Any'
			Direction = 'Inbound'
			Protocol = 'TCP'
			LocalPort = 80
			DependsOn = '[WindowsFeature]webServer'
		}
		cChocoPackageInstaller trivialWeb 
        {            
            Name = "trivialweb" 
            Version = "1.0.0" 
            Source = “MY-NUGET-V2-SERVER-ADDRESS” 
            DependsOn = "[cChocoInstaller]installChoco", 
            "[WindowsFeature]installIIS" 
        } 
	}
}