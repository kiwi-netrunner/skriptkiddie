# Breached PS App

# Animation Starts
Start-Sleep -Milliseconds 500

$text = @"
 ________  ________  _______   ________  ________  ___  ___  _______   ________     
|\   __  \|\   __  \|\  ___ \ |\   __  \|\   ____\|\  \|\  \|\  ___ \ |\   ___ \    
\ \  \|\ /\ \  \|\  \ \   __/|\ \  \|\  \ \  \___|\ \  \\\  \ \   __/|\ \  \_|\ \   
 \ \   __  \ \   _  _\ \  \_|/_\ \   __  \ \  \    \ \   __  \ \  \_|/_\ \  \ \\ \  
  \ \  \|\  \ \  \\  \\ \  \_|\ \ \  \ \  \ \  \____\ \  \ \  \ \  \_|\ \ \  \_\\ \ 
   \ \_______\ \__\\ _\\ \_______\ \__\ \__\ \_______\ \__\ \__\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|__|\|__|\|_______|\|__|\|__|\|_______|\|_______|
"@

# Split the text into lines
$lines = $text -split "`n"

# Write each line below the previous one
foreach ($line in $lines) {
    Write-Host $line
    Start-Sleep -Milliseconds 100
}

# Delete all lines
Clear-Host

# Define the colours to cycle between
$colours = @([System.ConsoleColor]::Yellow, [System.ConsoleColor]::Cyan)

# Function to display the text in a specific colour
function Display-TextInColor {
    param (
        [string]$text,
        [System.ConsoleColor]$colour
    )
    Clear-Host
    Write-Host $text -ForegroundColor $colour
}

# Logo to display
$text = @"
 ________  ________  _______   ________  ________  ___  ___  _______   ________     
|\   __  \|\   __  \|\  ___ \ |\   __  \|\   ____\|\  \|\  \|\  ___ \ |\   ___ \    
\ \  \|\ /\ \  \|\  \ \   __/|\ \  \|\  \ \  \___|\ \  \\\  \ \   __/|\ \  \_|\ \   
 \ \   __  \ \   _  _\ \  \_|/_\ \   __  \ \  \    \ \   __  \ \  \_|/_\ \  \ \\ \  
  \ \  \|\  \ \  \\  \\ \  \_|\ \ \  \ \  \ \  \____\ \  \ \  \ \  \_|\ \ \  \_\\ \ 
   \ \_______\ \__\\ _\\ \_______\ \__\ \__\ \_______\ \__\ \__\ \_______\ \_______\
    \|_______|\|__|\|__|\|_______|\|__|\|__|\|_______|\|__|\|__|\|_______|\|_______|
"@

# Loop to cycle through the colours
$count = 0
while ($count -le 3) {
foreach ($colour in $colours) {
    Display-TextInColor -text $text -colour $colour
    Start-Sleep -Milliseconds 250
    }
    $count++
}
# Animation Ends

# Funtioning part starts here
while ($condition -le 0){

# Prompt the user to drop the source file
$csvPath = Read-Host -Prompt "`nPlease drop the source file here"

# Check if the source file exists
if (Test-Path -Path $csvPath) {
    # Import the CSV file
    $csv = Import-Csv -Path $csvPath
    Write-Output "File is loaded: $csvPath"

# Check if the source file contains the column 'Account'
    if ($csv[0].PSObject.Properties.Name -contains 'Account') {
    $condition++
    Start-Sleep -Milliseconds 2000

    if ($csv) {
        Write-Output "Searching for matches..."
        $matchedEmails = @()

        $chars = "/", "-", "\", "|"
        $state = 1
        $counter = 0
        $mult = 1
        $colour = "Green"

        Start-Sleep -Milliseconds 750

        # Loop through each email address in the file
        foreach ($row in $csv) {

            for ($i=0; $i -le 3; $i++) {
                $progress = $chars[$i]
                Write-Host -NoNewLine "`r$progress" -ForegroundColor $colour -BackgroundColor Black
                Start-Sleep -Milliseconds 150
            }

            $email = $row.Account

            # Search for the user in the first Active Directory server
            $user1 = Get-ADUser -Filter {EmailAddress -eq $email} -server YOURSERVER1 -Properties EmailAddress, Enabled

            if ($user1 -and $user1.Enabled) {
                $matchedEmails += $email
                $colour = "Red"
            }

            # Search for the user in the second Active Directory server
            $user2 = Get-ADUser -Filter {EmailAddress -eq $email} -server YOURSERVER2 -Properties EmailAddress, Enabled

            if ($user2 -and $user2.Enabled) {
                $matchedEmails += $email
                $colour = "Red"
            }
        }

        # Display the matched emails after the process is finished
        Write-Output "`nMatched Emails:"
        $matchedEmails | ForEach-Object { Write-Output $_ }
    } else {
        Write-Output "Failed to load the source file."
    }

} else {
        Write-Output "File does not contain the 'Account' column: $csvPath"
    }

} else {
    Write-Output "The file path is not valid."
}
}
# Prevent the PowerShell window from closing automatically
Read-Host -Prompt "`nPress Enter to exit"
