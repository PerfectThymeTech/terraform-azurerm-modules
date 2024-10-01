# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $ResourceId,

    [Parameter(Mandatory = $true)]
    [String]
    $WorkspaceName,

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
        $WorkspaceName,

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
        $privateEndpointId = $(az network private-endpoint-connection list --id $ResourceId --query "[?contains(properties.privateEndpoint.id, '$WorkspaceName.$ManagedPrivateEndpointName')].id | [0]" -o json) | ConvertFrom-Json

        if ($privateEndpointId) {
            Write-Host "Private Endpoint found. Continuing with approval."
            Write-Host "Private Endpoint ID: ${privateEndpointId}"
            break
        }
        Write-Host "Private Endpoint not found. Sleeping for $($CheckIntervalInSeconds) seconds ..."
        Start-Sleep -Seconds $CheckIntervalInSeconds
    }

    if (-not $privateEndpointId) {
        Write-Host "Private Endpoint not found. Exiting..."
        Exit 1
    }

    return $privateEndpointId
}

function Approve-PrivateEndpoint {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $WorkspaceName,

        [Parameter(Mandatory = $true)]
        [String]
        $ManagedPrivateEndpointName,

        [Parameter(Mandatory = $true)]
        [String]
        $PrivateEndpointId
    )

    # Check status of private endpoint
    Write-Host "Checking status of Private Endpoint"
    $privateEndpointstatus = $(az network private-endpoint-connection list --id $ResourceId --query "[?contains(properties.privateEndpoint.id, '$WorkspaceName.$ManagedPrivateEndpointName')].properties.privateLinkServiceConnectionState.status | [0]" -o json) | ConvertFrom-Json

    if ($privateEndpointStatus -eq "Approved") {
        # Private Endpoint Connection already approved
        Write-Host "Private Endpoint Connection already approved"
    }
    else {
        # Approve Private Endpoint Connection
        Write-Host "Approving Private Endpoint Connection"
        az network private-endpoint-connection approve --id $privateEndpointId --description "Approved in Terraform"
    }
}

$privateEndpointId = Get-PrivateEndpointId `
    -WorkspaceName $WorkspaceName `
    -ManagedPrivateEndpointName $ManagedPrivateEndpointName

Approve-PrivateEndpoint `
    -WorkspaceName $WorkspaceName `
    -ManagedPrivateEndpointName $ManagedPrivateEndpointName `
    -PrivateEndpointId $privateEndpointId
