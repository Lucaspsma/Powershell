$IContact=0

$DLGroups = get-ADGroup -Filter{GroupCategory -eq "Security"} -Properties cn,sAMAccountName, distinguishedname
$OUGruposvazios = Read-Host "Digite a OU que será movida os grupos fazios (ex.: OU=name,dc=dominio,dc=com)"
    foreach($DLgroup in $DLGroups){
        $DLMembers = Get-ADGroupMember -Identity $DLgroup.sAMAccountName 
            If($DLMembers -eq $Null){
                $IContact++
                Write-host $IContact ":" $DLgroup.sAMAccountName -ForegroundColor Cyan
                $DLMove = $DLgroup.objectguid
                Move-ADObject -Identity $DLMove -TargetPath $OUGruposvazios
            }
        }

