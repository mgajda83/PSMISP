Function Search-MISPAttribute
{
    <#
	.SYNOPSIS
	    Search MISP attributes

    .PARAMETER Body
	    Attributes search request data.

	.PARAMETER ApiKey
	    ApiKey to send request

    .PARAMETER BaseUri
	    Main part of uri to API.

	.EXAMPLE
        $Body = @{
            page = 100
            deleted = $true
            category = "Network activity"
            tags = 'false-positive:confirmed="true"'
            eventid = 1
        }
        $Attributes = Search-MISPAttribute -Body $Body

	.NOTES
		Author: Michal Gajda

    .LINK
        https://misp.asseco.cloud/servers/openapi#operation/restSearchAttributes
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
    param (
        [Parameter(Mandatory=$true)]
        [PSObject]$Body,
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
        $Uri = $BaseUri + "/attributes/restSearch"

        If ($PSCmdlet.ShouldProcess("Search attributes"))
        {
            $Request = @{
                Method = "POST"
                Uri = $Uri
                Header = $Headers
                Body = ($Body | ConvertTo-Json)
            }

            $Response = Invoke-RestMethod @Request

            Return $Response.response.Attribute
        }
    }

	End {}
}
