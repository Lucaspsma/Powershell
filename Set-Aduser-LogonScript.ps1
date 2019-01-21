#Script que seta o logon script para uma lista de usuários

Write-Host "Script para alterar o Script de Logon dos usuários de uma lista" -ForegroundColor Green

#Declação de Variaveis

$DomainController = Read-host "Escreve o FQDN do domain Controler (server.domain.com)"

$fileScript = "C:\temp\backup_script_logon_usuers.csv"
$headerScript = "SamAccountName;scriptLogon"
$headerScript | Out-File $fileScript -Append

#caminho UNC da Lista
$Sourcepath = Read-Host "Informar o Caminho absoluto onde o arquivo com os usuários se encontra: (Ex.: C:\temp\lista.txt) "
$users = Import-Csv -Path $Sourcepath
$ScriptName = Read-Host "Informe o nome do Script para ser add ao campo Script Logon"

$Confirmacao = Read-Host "Pode iniciar a execução do script? (Y para Sim ou N para Não)"
If($Confirmacao -eq "y"){
    foreach($user in $users){
        $Account = $user.SamAccountName
        $AccountConfirm = Get-ADUser -identity $Account -Properties ScriptPath

        #backup do scriptPath
        $resultScript = $AccountConfirm.SamAccountName +";"+ $AccountConfirm.ScriptPath
        $resultScript | Out-File $fileScript -Append

    Set-ADUser -Identity $Account -ScriptPath $ScriptName -Server $DomainController
    $AccountResult = Get-ADUser -identity $Account -Properties ScriptPath -Server $DomainController
    Write-Host "Dados Modificados" $AccountResult.SamAccountName - $AccountResult.scriptPath -ForegroundColor Green

  }
}
  Else {
      Write-Host "Scrip cancelado" -ForegroundColor RED
  }
