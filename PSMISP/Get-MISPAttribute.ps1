Function Get-MISPAttribute
{
    <#
	.SYNOPSIS
	    Get attributes

    .PARAMETER Id
	    Attribute id.

	.PARAMETER ApiKey
	    ApiKey to send request

    .PARAMETER BaseUri
	    Main part of uri to API.

	.EXAMPLE
        $Attributes = Get-MISPAttribute

	.NOTES
		Author: Michal Gajda

    .LINK
        https://misp.asseco.cloud/servers/openapi#operation/getAttributes
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
            $Uri = $BaseUri + "/attributes"
            $Id = "All"
        } else {
            $Uri = $BaseUri + "/attributes/view/$Id"
        }

        If ($PSCmdlet.ShouldProcess($Id,"Get attribute"))
        {
            $Response = Invoke-RestMethod -Method GET -Uri $Uri -Header $Headers

            if($PsCmdlet.ParameterSetName -eq "Id")
            {
                Return $Response.Attribute
            } else {
                Return $Response
            }
        }
    }

	End {}
}
