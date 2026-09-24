Connect-AzAccount

$displayName = Read-Host -Prompt "Display name"
$userPrincipalName = Read-Host -Prompt "User principal name (e.g. user@something.com)"
$mailNickname = Read-Host -Prompt "Mail nickname"
$password = Read-Host -Prompt "Password" -AsSecureString

$subId = (Get-AzContext).Subscription.Id

# this condition was marked as "recommended" for privileged roles that can assign roles to other users
$condition = "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAllValues:GuidNotEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635, 18d7d88d-d35e-4fb5-a5c3-7773c20a72d9, f58310d9-a9f6-439a-9e8d-f62e7b41a168})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAllValues:GuidNotEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635, 18d7d88d-d35e-4fb5-a5c3-7773c20a72d9, f58310d9-a9f6-439a-9e8d-f62e7b41a168}))"
$conditionVersion = "2.0"
$description = "Can't assign privileged roles to others, or is it? can I even get the restrictions off..?"
$scope = "/subscriptions/$subId"
$roleDefinitionId = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" # UAA Id, for Owner: 8e3af657-a8ff-443c-a75c-2fe8c4bcb635
$roleDefinitionName = "User Access Administrator" # if you wanna do Owner then change this

$UAAuser = New-AzADUser -DisplayName $displayName -UserPrincipalName $userPrincipalName -MailNickname $mailNickname -Password $password -AccountEnabled $true 
$userObjId = $UAAuser.Id

Start-Sleep -Seconds 5 # wait for the user to be created fully

New-AzRoleAssignment -ObjectId $userObjId -Scope $scope -RoleDefinitionId $roleDefinitionId -Description $description -Condition $condition -ConditionVersion $conditionVersion