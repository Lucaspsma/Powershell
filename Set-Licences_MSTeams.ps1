#Connect-MsolService
$ServicePlan_Teams = "Teams1"
$ServicePlan_Exchange = "EXCHANGE_S_ENTERPRISE"
 
$ImportPath = Read-Host "Digite o caminho absoluto do txt que contem a lista de usuarios"

$Allusers = import-csv $ImportPath

 
 
 ForEach ($Userupn in $AllUsers) 
    {
        $user = Get-MsolUser -UserPrincipalName $userupn.UserPrincipalName
        $CurrentLicense = $User.Licenses | Where-Object {$_.AccountSkuID -EQ ""} #inserir o SKU ID entre as "" 
        $is=0
        If (-not $CurrentLicense) {
            
        } 
        If ($CurrentLicense.count -eq 1) {
          
        $is++
        } 
 
# Get the current status of the specified service plan to be disabled
    if($is -gt 0){
        $Status_App = (Get-MsolUser -UserPrincipalName $User.UserPrincipalName).Licenses.ServiceStatus.Where({($_.ServicePlan.ServiceName -eq $ServicePlan_Teams -or $_.ServicePlan.ServiceName -eq $ServicePlan_Exchange)})
        
        $sts = $Status_App.ServicePlan
            
                [pscustomobject] @{
                    DisplayName = $User.DisplayName
                    UserPrincipalName = $User.UserPrincipalName
                    App = $sts
                    Status = $Status_App.ProvisioningStatus
            }
    }
    else{
    
    $Status_App = (Get-MsolUser -UserPrincipalName $User.UserPrincipalName)
    
        [pscustomobject] @{
            DisplayName = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            App = $Status_App.IsLicensed
            Status = $Status_App.ProvisioningStatus
        }
    }
} 

