# --------------------------------------------------------------
# Create app registration for app-only access to Graph
# --------------------------------------------------------------

# Variables
# Generate a self-signed certificate
$certThumb = "68EFF70301C7643FD3F6ABDDA796979BAAD2D231"
$appName = "Unattended Graph Access PowerShell"
$resourceScope = "User.Read.All"

# Set the correct execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install the Applications module
Install-Module Microsoft.Graph.Applications -Scope CurrentUser

# Login to Graph
Connect-MgGraph -Scopes "Application.ReadWrite.All"

# Load certificate
$cert = Get-ChildItem -Path Cert:\CurrentUser\My\$($certThumb)

# Create keyCredentials hash table
$keyCreds = @(
  [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphKeyCredential]@{
    Type = "AsymmetricX509Cert";
    Usage = "Verify";
    StartDateTime = $cert.NotBefore;
    EndDateTime = $cert.NotAfter;
    Key = $cert.GetRawCertData();
    DisplayName = $cert.Subject;
  }
)

# Create resource hash table
# Lookup AppRole Id for some permission
$resourceAppId = "00000003-0000-0000-c000-000000000000" # Graph APP ID
$resourceServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$resourceAppId'"
$resourceAppRole = $resourceServicePrincipal.AppRoles | Where-Object { $_.Value -eq $resourceScope -and $_.AllowedMemberTypes -contains "Application" }
$resourceAccess = @(
  [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess]@{
    ResourceAppId = $resourceAppId;
    ResourceAccess = @(
      [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceAccess]@{
        Id = $resourceAppRole.Id;
        Type = "Role"
      }
    )
  }
)

# Create a new application with the chosen name
$newApp = New-MgApplication -DisplayName $appName -SignInAudience AzureADMyOrg -KeyCredentials $keyCreds -RequiredResourceAccess $resourceAccess;

# Save App ID and Tenant for later user
$appId = $newApp.AppId;
$tenantId = $(Get-MgContext).TenantId;

# Create ServicePrincipal for new app (Admin Consent)
New-MgServicePrincipal -AppId $appId;

# Go press the Grant admin consent button in the Portal (this should be possible with PowerShell...)

# Connect to MgGraph with new application and certificate
Connect-MgGraph -ClientId $appId -TenantId $tenantId -CertificateThumbprint $certThumb
