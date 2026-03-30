# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $WorkspaceId,

    [Parameter(Mandatory = $true)]
    [string[]]
    $TagIds,

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

function Set-WorkspaceTags {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string[]]
        $TagIds
    )

    # Initialize variables
    $uri = "$($BASE_URL)/v1/workspaces/$($WorkspaceId)/applyTags"

    # Define headers
    $accessToken = Get-AccessToken
    $headers = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer ${accessToken}"
    }

    # Create body for REST API call
    $body = @{
        "tags" = $TagIds
    } | ConvertTo-Json

    # Create parameters for REST API call
    $parameters = @{
        'Uri'         = $uri
        'Method'      = 'Post'
        'Headers'     = $headers
        'Body'        = $body
        'ContentType' = 'application/json'
    }

    # Make REST API call to apply tags
    try {
        $responseGetSystemSchemas = Invoke-RestMethod @parameters
        $schemas = $responseGetSystemSchemas.schemas | ConvertTo-Json
        Write-Host $schemas
    }
    catch {
        $message = "REST API call to apply tags to workpace failed with error: $_"
        Write-Error $message
        throw $message
        exit 1
    }

    return $true
}

# Apply workspace Tags
_ = Set-WorkspaceTags `
    -WorkspaceId $WorkspaceId `
    -TagIds $TagIds
