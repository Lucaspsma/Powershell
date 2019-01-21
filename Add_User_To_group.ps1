#Script para add uma lista de usuários no Grupo especificado
Write-Host "Script para adicionar uma lista de usuários ao grupo espeficido" -BackgroundColor Green

#Declação de Variaveis
$DomainController = Read-Host "Digite o FQDN do domain controller principal"
#$I = 0

#caminho UNC da Lista
$Sourcepath = Read-Host "Informar o Caminho absoluto onde o arquivo com os usuários se encontra: (Ex.: C:\temp\lista.txt) "
$users = Import-Csv -Path $Sourcepath
$Group = Read-Host "Informe o grupo que os usuários serão inseridos"

$Confirmacao = Read-Host "Pode iniciar a execução do script? (Y para Sim ou N para Não)"
If($Confirmacao -eq "y"){
ForEach($user in $users){

$Account = $user.SamAccountName
$AccountConfirm = Get-ADUser -identity $Account
Add-ADGroupMember -Identity $Group -Members $AccountConfirm -Server $DomainController
Write-Host "Usuário $account foi inserido no grupo $group" -ForegroundColor Green
    }

}Else {
    Write-Host "Scrip cancelado" -ForegroundColor RED
}
