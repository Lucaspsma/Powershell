$fileUsers = Read-host "Digite o caminho completo local do arquivo de saida"
$headerUser = "SamAccountname;Username;mail;LastLogon"
$headerUser | Out-File $fileUsers -Append

$time = (get-date).AddDays(-100)
$userss = get-aduser -Filter {lastlogon -ge $time} -Properties * 
$I = 0
  foreach($U in $userss){
      $I++
      $date = [datetime]::FromFileTime($u.lastlogon).tostring("dd-MM-yyyy")
      Write-Host $I - $u.samaccountname - $u.name - $u.mail - $date -ForegroundColor Cyan
      $resultuser  = $u.samaccountname +";"+ $u.name +";"+ $u.mail +";"+ $date
      $resultuser | Out-File $fileUsers -Append
  }
