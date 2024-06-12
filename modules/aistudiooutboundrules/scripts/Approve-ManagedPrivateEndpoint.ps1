# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $ResourceId,

    [Parameter(Mandatory = $true)]
    [String]
    $ManagedPrivateEndpointName,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]
    $CheckIntervalInSeconds = 10,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int]
    $CheckFrequency = 10,

    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]
    $Remaining
)

# Change the ErrorActionPreference to 'Stop' to fail in case of an error
$ErrorActionPreference = "Stop"

function Get-PrivateEndpointId {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ManagedPrivateEndpointName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $CheckIntervalInSeconds = 10,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $CheckFrequency = 10
    )

    # Initialize variable
    $privateEndpointId = $null

    # Get Private Endpoint ID
    for ($i = 0; $i -lt $CheckFrequency; $i++) {
        $privateEndpointId = $(az network private-endpoint-connection list --id $ResourceId --query "[?contains(properties.privateEndpoint.id, '$ManagedPrivateEndpointName')].id | [0]" -o json) | ConvertFrom-Json

        if ($privateEndpointId) {
            Write-Output "Private Endpoint found. Continuing with approval."
            break
        }
        Write-Output "Private Endpoint not found. Sleeping for $($CheckIntervalInSeconds) seconds ..."
        Start-Sleep -Seconds $CheckIntervalInSeconds
    }

    if (-not $privateEndpointId) {
        Write-Error "Private Endpoint not found. Failed to approve Private Endpoint."
        throw "Private Endpoint not found. Failed to approve Private Endpoint."
    }

    return $privateEndpointId
}

function Approve-PrivateEndpoint {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ManagedPrivateEndpointName,

        [Parameter(Mandatory = $true)]
        [String]
        $PrivateEndpointId
    )

    # Check status of private endpoint
    Write-Output "Checking status of Private Endpoint"
    $privateEndpointstatus = $(az network private-endpoint-connection list --id $ResourceId --query "[?contains(properties.privateEndpoint.id, '$ManagedPrivateEndpointName')].properties.privateLinkServiceConnectionState.status | [0]" -o json) | ConvertFrom-Json

    if ($privateEndpointStatus -eq "Approved") {
        # Private Endpoint Connection already approved
        Write-Output "Private Endpoint Connection already approved"
    }
    else {
        # Approve Private Endpoint Connection
        Write-Output "Approving Private Endpoint Connection"
        az network private-endpoint-connection approve --id $privateEndpointId --description "Approved in Terraform"
    }
}

$privateEndpointId = Get-PrivateEndpointId `
    -ManagedPrivateEndpointName $ManagedPrivateEndpointName

Approve-PrivateEndpoint `
    -ManagedPrivateEndpointName $ManagedPrivateEndpointName `
    -PrivateEndpointId $privateEndpointId
