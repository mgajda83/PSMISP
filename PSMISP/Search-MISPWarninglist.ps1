Function Search-MISPWarninglist
{
    <#
	.SYNOPSIS
	    Search MISP warninglists

    .PARAMETER Body
	    Warninglists search request data.

	.PARAMETER ApiKey
	    ApiKey to send request

    .PARAMETER BaseUri
	    Main part of uri to API.

	.EXAMPLE
        $Body = @{
            enabled = $true
        }

        $Warninglists = Search-MISPWarninglist -Body $Body

	.NOTES
		Author: Michal Gajda

    .LINK
       https://misp.asseco.cloud/servers/openapi#operation/searchWarninglists
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
        $Uri = $BaseUri + "/warninglists"

        If ($PSCmdlet.ShouldProcess("Search events"))
        {
            $Request = @{
                Method = "POST"
                Uri = $Uri
                Header = $Headers
                Body = ($Body | ConvertTo-Json)
            }

            $Response = Invoke-RestMethod @Request

            Return $Response.Warninglists.Warninglist
        }
    }

	End {}
}
