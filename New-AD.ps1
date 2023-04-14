Clear-Host

function Set-OU ($Service) {
    if ($Service -like "Dev") {
        return "OU=Dev,OU=Technique,DC=projet,DC=local"
    } elseif ($Service -like "Prod") {
        return "OU=Prod,OU=Technique,DC=projet,DC=local"
    } elseif ($Service -like "Support") {
        return "OU=Support,OU=Technique,DC=projet,DC=local"
    } else {
        Write-Host "OU non-reconnue" -ForegroundColor Red
    }   
}

function Find-User ($User) {
    $User = Get-ADUser -Filter {Name -eq $User}
    if ($User) {
        return $true
    } else {
        return $false
    } 
}

$usersExistants = @()
$usersSupprimes = @()

Import-Csv -Path "./Desktop/users.csv" -Delimiter ";" | ForEach-Object {
    $name = $_.prenom + " " + $_.nom
    $samAccountName = $_.prenom.Substring(0, 1) + "." + $_.nom
    $path = Set-OU -Service $_.service
    $password = ConvertTo-SecureString -String "Projet34!" -AsPlainText -Force
    
    if (Find-User -User $name) {
        Write-Host "Utilisateur $name existe déjà !" -ForegroundColor Red
        $usersExistant = @{
            nom = $_.nom
            prenom = $_.prenom
            service = $_.service
        }
        Write-Host $usersExistants
        $usersExistants += name

    } else {
        New-ADUser `
        -Name $name `
        -GivenName $_.prenom `
        -Surname $_.nom `
        -SamAccountName $samAccountName `
        -UserPrincipalName "$samAccountName@projet.local" `
        -Path $path `
        -AccountPassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $true

        if (Find-User -User $name) {
            Write-Host "Utilisateur $name ajouté !" -ForegroundColor Green
        }
    }
}

$usersActifs = Get-ADUser -Filter *

foreach ($user in $usersActifs) {
    $name = $user.Name
    if ($name -notin (Import-Csv -Path "./Desktop/users.csv" -Delimiter ";" | ForEach-Object {$_.prenom + " " + $_.nom})) {
        Write-Host "L'utilisateur $name doit être supprimé de l'Active Directory."
        $usersSupprimes += $name
    }
}

foreach ($user in $usersSupprimes) {
    Remove-ADUser -Identity $user -Confirm:$false
    Write-Host "L'utilisateur $user a été supprimé de l'Active Directory." -ForegroundColor Green
}

($usersExistants | Select-Object @{Name="Nom";Expression={$_}}, @{Name="Prenom";Expression={$_.Value.prenom}}) | Export-Csv -Path "./Desktop/Utilisateurs_dej_connus.csv" -Delimiter ";" -NoTypeInformation  
($usersSupprimes | Select-Object @{Name="Nom";Expression={$_}}) | Export-Csv -Path "./Desktop/Utilisateurs_supprimes.csv" -Delimiter ";" -NoTypeInformation  