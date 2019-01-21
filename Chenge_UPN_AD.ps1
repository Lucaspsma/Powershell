#Script para alterar o UPN do usuário 
#1- Get all users that email adress 
#2- Set theses users with UPN 

$CountP = 0
$usersP = Get-ADUser -Filter{mail -like ""} -Properties mail,DistinguishedName

$upnP = Read-host "Digite o novo UPN a ser ajustado"
  Foreach($userp in $usersp){
      $countp++ 
      $SamAP = $userp.SamAccountName
      $newUPN = $SamAP+$Upnp
      Write-Host $userp.UserPrincipalName : $newUPN : $userp.Name : $userp.mail -ForegroundColor Cyan
      Set-ADUser $userp.SamAccountName -UserPrincipalName $newUPN
  }
Write-Host "Total UPN alteardo: $Countp" -ForegroundColor Cyan
