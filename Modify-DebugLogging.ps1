<#PSScriptInfo

.VERSION 1.0

.GUID 1278246e-3486-4f83-9b2a-8efa60d952dd

.AUTHOR Bryan.Loveless@gmail.com

.COMPANYNAME 

.COPYRIGHT 2018

.TAGS Web

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


.PRIVATEDATA 

#>

<# 

.DESCRIPTION 
 

example: 
.\Modify-DebugLogging.ps1 -SiteFQName classrosternauappsnauedu -EnableLogging $true

#> 



param (
	[Parameter(Mandatory=$True,Position=1)]
	[string[]]$SiteFQName = $null,
	[Parameter(Mandatory=$True,Position=2)]
	[boolean[]]$EnableLogging = $true
)


#for testing:
$SiteFQName = "classrosternauappsnauedu"

$path = ('C:\inetpub\' + $SiteFQName+ '\logs')

if (!(test-path $path))
			    {
					    New-Item -ItemType Directory -Force -Path $path -ea inquire
			    }


#allow app pool user to write to that folder

# ref: https://dejanstojanovic.net/powershell/2018/january/setting-permissions-for-aspnet-application-on-iis-with-powershell/

  
$User = "IIS AppPool\" + $SiteFQName  
$Acl = Get-Acl $Path  
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($User,"Modify", "ContainerInherit,ObjectInherit", "None", "Allow")  
$Acl.SetAccessRule($Ar)  
Set-Acl $Path $Acl  

#Change the webconfig to write to the log directory
#using xml
$xmllocation = ('C:\inetpub\' + $SiteFQName+ '\web.config')

$xml = [xml] (Get-Content $xmllocation)

if ($EnableLogging -eq $False) {
    write-host "Setting to False now"
    $xml.configuration.'system.webServer'.aspNetCore.stdoutLogEnabled = 'False'
    $xml.Save($xmllocation)
}

elseif ($EnableLogging -eq $True) {
    write-host "Setting to True now"
    $xml.configuration.'system.webServer'.aspNetCore.stdoutLogEnabled = 'True'
    $xml.Save($xmllocation)
}


