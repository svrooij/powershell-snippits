# --------------------------------------------------------------
# Installing and loading modules
# --------------------------------------------------------------
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 
Install-Module Microsoft.Graph.Teams -Scope CurrentUser
Install-Module Microsoft.Graph.Groups -Scope CurrentUser
Install-module Microsoft.Graph.Authentication -Scope CurrentUser

Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Teams
Import-Module Microsoft.Graph.Authentication
# --------------------------------------------------------------
# Variables
# --------------------------------------------------------------
$teamNickname = "my-test-team2"; # URL/email safe (no spaces or special chars)
$teamDisplayName = "Test Team";
$teamDescription = "My Test Team Description";
$teamVisibility = "Public"; # Possible values 'Private' / 'Public'
$teamTemplate = 'standard'; # See https://learn.microsoft.com/en-us/MicrosoftTeams/get-started-with-teams-templates
$userIdOwner = "7c3b798b-06f0-4557-9f90-a355580a67fc"; # One owner, you can add others later on.
$userIdsMembers = @('e2f346ef-1956-40dc-b451-51f2b7c9f270', '73c1374b-a98e-4ca8-8047-82ed1099512f') # add members you want

# --------------------------------------------------------------
# Connect to Graph (this uses delegate access, be sure your account has access to do these things!)
# --------------------------------------------------------------
Connect-MgGraph -Scopes "Group.ReadWrite.All", "Team.Create"

# --------------------------------------------------------------
# Create group
# --------------------------------------------------------------
$groupMembers = @("https://graph.microsoft.com/v1.0/users/" + $userIdOwner);
ForEach($m in $userIdsMembers) {
    $groupMembers += 'https://graph.microsoft.com/v1.0/users/' + $m;
}
$groupParams = @{
	Description = $teamDescription
	DisplayName = $teamDisplayName
	GroupTypes = @(
        "Unified"
	)
	ResourceBehaviorOptions = @(
		"SubscribeNewGroupMembers", "WelcomeEmailDisabled", "HideGroupInOutlook"
	)
    Visibility = $teamVisibility
	MailEnabled = $true
	MailNickname = $teamNickname
	SecurityEnabled = $false
	"Owners@odata.bind" = @(
		"https://graph.microsoft.com/v1.0/users/" + $userIdOwner
	)
	"Members@odata.bind" = $groupMembers
}

$newGroup = New-MgGroup -BodyParameter $groupParams
$newGroup | Format-List

# --------------------------------------------------------------
# Wait 5 to 15 minutes!! (for the group to propegate through Azure AD & Teams)
#
# If you see the group in the admin portal, this would be the moment to add extra members.
# --------------------------------------------------------------

# --------------------------------------------------------------
# Create team from group
# --------------------------------------------------------------

$teamParams = @{
	"Template@odata.bind" = "https://graph.microsoft.com/v1.0/teamsTemplates('$teamTemplate')"
	"Group@odata.bind" = "https://graph.microsoft.com/v1.0/groups('$($newGroup.Id)')"
}

New-MgTeam -BodyParameter $teamParams | Format-List
