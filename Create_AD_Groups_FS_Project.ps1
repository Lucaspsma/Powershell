#################################
## 1- Script para criar os grupos de acessos para o File Server de acordo com o padrão do projeto
## Grupos Domain Locais, Grupos Globais
## 2- Cria pasta diretamente no Fileserver em questão
#################################

Write-Host "Script para criar os grupos de acessos para o File Server de acordo com o padrão do projeto" -BackgroundColor Green

#Declação de Variaveis
$DomainController = Read-host "Digite o FQDN do domain controller principal"
$GroupOU = Read-host "Digite a OU que será criado o Grupo em questão"

#Limpando a variavel
$validaGrupo1 = ""
$validaGrupo2 = ""
$validaGrupo3 = ""
$validaGrupo4 = ""
$setor = ""
$FolderName = ""

#Preencher os nomes dos grupos de acordo com o padrão - Informe o Nome do Setor, Exemplo: ADM, Financeiro, MKT
$setor = Read-Host "Informar o nome do Setor" 

#Informe o nome da pasta do File Server, Exemplo: Arquitetura, Operacao, ServiceDesk
$FolderName =  Read-Host "Informar o nome da Pasta que precisa criar o grupo de acesso: (Exemplo: Arquitetura, Operacao, Service Desk)" 

IF($setor -eq "" -or $FolderName -eq "")
    {
        Write-Host "Não é possivel executar a ação, os campos não foram preenchidos. Repita a operação" -ForegroundColor Red
    }
    Else
    {
        $GG_R_Group = "GG_FS_R_$($Setor)_$FolderName"   #Grupo Global Read
        $GG_W_Group = "GG_FS_W_$($Setor)_$FolderName"   #Grupo Global Write
        $GL_W_Group = "GL_FS_W_$($Setor)_$FolderName"   #Grupo Local Write
        $GL_R_Group = "GL_FS_R_$($Setor)_$FolderName"   #Grupo Local Read

        #Confirmação de seguir com o processo
        $Confiramacao = Read-Host "Os nomes dos grupos serão $GG_R_Group ;$GG_W_Group ;$GL_W_Group;$GL_R_Group ;Tem certeza que deseja proseguir com a criacao dos grupos? (Y para SIM ou N para NAO)"
            IF($Confiramacao -eq "y")
            {
                Write-Host "Informar as credencias administrativas" -ForegroundColor Yellow
                $Cred = Get-Credential
                Write-Host "Criando grupos de Segurança - File Server" -ForegroundColor Yellow
                New-ADGroup -Name $GG_R_Group -GroupScope Global -GroupCategory Security -Path $GroupOU -Description "Read no Recurso - Pasta $FolderName" -Server $DomainController -Credential $Cred
                $validaGrupo1 = Get-ADGroup -Identity $GG_R_Group -Server $DomainController
                New-ADGroup -Name $GG_W_Group -GroupScope Global -GroupCategory Security -Path $GroupOU -Description "Write no Recurso - Pasta $FolderName" -Credential $Cred -Server $DomainController
                $validaGrupo2 = Get-ADGroup -Identity $GG_R_Group -Server $DomainController
                New-ADGroup -Name $GL_R_Group -GroupScope DomainLocal -GroupCategory Security -Path $GroupOU -Description "Acesso ao Recurso File Server - Read - Pasta $FolderName" -Server $DomainController -Credential $Cred
                $validaGrupo3 = Get-ADGroup -Identity $GL_R_Group -Server $DomainController
                New-ADGroup -Name $GL_W_Group -GroupScope DomainLocal -GroupCategory Security -Path $GroupOU -Description "Acesso ao Recurso File Server - Write - Pasta $FolderName" -Server $DomainController -Credential $Cred
                $validaGrupo4 = Get-ADGroup -Identity $GL_W_Group -Server $DomainController
                If($validaGrupo1 -eq "" -or $validaGrupo2 -eq "" -or $validaGrupo3 -eq "" -or $validaGrupo4 -eq "")
                {
                    Write-Host "Falha ao criar os grupos. Verificar acessos ao servidor ou se tem o modulo de Active Directory Instaldo" -ForegroundColor Red -ErrorAction Stop
                }
                else {
                        Write-Host "Grupos Criados - File Server" -ForegroundColor Green
                        Write-Host "Inserindo grupos Globais nos grupos Locais" -ForegroundColor Cyan
                        Add-ADGroupMember -Identity $GL_R_Group -Members $GG_R_Group -Server $DomainController -Credential $Cred
                        Add-ADGroupMember -Identity $GL_W_Group -Members $GG_W_Group -Server $DomainController -Credential $Cred
                        Write-Host "Grupos Globais nos locais adicionados com sucessor" -ForegroundColor Green
                        Write-host "Atencao!!!!   Proxima ação é adicionar os usuários nos grupos globais de Read ou Write" -BackgroundColor Green -ForegroundColor Black
                    }
            }
            Else{
                    Write-Host "Operação Cancelada pelo Usuário" -ForegroundColor Red
                }
     #Etapa de Criar pasta no File Server
            $NewFolderRequest = Read-Host "Deseja criar pasta no File Server para o Setor $setor? (Y para Sim ou N para Nao)"
            IF($NewFolderRequest -eq "y")
            {
                $FileserverPath = Read-Host "Informar o local onde será criada a nova pasta: (exemplo \\Servidor\Share)" -ForegroundColor Yellow
                $DestinationPath = Join-Path $FileserverPath $FolderName
                If(Test-Path $DestinationPath)
                    {
                        Write-Host "Pasta $Foldername já existe no diretorio informado $fileserverPath" -ForegroundColor Red
                    }
                    Else{
                        Write-Host "Criando pasta no diretorio $destinationpath, ação realiaza com o usuário $($cred.UserName)"
                        New-PSDrive -Name NewDrive -PSProvider FileSystem -Root $FileserverPath -Credential $Cred
                        New-item -ItemType Directory -Force -Path NewDrive:\$FolderName -ErrorAction Stop
                        Remove-PSDrive -Name NewDrive
                        If(Test-Path $DestinationPath){
                            Write-Host "A pasta do setor $Setor foi criada com sucesso = $DestinationPath" -ForegroundColor Green
                        }
                        Else{Write-Error "Falha ao criar a pasta" -ErrorAction Stop}
                    }
            }
            Else{
                    Write-Host "Operação de criar pasta cancelada" -ForegroundColor Red
                }
    }
