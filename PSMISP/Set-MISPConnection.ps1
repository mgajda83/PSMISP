Function Set-MISPConnection
{
    <#
	.SYNOPSIS
	    Set MISP connection data

	.PARAMETER ApiKey
	    ApiKey to send request

    .PARAMETER BaseUri
	    Main part of uri to API.

	.EXAMPLE
        $ApiKey = Get-PSCredentialManager -Target MISPUser -Output ClearText
        $BaseUri = "https://misp.asseco.cloud/"
        Set-MISPConnection -ApiKey $ApiKey -BaseUri $BaseUri

	.NOTES
		Author: Michal Gajda
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
    param (
        [Parameter(Mandatory=$true)]
        [String]$BaseUri,
        [Parameter(Mandatory=$true)]
        [String]$ApiKey,
        [Switch]$IgnoreSSL
    )

	Begin
    {
        if($IgnoreSSL)
        {
            Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
            [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }
    }

    Process
	{
        if($PSCmdlet.ShouldProcess($BaseUri,"Set connection data"))
        {
            $Script:ApiKey = $ApiKey
            $Script:BaseUri = $BaseUri
        }

        Return
    }

	End {}
}
