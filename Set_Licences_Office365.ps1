#Connectando no Office365 - Executar apenas uma vez o commando abaixo. 
#Connect-MsolService

#Pacote de Licenças E3 - Office365BMG
$officeSKU = Get-MsolAccountSku
$acctsku="" #informar o SKU

#SEM Exchange - Definido a licenças tipo padrão - E3 + TEAMS + SWAY + Planner + TO-DO + RMS_S_Enterprise + Office365ProPlus
$Office = New-MsolLicenseOptions -AccountSkuId $acctsku -DisabledPlans "FORMS_PLAN_E3","STREAM_O365_E3","Deskless","FLOW_O365_P2","POWERAPPS_O365_P2","YAMMER_ENTERPRISE","MCOSTANDARD","SHAREPOINTWAC","SHAREPOINTENTERPRISE","EXCHANGE_S_ENTERPRISE"

#COM Exchange - Definido a licenças tipo padrão - E3 + TEAMS + SWAY + Planner + TO-DO + RMS_S_Enterprise + Office365ProPlus + Exchange
#$Office = New-MsolLicenseOptions -AccountSkuId $acctsku -DisabledPlans "FORMS_PLAN_E3","STREAM_O365_E3","Deskless","FLOW_O365_P2","POWERAPPS_O365_P2","YAMMER_ENTERPRISE","MCOSTANDARD","SHAREPOINTWAC","SHAREPOINTENTERPRISE"


#Export Listas de usuários - Cabeçalho deve contar a UPN com o valor SamAccountName Completo
$users = ""
$ImportPath = Read-Host "Digite o caminho absoluto do txt que contem a lista de usuarios"
$users = import-csv $ImportPath
$i=0
foreach($user in $users){
    $i++
    $account = $user.UPN
    #configurando o Zone - BR = Brazil
    Set-MsolUser -UserPrincipalName $account -UsageLocation BR
    
    #configurando a licenças
    #ATENÇAO!! - Para novos usuários usar a linha abaixo com o parametro -Addlicenses 
    Set-MsolUserLicense -UserPrincipalName $account -AddLicenses $acctsku -LicenseOptions $Office
    
    #ATENÇAO!! - Para usuários com licenças, e que precisam add ou remover algum app usar a linha abaixo com o parametro
    #Set-MsolUserLicense -UserPrincipalName $account -LicenseOptions $OfficeGedes
    Write-Host "Configurando licencas para o usuario $i - $Account -" $user.nome
    }