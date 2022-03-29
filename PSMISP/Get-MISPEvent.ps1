Function Get-MISPEvent
{
    <#
	.SYNOPSIS
	    Get MISP events

    .PARAMETER Id
	    Event id.

	.PARAMETER ApiKey
	    ApiKey to send request

    .PARAMETER BaseUri
	    Main part of uri to API.

	.EXAMPLE
        $Events = Get-MISPEvent

	.NOTES
		Author: Michal Gajda

    .LINK
        https://misp.asseco.cloud/servers/openapi#operation/getEvents
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
            $Uri = $BaseUri + "/events"
            $Id = "All"
        } else {
            $Uri = $BaseUri + "/events/view/$Id"
        }

        If ($PSCmdlet.ShouldProcess($Id,"Get event"))
        {
            $Response = Invoke-RestMethod -Method GET -Uri $Uri -Header $Headers

            if($PsCmdlet.ParameterSetName -eq "Id")
            {
                Return $Response.Event
            } else {
                Return $Response
            }
        }
    }

	End {}
}
