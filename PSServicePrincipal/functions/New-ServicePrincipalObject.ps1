﻿Function New-ServicePrincipalObject
{
    <#
    .SYNOPSIS
        PowerShell module for creating a Azure Enterprise Applications (Service Principals) for automation tasks.

    .DESCRIPTION
        This module will create a new Azure active directory enterprise application and Service Principal that can be used for application automation.
        Enterprise applications are Service Principal objects that mirror the applications.
        Logging Provider: All messages are logged by default 'Documents\PowerShell Script Logs' on Windows and 'Documents/PowerShell Script Logs' on MacOS
        There are two logging folders for analysis: Get-LogFolder -LogFolder [OutputLoggingFolder] and [DebugLoggingFolder]
        For more information please visit: https://psframework.org/
        PSFramework Logging: https://psframework.org/documentation/quickstart/psframework/logging.html
        PSFramework Configuration: https://psframework.org/documentation/quickstart/psframework/configuration.html
        PSGallery - PSFramework module - https://www.powershellgallery.com/packages/PSFramework/1.0.19

    .PARAMETER CreateSingleObject
        This switch is used when creating a single default Enterprise Application (Service Principal).

    .PARAMETER CreateBatchObjects
        This switch is used when creating a batch of Service Principals from a text file.

    .PARAMETER CreateSPNWithAppID
        This switch is used when creating a Service Principal and a registered Azure ApplicationID.

    .PARAMETER CreateSPNWithPassword
        This switch is used when creating a Service Principal and a registered Azure application with a user supplied password.

    .PARAMETER CreateSPNsWithNameAndCert
        This switch is used when creating a Service Principal and a registered Azure application using a display name and certificate.

    .PARAMETER DeleteApp
        This parameter is a switch used to delet3 an Azure application.

    .PARAMETER DeleteSpn
        This parameter is a switch used to delete a Service Principal.

    .PARAMETER EnableException
        This parameter disables user-friendly warnings and enables the throwing of exceptions.
        This is less user friendly, but allows catching exceptions in calling scripts.

    .PARAMETER GetAppByName
        This switch is used to retrieve a Registered Application from the Azure active directory via display name.

    .PARAMETER GetSPNByName
        This switch is used to retrieve a Service Principal object from the Azure active directory via display name.

    .PARAMETER GetSPNByAppID
        This switch is used to retrieve a Service Principal object from the Azure active directory via ApplicationID.

    .PARAMETER GetSPNSByName
        This switch is used to retrieve a batch of Service Principal objects via wildcard search from the Azure active directory.

    .PARAMETER GetAppAndSPNPair
        This switch is used to retrieve an Application and Service Principal pair from the Azure active directory.

    .PARAMETER OpenAzurePortal
        This switch is used to when connecting to the online web Azure portal.

    .PARAMETER Reconnect
        This parameter switch is used when forcing a new connection to an Azure tenant subscription.

    .PARAMETER RemoveAppOrSpn
        This switch is used to delete a single Azure Application or Service Principal from the Azure active directory.

    .PARAMETER RemoveAppAndSPNPairByID
        This switch is used to delete an Application and Service Principal pair from the Azure active directory.

    .PARAMETER RegisteredApp
        This parameter is is used when working on Registered Azure Applications (not Enterprise Applications).

    .PARAMETER ApplicationID
        This parameter is the unique ApplicationID for a Service Principal in a tenant. Once created this property cannot be changed.

    .PARAMETER Certificate
        This parameter is the value of the "asymmetric" credential type. It represents the base 64 encoded certificate.

    .PARAMETER DisplayName
        This parameter is the friendly name of the Service Principal you want to create.

    .PARAMETER NameFile
        This parameter is the name of the file that contains the list of Service Principals being passed in for creation.

    .PARAMETER ObjectID
        This parameter is the unique ObjectID for a Service Principal in a tenant. Once created this property cannot be changed.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -CreateSingleObject

        This example creates a new Service Principal with a display name of 'CompanySPN' and password (an autogenerated GUID) and creates the Service Principal based on the application just created. The start date and end date are added to password credential.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -CreateSingleObject -CreateSPNWithPassword

        This example creates a new Enterprise Application and Service Principal with a display name of 'CompanySPN' and a (user supplied password) and creates the Service Principal based on the application just created. The start date and end date are added to password credential.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ApplicationID 34a23ad2-dac4-4a41-bc3b-d12ddf90230e -CreateSPNWithAppID

        This example creates a new Enterprise Application and Service Principal with the ApplicationID '34a23ad2-dac4-4a41-bc3b-d12ddf90230e'.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -NameFile c:\temp\YourFileContainingNames.txt -CreateBatchObjects

        This example connects to an Azure tenant and creates a batch of Enterprise Applications and Service Principal objects from a file passed in.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -CreateSPNsWithNameAndCert -Certificate <public certificate as base64-encoded string>

        This example creates a new Enterprise Application and Service Principal with a display name of 'CompanySPN' and certifcate and creates the Service Principal based on the application just created. The end date is added to key credential.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -Reconnect

        This example will force a reconnect to a specific Azure tenant.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -GetSpnByName

        This example will retrieve a Service Principal from the Azure active directory by display name.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ApplicationID 34a23ad2-dac4-4a41-bc3b-d12ddf90230e -GetSpnByAppID

        This example will retrieve a Service Principal from the Azure active directory by ApplicationID.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -GetSPNSByName

        This example will retrieve a batch of Service Principal objects from the Azure active directory by display name.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -GetAppByName

        This example will retrieve a Enterprise Application from the Azure active directory.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -DisplayName CompanySPN -GetAppAndSPNPair

        This example will retrieve a Service Principal and Application pair from the Azure active directory.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ApplicationID 34a23ad2-dac4-4a41-bc3b-d12ddf90230e -RemoveAppAndSPNPairByID

        This example will delete a Service Principal and Application pair from the Azure active directory using the ApplicationID '34a23ad2-dac4-4a41-bc3b-d12ddf90230e'.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ObjectID 94b26zd1-fah2-1a25-bsc5-7h3d6j3s5g3h -RemoveAppAndSPNPairByID

        This example will delete a Service Principal and Application pair from the Azure active directory using the ObjectID '94b26zd1-fah2-1a25-bsc5-7h3d6j3s5g3'.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ApplicationID 34a23ad2-dac4-4a41-bc3b-d12ddf90230e -RemoveAppOrSpn -DeleteSpn

        This example will delete a single Service Principal from the Azure active directory using the -ApplicationID '34a23ad2-dac4-4a41-bc3b-d12ddf90230e'

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ObjectID 94b26zd1-fah2-1a25-bsc5-7h3d6j3s5g3h -RemoveAppOrSpn -DeleteSpn

        This example will delete a single Service Principal from the Azure active directory using the ObjectID '94b26zd1-fah2-1a25-bsc5-7h3d6j3s5g3'.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ApplicationID 34a23ad2-dac4-4a41-bc3b-d12ddf90230e -RemoveAppOrSpn -DeleteApp

        This example will delete a singple application from the Azure Active directory using the -ApplicationID '34a23ad2-dac4-4a41-bc3b-d12ddf90230e'

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -ObjectID -ObjectID 94b26zd1-fah2-1a25-bsc5-7h3d6j3s5g3h -RemoveAppOrSpn -DeleteApp

        This example will delete a singple application from the Azure Active directory using the ObjectID '94b26zd1-fah2-1a25-bsc5-7h3d6j3s5g3'.

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -OpenAzurePortal

        This example will open a web connection to the Microsoft Azure Portal

    .EXAMPLE
        PS c:\> New-ServicePrincipalObject -EnableException

        Creates example a new Service Principal in AAD, after prompting for user preferences.
        If this execution fails for whatever reason (connection, bad input, ...) it will throw a terminating exception, rather than writing the default warnings.

    .NOTES
        When passing in the application ID it is the Azure ApplicationID from your registered application.

        WARNING: If you do not connect to an Azure tenant when you run Import-Module Az.Resources you will be logged in interactively to your default Azure subscription.
        After signing in, you will see information indicating which of your Azure subscriptions is active.
        If you have multiple Azure subscriptions in your account and want to select a different one,
        get your available subscriptions with Get-AzSubscription and use the Set-AzContext cmdlet with your subscription id.

        INFORMATION: The default parameter set uses default values for parameters if the user does not provide any.
        For more information on the default values used, please see the description for the given parameters below.
        This cmdlet has the ability to assign a role to the Service Principal with the Role and Scope parameters;
        if neither of these parameters are provided, no role will be assigned to the Service Principal.

        The default values for the Role and Scope parameters are "Contributor" and the current subscription. These roles are applid at the end
        of the Service Principal creation.

        Microsoft TechNet Documentation: https://docs.microsoft.com/en-us/powershell/module/az.resources/new-azadserviceprincipal?view=azps-3.8.0
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding(DefaultParameterSetName='Default')]
    [OutputType('System.Boolean')]
    [OutputType('System.String')]

    param(
        [parameter(ParameterSetName='DisplayNameSet', HelpMessage = "Switch used for single SPN creation")]
        [switch]
        $CreateSingleObject,

        [parameter(Mandatory = 'True', ParameterSetName='NameFileSet', HelpMessage = "Switch used for creating batch SPN's")]
        [switch]
        $CreateBatchObjects,

        [parameter(ParameterSetName='AppIDSet', HelpMessage = "Switch used to create SPN with an ApplicationID")]
        [switch]
        $CreateSPNWithAppID,

        [parameter(ParameterSetName='CertSet', HelpMessage = "Switch used to create SPN with an name and certificate")]
        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $CreateSPNsWithNameAndCert,

        [parameter(ParameterSetName='CertSet', HelpMessage = "Switch used to create SPN with a user supplied password")]
        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $CreateSPNWithPassword,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $DeleteApp,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $DeleteSpn,

        [switch]
        $EnableException,

        [parameter(ParameterSetName="AppIDSet")]
        [switch]
        $GetSPNByAppID,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $GetAppByName,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $GetSPNByName,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $GetSPNSByName,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $GetAppAndSPNPair,

        [parameter(Mandatory = 'True', ParameterSetName='OpenAzurePortal',  Position = '0', HelpMessage = "A switch used to connect to the Azure web portal")]
        [switch]
        $OpenAzurePortal,

        [parameter(Mandatory = 'True', ParameterSetName='Reconnect', Position = '0', HelpMessage = "A switch used to connect force a new conncetion to an Azure tenant")]
        [switch]
        $Reconnect,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $RegisteredApp,

        [parameter(ParameterSetName="DisplayNameSet")]
        [switch]
        $RemoveAppOrSpn,

        [parameter(ParameterSetName="DisplayNameSet")]
        [parameter(ParameterSetName="ObjectIDSet")]
        [switch]
        $RemoveAppAndSPNPairByID,

        [parameter(Mandatory = 'True', Position = '0', ParameterSetName='AppIDSet', HelpMessage = "ApplicationID of a created spn")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ApplicationID,

        [parameter(Mandatory = 'True', Position = '0', ParameterSetName='CertSet', HelpMessage = "ApplicationID of a created spn")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Certificate,

        [parameter(Mandatory = 'True', Position = '0', ParameterSetName='DisplayNameSet', HelpMessage = "Display name of a created SPN ")]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [parameter(Mandatory = 'True', Position = '0', ParameterSetName='NameFileSet', HelpMessage = "Name file used to create a batch of spn's")]
        [ValidateNotNullOrEmpty()]
        [string]
        $NameFile,

        [parameter(Mandatory = 'True', Position = '0', ParameterSetName='ObjectIDSet', HelpMessage = "ObjectID used to create an SPN ")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ObjectID
    )

    Process
    {
        $script:spnCounter = 0
        $script:appCounter = 0
        $script:appDeletedCounter = 0
        $script:runningOnCore = $false
        $script:AzSessionFound = $false
        $script:AdSessionFound = $false
        $script:AzSessionInfo = $null
        $script:AdSessionInfo = $null
        $script:roleListToProcess = New-Object -Type System.Collections.ArrayList
        $parameters = $PSBoundParameters | ConvertTo-PSFHashtable -Include Reconnect
        $deleteParameters = $PSBoundParameters | ConvertTo-PSFHashtable -Include ApplicationID, ObjectID
        Write-PSFMessage -Level Host -Message "Starting Script Run"

        try
        {
            Connect-ToCloudTenant @parameters -EnableException
        }
        catch
        {
            Stop-PSFFunction -Message $_ -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
            return
        }

        # Try to obtain the list of names so we can batch create the SPNS
        if($NameFile -and $CreateBatchObjects)
        {
            Write-PSFMessage -Level Host -Message "Testing access to {0}" -StringValues $NameFile

            if(-NOT (Test-Path -Path $NameFile))
            {
                Stop-PSFFunction -Message "ERROR: File problem. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
            else
            {
                Write-PSFMessage -Level Host -Message "{0} accessable. Reading in content" -StringValues $NameFile
                $objectsToCreate = Get-Content $NameFile

                # Validate that we have data and if we dont we exit out
                if(0 -eq $objectsToCreate.Length)
                {
                    Stop-PSFFunction -Message "Error with imported content. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                    return
                }
            }
        }

        if($CreateSingleObject)
        {
            try
            {
                if($RegisteredApp)
                {
                    if(-NOT $script:runningOnCore)
                    {
                        $newApp = New-AzureADApplication -DisplayName $DisplayName -ErrorAction SilentlyContinue -ErrorVariable ProcessError

                        if($newApp)
                        {
                            Write-PSFMessage -Level Host -Message "Registered Application created: DisplayName: {0} - ApplicationID {1}" -Format $newApp.DisplayName, $newApp.AppId
                            $script:appCounter ++

                            # Since we only create an AzureADapplicaiaton we need to create the matching service principal
                            New-SPNByAppID -ApplicationID $newApp.AppId -RegisteredApp
                        }
                        elseif($ProcessError)
                        {
                            Write-PSFMessage -Level Warning "WARNING: $($ProcessError[0].Exception.Message)"
                        }
                    }
                    else
                    {
                        Write-PSFMessage -Level Host -Message "At this time AzureAD PowerShell module does not work on PowerShell Core. Please use PowerShell version 5 or 6 to create Registered Applications."
                    }
                }
                elseif($DisplayName -and $CreateSPNWithPassword)
                {
                    New-SPNByAppID -DisplayName $DisplayName -CreateSPNWithPassword
                }
                elseif(($DisplayName) -and (-NOT $RegisteredApp))
                {
                    New-SPNByAppID -DisplayName $DisplayName
                }

                if($script:roleListToProcess.Count -gt 0)
                {
                    Add-RoleToSPN -spnToProcess $script:roleListToProcess
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Creating a simple SPN failed" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($CreateBatchObjects)
        {
            try
            {
                # Check to make sure we have the list of objects to process
                if($objectsToCreate)
                {
                    Write-PSFMessage -Level Host -Message "Object list DETECTED! Staring batch creation of SPN's"

                    if($RegisteredApp)
                    {
                        if(-NOT $script:runningOnCore)
                        {
                            foreach($DisplayName in $objectsToCreate)
                            {
                                $newApp = New-AzureADApplication -DisplayName $DisplayName -ErrorAction SilentlyContinue -ErrorVariable ProcessError

                                if($newApp)
                                {
                                    Write-PSFMessage -Level Host -Message "Registered Application created: DisplayName: {0} - ApplicationID {1}" -Format $newApp.DisplayName, $newApp.AppId
                                    $script:roleListToProcess.Add($newApp)
                                    $script:appCounter ++

                                    # Since we only create an AzureADapplicaiaton we need to create the matching service principal
                                    New-SPNByAppID -ApplicationID $newApp.AppID
                                }
                                elseif($ProcessError)
                                {
                                    Write-PSFMessage -Level Warning "WARNING: {0}" -StringValues $ProcessError.Exception.Message
                                }
                            }

                            if($script:roleListToProcess.Count -gt 0)
                            {
                                Add-RoleToSPN -spnToProcess $script:roleListToProcess
                            }
                        }
                        else
                        {
                            Write-PSFMessage -Level Host -Message "At this time AzureAD PowerShell module does not work on PowerShell Core. Please use PowerShell version 5 or 6 to create Registered Applications."
                        }
                    }
                    else
                    {
                        foreach($spn in $objectsToCreate)
                        {
                            New-SPNByAppID -DisplayName $spn
                        }

                        if($roleListToProcess.Count -gt 0)
                        {
                            Add-RoleToSPN -spnToProcess $script:roleListToProcess
                        }
                    }
                }
                else
                {
                    Write-PSFMessage -Level Warning "ERROR: No list of objects found!"
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR:" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($CreateSPNWithAppID)
        {
            try
            {
                New-SPNByAppID -ApplicationID $ApplicationID
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($CreateSPNsWithNameAndCert)
        {
            try
            {
                if((-NOT $Certificate) -or (-NOT $DisplayName))
                {
                    Stop-PSFFunction -Message "ERROR: No certificate or Service Principal DisplayName specified. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet
                    return
                }
                else
                {
                    Write-PSFMessage -Level Host -Message "Creating new SPN DisplayName and certificate key - DisplayName: {0}" -StringValues $newSPN.DisplayName
                    $newSPN = New-AzADServicePrincipal -DisplayName $DisplayName -CertValue $Certificate -EndDate "2024-12-31"
                    Add-RoleToSPN -spnToProcess $newSPN
                    $script:spnCounter ++
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: No certificate as base64-encoded string specified. Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetAppByName)
        {
            try
            {
                if($DisplayName)
                {
                    Get-AppByName -DisplayName $DisplayName
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a display name. Search failed."
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetSPNByName)
        {
            try
            {
                if($DisplayName)
                {
                    Get-SpnByName -DisplayName $DisplayName
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a display name. Search failed."
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetSPNByAppID)
        {
            try
            {
                if($ApplicationID)
                {
                    Get-SpnByAppID -ApplicationID $ApplicationID
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a application id. Search failed."
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetSPNSByName)
        {
            try
            {
                if($DisplayName)
                {
                    Get-SpnsByName -DisplayName $DisplayName
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a display name. Search failed."
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($GetAppAndSPNPair)
        {
            try
            {
                if($DisplayName)
                {
                    Get-AppAndSPNPair -DisplayName $DisplayName
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a display name. Search failed."
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }

        if($RemoveAppAndSPNPairByID)
        {
            try
            {
                if($ApplicationID)
                {
                    Remove-AppAndSPNPair -ApplicationID $ApplicationID
                    return
                }
                if($ObjectID)
                {
                    Remove-AppAndSPNPair -ObjectID $ObjectID
                    return
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a object value."
                }
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }

        }

        if($RemoveAppOrSpn)
        {
            if($DeleteApp -or $DeleteSpn)
            {
                if($DeleteApp)
                {
                    Remove-AppOrSPN @deleteParameters -DeleteApp
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a object value."
                }

                if($DeleteSpn)
                {
                    Remove-AppOrSPN @deleteParameters -DeleteSpn
                }
                else
                {
                    Write-PSFMessage -Level Host "ERROR: You did not provide a object value."
                }
            }
        }

        if($OpenAzurePortal)
        {
            try
            {
                Start-Process "https://portal.azure.com"
            }
            catch
            {
                Stop-PSFFunction -Message "ERROR: Exiting" -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
                return
            }
        }
    }

    end
    {

        if(0 -eq $script:appDeletedCounter)
        {
            Write-PSFMessage -Level Host -Message "No applications deleted!"
        }
        elseif(1 -eq $script:appDeletedCounter)
        {
            Write-PSFMessage -Level Host -Message "{0} application deleted sucessfully!" -StringValues $script:appDeletedCounter
        }
        elseif(1 -gt $script:appDeletedCounter)
        {
            Write-PSFMessage -Level Host -Message "{0} applications deleted sucessfully!" -StringValues $script:appDeletedCounter
        }
        if(0 -eq $script:appCounter)
        {
            Write-PSFMessage -Level Host -Message "No application created!"
        }
        elseif(1 -eq $script:appCounter)
        {
            Write-PSFMessage -Level Host -Message "{0} application created sucessfully!" -StringValues $script:appCounter
        }
        elseif(1 -gt $script:appCounter)
        {
            Write-PSFMessage -Level Host -Message "{0} applications created sucessfully!" -StringValues $script:appCounter
        }
        if(0 -eq $script:spnCounter)
        {
            Write-PSFMessage -Level Host -Message "No service principal created!"
        }
        elseif(1 -eq $script:spnCounter)
        {
            Write-PSFMessage -Level Host -Message "{0} service principals sucessfully!" -StringValues $script:spnCounter
        }
        elseif(1 -gt $script:spnCounter)
        {
            Write-PSFMessage -Level Host -Message "{0} service principals created sucessfully!" -StringValues $script:spnCounter
        }

        Write-PSFMessage -Level Host -Message "Script run complete!"
        Write-PSFMessage -Level Host -Message 'Log saved to: "{0}". Run Get-LogFolder to retrieve the output or debug logs.' -StringValues $script:loggingFolder #-Once 'LoggingDestination'
    }
}