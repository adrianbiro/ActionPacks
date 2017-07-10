﻿#Requires -Modules MSOnline

<#
    .SYNOPSIS
        Connect to MS Online and gets the properties from Azure Active Directory group
        Requirements 
        64-bit OS for all Modules 
        Microsoft Online Sign-In Assistant for IT Professionals  
        Azure Active Diretory Powershell Module
    
    .DESCRIPTION                        

    .Parameter O365Account
        Specifies the credential to use to connect to Azure Active Directory

    .Parameter GroupObjectId
        Specifies the unique ID of the group from which to get properties

    .Parameter GroupName
        Specifies the name of the group from which to get properties

    .Parameter TenantId
        Specifies the unique ID of the tenant on which to perform the operation
#>

param(
<#
    [Parameter(Mandatory = $true,ParameterSetName = "Group name")]
    [Parameter(Mandatory = $true,ParameterSetName = "Group object id")]
    [PSCredential]$O365Account,
#>
    [Parameter(Mandatory = $true,ParameterSetName = "Group object id")]
    [guid]$GroupObjectId,
    [Parameter(Mandatory = $true,ParameterSetName = "Group name")]
    [string]$GroupName,
    [Parameter(ParameterSetName = "Group name")]
    [Parameter(ParameterSetName = "Group object id")]
    [guid]$TenantId
)
 
# Import-Module MSOnline

#Clear

$ErrorActionPreference='Stop'

# Connect-MsolService -Credential $O365Account 

$Script:result = @()
$Script:Grp
if($PSCmdlet.ParameterSetName  -eq "Group object id"){
    $Script:Grp = Get-MsolGroup -ObjectId $GroupObjectId -TenantId $TenantId  | Select-Object *
}
else{
    $Script:Grp = Get-MsolGroup -TenantId $TenantId  | Where-Object {$_.Displayname -eq $GroupName} | Select-Object *
}
if($null -ne $Script:Grp){
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:Grp
    } 
    else{
        Write-Output $Script:Grp 
    }
}
else{
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Group not found"
    }    
    Write-Error "Group not found"
}