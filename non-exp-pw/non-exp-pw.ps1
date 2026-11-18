# Repeated user lookup script
while ($true) {
    # Prompt the user to enter an email address or username
    $input = Read-Host -Prompt "`nEnter the user's email address or account name (or type 'exit' to quit)"

    if ($input -eq 'exit') {
        Write-Output "`nExiting the script. Goodbye!"
        break
    }

    if ($input) {
        Write-Output "`nSearching for user: $input"

        $userFound = $false

        # Determine if input is an email address
        if ($input -like "*@*") {
            $filterString = "EmailAddress -eq '$input'"
        } else {
            $filterString = "SamAccountName -eq '$input'"
        }

        # Search in the first AD server
        $user1 = Get-ADUser -Filter $filterString -Server YOURSERVER1 -Properties EmailAddress, SamAccountName, PasswordNeverExpires, Description
        if ($user1) {
            $userFound = $true
            Write-Output "`nUser found in YOURSERVER1"
            Write-Output "Account Name: $($user1.SamAccountName)"
            Write-Output "Email: $($user1.EmailAddress)"
            Write-Output "Password Never Expires: $($user1.PasswordNeverExpires)"
            Write-Output "Description: $($user1.Description)"
        }

        # Search in the second AD server
        $user2 = Get-ADUser -Filter $filterString -Server YOURSERVER2 -Properties EmailAddress, SamAccountName, PasswordNeverExpires, Description
        if ($user2) {
            $userFound = $true
            Write-Output "`nUser found in YOURSERVER2"
            Write-Output "Account Name: $($user2.SamAccountName)"
            Write-Output "Email: $($user2.EmailAddress)"
            Write-Output "Password Never Expires: $($user2.PasswordNeverExpires)"
            Write-Output "Description: $($user1.Description)"
        }

        if (-not $userFound) {
            Write-Output "`nUser not found in either AD server."
        }
    } else {
        Write-Output "No input entered. Please try again."
    }
}
