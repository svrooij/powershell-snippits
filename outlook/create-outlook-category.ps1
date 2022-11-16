# --------------------------------------------------------------
# Creating a category in Outlook using PowerShell Graph
# Blog post: https://svrooij.io/2022/09/27/create-corporate-outlook-category/
# --------------------------------------------------------------

# Change accordingly
$tenantId = "21009bcd-06df-4cdf-b114-e6a326ef3368";

# --------------------------------------------------------------
# Installing modules
# --------------------------------------------------------------
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 
Install-Module Microsoft.Graph.Users -Scope CurrentUser
Install-Module Microsoft.Graph.Groups -Scope CurrentUser



# --------------------------------------------------------------
# Create category for single user
# --------------------------------------------------------------
# you can use either the user ID or the UPN.
$userId = "613f5b2e-4360-4665-956b-ffeaa0f3014b";

# Connect to Graph with correct scopes
Connect-MgGraph -TenantId $tenantId -Scopes "MailboxSettings.ReadWrite"

$category = @{
	DisplayName = "Schedule"
	Color = "preset9"
}

New-MgUserOutlookMasterCategory -UserId $userId -BodyParameter $category;



# --------------------------------------------------------------
# Create category for all users in a group
# --------------------------------------------------------------
$groupId = "613f5b2e-4360-4665-956b-ffeaa0f3014b";

# Connect to Graph with correct scopes
Connect-MgGraph -TenantId $tenantId -Scopes "MailboxSettings.ReadWrite","GroupMember.Read.All"

$category = @{
	DisplayName = "Schedule"
	Color = "preset9"
}

$members = Get-MgGroupMember -GroupId $groupId;

foreach ($member in $members) {
  New-MgUserOutlookMasterCategory -UserId $member.Id -BodyParameter $category -ErrorAction SilentlyContinue;
}
