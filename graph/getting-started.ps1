# --------------------------------------------------------------
# Getting started with PowerShell Graph SDK
# --------------------------------------------------------------

# Set the correct execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install the base module, for the `Find-MgGrapCommand`
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

# Pick a Graph resource https://learn.microsoft.com/en-us/graph/api/overview?view=graph-rest-1.0
# Find the correct command for list groups
# Graph API docs: https://learn.microsoft.com/en-us/graph/api/group-list
# Note the Module and the permission(s)
Find-MgGraphCommand -Uri '/groups'

# Install 'Groups' module
Install-Module Microsoft.Graph.Groups -Scope CurrentUser

# Login to Graph with correct permission (called scopes here)
Connect-MgGraph -Scopes "Group.Read.All"

# List groups with display name starting with 'test'
Get-MgGroup -Filter "startsWith(displayName, 'test')"
