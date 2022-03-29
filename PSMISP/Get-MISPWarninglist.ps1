Function Get-MISPWarninglist
{
	<#
	.SYNOPSIS
		Get MISP warninglists

    .PARAMETER Id
	    Warninglist id.

	.PARAMETER ApiKey
		ApiKey to send request

	.PARAMETER BaseUri
		Main part of uri to API.

	.EXAMPLE
		$Warninglists = Get-MISPWarninglist

	.NOTES
		Author: Michal Gajda

	.LINK
		https://misp.asseco.cloud/servers/openapi#operation/getWarninglists
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low",
        DefaultParameterSetName="All"
	)]
	param (
		[Parameter(ParameterSetName="Id",
			ValueFromPipeline=$True)]
		[PSObject[]]$Id,
		[Parameter()]
		[String]$BaseUri,
		[Parameter()]
		[String]$ApiKey
	)

	Begin
	{
		#Get global config
		if(!$MyInvocation.BoundParameters.ContainsKey("ApiKey")) { $ApiKey = $Script:ApiKey }
		if(!$MyInvocation.BoundParameters.ContainsKey("BaseUri")) { $BaseUri = $Script:BaseUri }

		$Headers = @{
			"Content-Type" = "application/json"
			"Accept" = "application/json"
			"Authorization" = $ApiKey
		}
	}

	Process
	{
		#Build interface uri
		$BaseUri = $BaseUri -replace "/$",""
        if($null -eq $Id)
        {
            $Uri = $BaseUri + "/warninglists"
            $Id = "All"
        } else {
            $Uri = $BaseUri + "/warninglists/view/$Id"
        }

        If ($PSCmdlet.ShouldProcess($Id,"Get warninglists"))
        {
            $Response = Invoke-RestMethod -Method GET -Uri $Uri -Header $Headers

            if($PsCmdlet.ParameterSetName -eq "Id")
            {
                Return $Response.Warninglist
            } else {
                Return $Response.Warninglists.Warninglist
            }
        }
	}

	End {}
}
