# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $WorkspaceId,

    [Parameter(Mandatory = $true)]
    [String]
    $OneLakeDiagnosticsWorkspaceId,

    [Parameter(Mandatory = $true)]
    [String]
    $OneLakeDiagnosticsLakehouseId,

    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]
    $Remaining
)

# Change the ErrorActionPreference to 'Stop' to fail in case of an error
$ErrorActionPreference = "Stop"
$BASE_URL = "https://api.fabric.microsoft.com"

function Get-AccessToken {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Scope = "https://api.fabric.microsoft.com/.default"
    )

    # Write message to host
    $token = $(az account get-access-token --resource $Scope --query "accessToken" -o tsv)
    if (-not $token) {
        Write-Host "Failed to get access token. Exiting..."
        Exit 1
    }
    return $token
}

function Set-OneLakeDiagnostics {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $WorkspaceId,

        [Parameter(Mandatory = $true)]
        [String]
        $OneLakeDiagnosticsWorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $OneLakeDiagnosticsLakehouseId
    )

    # Initialize variables
    $uri = "$($BASE_URL)/v1/workspaces/$($WorkspaceId)/onelake/settings/modifyDiagnostics"

    # Define headers
    $accessToken = Get-AccessToken
    $headers = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer ${accessToken}"
    }

    # Create body for REST API call
    $body = @{
        "status" = "Enabled"
        "destination" = @{
            "type" = "Lakehouse"
            "lakehouse" = @{
                "referenceType" = "ById"
                "itemId" = $OneLakeDiagnosticsLakehouseId
                "workspaceId" = $OneLakeDiagnosticsWorkspaceId
            }
        }
    } | ConvertTo-Json

    # Create parameters for REST API call
    $parameters = @{
        'Uri'         = $uri
        'Method'      = 'Post'
        'Headers'     = $headers
        'Body'        = $body
        'ContentType' = 'application/json'
    }

    # Make REST API call to enable OneLake Diagnostics
    try {
        $responseGetSystemSchemas = Invoke-RestMethod @parameters
        $schemas = $responseGetSystemSchemas.schemas | ConvertTo-Json
        Write-Host $schemas
    }
    catch {
        $message = "REST API call to enable OneLake Diagnostics failed with error: $_"
        Write-Error $message
        throw $message
        exit 1
    }

    return $true
}

# Configure OneLake Diagnostic settings
$null = Set-OneLakeDiagnostics `
    -WorkspaceId $WorkspaceId `
    -OneLakeDiagnosticsWorkspaceId $OneLakeDiagnosticsWorkspaceId `
    -OneLakeDiagnosticsLakehouseId $OneLakeDiagnosticsLakehouseId
