#Script para mover os dados Contato, Group e DL para local especificos

#mudança de Objetos - Contatos
Write-Host Inico da mudança de Contatos -ForegroundColor Yellow
$contacts = import-csv "C:\temp\ContactMudanca.csv"
$fileContact = "C:\temp\ResultMoveContat.csv"
$desContact = Read-host "Digite a OU de destino para mover os contatos (Ex.: ou=name,dc=dominio,dc=com)"

ForEach($contact in $contacts){
$mail = $Contact.mail
$ContactInfo = Get-ADObject -filter{Mail -eq $mail} -Properties mail
Write-Host $ContactInfo.mail
#Movendo o Contato
Move-ADObject -Identity $ContactInfo.distinguishedname -TargetPath $desContact -Credential 
$ResultMoveContact = Get-ADObject -filter{Mail -eq $mail} -Properties mail
$ResultContact = $ResultMoveContact.name +";"+ $ResultMoveContact.mail +";"+ $ResultMoveContact.distinguishedname
$ResultContact | Out-File $fileContact -Append
}

############################################################
#mudança de Objetos - Distribution List
Write-Host Inico da mudança de Lista de Distribuição -ForegroundColor Cyan
$DistributionLists = import-csv "C:\temp\dlMudanca.csv"
$fileDL = "C:\temp\ResultMoveDL.csv"
$desDL = Read-host "Digite a OU de destino para mover os Grupos (Ex.: ou=name,dc=dominio,dc=com)"

  ForEach($DistributionList in $DistributionLists){
    $DLSan = $DistributionList.SamAccountName
    $DLInfo = Get-ADGroup -Filter {SamAccountName  -eq $DLSan} -Properties mail
    Write-host $DLInfo.SamAccountName

    #Movendo os Grupos 
    Move-ADObject -Identity $DLInfo.distinguishedname -TargetPath $desDL -Credential 
    $ResultMoveDL = Get-ADObject -filter{SamAccountName -eq $DLSan} -Properties mail
    $ResultDL = $ResultMoveDL.SamAccountName +";"+ $ResultMoveDL.mail +";"+ $ResultMoveDL.distinguishedname
    $ResultDL | Out-File $fileDL -Append
  }

############################################################

############################################################
#Mudança de Objetos - Grupo de Seguranca

Write-Host Inico da mudança de grupos de Segurança -ForegroundColor Blue
$SecurityGroups = import-csv "C:\temp\SGMudanca.csv"
$fileSG = "C:\temp\ResultMoveSG.csv"
$desSG = "Read-host "Digite a OU de destino para mover as DLs (Ex.: ou=name,dc=dominio,dc=com)"

  ForEach($SecurityGroup in $SecurityGroups){
    $SGSan = $SecurityGroup.SamAccountName
    $SGInfo = Get-ADGroup -Filter {SamAccountName  -eq $SGSan} -Properties mail
    Write-host $SGInfo.SamAccountName

    #Movendo o Contato
    Move-ADObject -Identity $SGInfo.distinguishedname -TargetPath $desSG -Credential
    $ResultMoveSG = Get-ADObject -filter{Mail -eq $SGSan} -Properties mail
    $ResultSG = $ResultMoveSG.name +";"+ $ResultMoveSG.mail +";"+ $ResultMoveSG.distinguishedname
    $ResultSG | Out-File $fileSG -Append
  }
 
