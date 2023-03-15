# Author: Nikolas D'Amato
# Email : kazimar.terraria@gmail.com
# Date: 2023-03-14
# Description: 

# -----------------------------------------FUNCTIONS----------------------------------------- #

<# 
    Function: ShowLogo
    Description: Displays the logo of the game
    Parameters: None
    Returns: None
#>
function ShowLogo {
    Clear-Host
    Write-Host "_------------------------------------------------------------------------------------------------_"
    Write-Host "|    ___ _ _         _   _  _            _                ___ _         _ _                      |"
    Write-Host "|   | _ ) (_)_ _  __| | | \| |_  _ _ __ | |__  ___ _ _   / __| |_  __ _| | |___ _ _  __ _ ___    |"
    Write-Host "|   | _ \ | | ' \/ _' | | .' | || | '  \| '_ \/ -_) '_| | (__| ' \/ _' | | / -_) ' \/ _' / -_)   |"
    Write-Host "|   |___/_|_|_||_\__,_| |_|\_|\_,_|_|_|_|_.__/\___|_|    \___|_||_\__,_|_|_\___|_||_\__, \___|   |"
    Write-Host "|                                                                                   |___/        |"
    Write-Host "|------------------------------------------------------------------------------------------------|"
}

<#
    Function: ShowMenu
    Description: Displays the menu of the game
    Parameters: None
    Returns: None
#>
function ShowMenu {
    ShowLogo
    Write-Host "| 1. Start Game                                                                                  |"
    Write-Host "| 2. Stats                                                                                       |"
    Write-Host "| 3. Exit                                                                                        |"
    Write-Host "|------------------------------------------------------------------------------------------------|"
    Write-Host "`n"
    Do {
        Write-Host "Enter your choice: "
        $choice = Read-Host
    } while ((CheckIfNumberIsBetween -number $choice -min 1 -max 3) -ne $true)
    
    switch ($choice) {
        1 { StartGame }
        2 { ShowStats }
        3 { ExitGame }
    }
}

<#
    Function: CheckIfNumberIsBetween
    Description: Checks if a number is between a minimum and maximum value
    Parameters: 
        -number: The number to check
        -min: The minimum value
        -max: The maximum value
    Returns: True if the number is between the min and max values, false otherwise
#>
function CheckIfNumberIsBetween {
    param(
        [string]$number,
        [int]$min,
        [int]$max
    )

    if ($number -ge $min -and $number -le $max) {
        return $true
    } else {
        return $false
    }
}

function StartGame {
    Write-Host "Starting game..."
}

function ShowStats {
    Write-Host "Showing stats..."
}

<# 
    Function: ExitGame
    Description: Exits the game
    Parameters: None
    Returns: None
#>
function ExitGame {
    Write-Host "Pleased to have played with you!"
    Write-Host "Exiting game..."
    Exit
}

# ----------------------------------------MAIN PROGRAM---------------------------------------- #

ShowMenu