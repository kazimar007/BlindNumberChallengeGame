# Author: Nikolas D'Amato
# Email : kazimar.terraria@gmail.com
# Date: 2023-03-14
# Description: 

# -----------------------------------------FUNCTIONS----------------------------------------- #

<# 
    Function: LoadingAnimation
    Description: Displays a loading animation
    Parameters: None
    Returns: None
#>
function LoadingAnimation {
    $animation = @("|", "/", "-", "\")
    $i = 0
    while ($i -lt 10) {
        Write-Host "`r$($animation[$i % 4])" -NoNewline
        Start-Sleep -Milliseconds 100
        $i++
    }
    Write-Host "`r "
}

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
        LoadingAnimation
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

# ---------------Start Game Functions--------------- #

function StartGame {
    ShowInstructions
    $difficulty = ChooseDifficulty
    $numbers = @()
    for ($i = 0; $i -lt $difficulty; $i++) {
        $numbers += ""
    }

    do {
        DisplayGame -numbers $numbers
        $numbers = PlaceNumber -numbers $numbers
    } while (CheckIfNotWin -numbers $numbers)

    
}

<#
    Function: DisplayGame
    Description: Displays the game
    Parameters: 
        -numbers: The array of numbers
    Returns: None
#>
function DisplayGame {
    param(
        [string[]]$numbers
    )

    Clear-Host

    Write-Host "-- Blind Number Challenge --`n"

    for ($i = 0; $i -lt $numbers.Count; $i++) {
        Write-Host "$($i+1). $($numbers[$i])"
    }
}

<#
    Function: PlaceNumber
    Description: Places a number in the array
    Parameters: 
        -numbers: The array of numbers
    Returns: None
#>
function PlaceNumber {
    param(
        [string[]]$numbers
    )

    Write-Host "Generating random number...`n"
    do {
        LoadingAnimation
        $number = GenerateRandomNumber
    } while (CheckIfAlreadyInArray -numbers $numbers -number $number)

    Write-Host "The number is: $number`n"

    if (CheckIfLose -numbers $numbers -number $number) {
        Write-Host "You lost!`n"

        LoadingAnimation

        ExitGame
        # TODO: Show lose screen
    }

    do {
        Write-Host "Enter the position where you want to place the number: "
        $position = Read-Host
        LoadingAnimation
    } while ((CheckIfValidPosition -numbers $numbers -position $($position - 1)) -eq $true)
    $numbers[$($position - 1)] = $number

    return $numbers
}

function CheckIfAlreadyInArray {
    param(
        [string[]]$numbers,
        [string]$number
    )

    if ($numbers -contains $number) {
        return $true
    } else {
        return $false
    }
}

<#
    Function: CheckIfValidPosition
    Description: Checks if the position is valid
    Parameters: 
        -numbers: The array of numbers
        -position: The position to check
    Returns: True if the position is valid, false otherwise
#>
function CheckIfValidPosition {
    param(
        [string[]]$numbers,
        [string]$position
    )

    if (CheckIfIsANumber -number $position -eq $false) {
        return $false
    }

    if ((CheckIfNumberIsBetween -number $($position + 1) -min 1 -max $numbers.Count) -ne $true) {
        return $false
    }

    if ($numbers[$position] -ne "") {
        return $false
    }
    
    for ($i = $position; $i -ge 0; $i--) {
        if ($numbers[$i] -ne "") {
            if ($numbers[$i] -gt $number) {
                return $false
            }
            break
        }
    }
    
    for ($i = $position; $i -lt $numbers.Count; $i++) {
        if ($numbers[$i] -ne "") {
            if ($numbers[$i] -lt $number) {
                return $false
            }
            break
        }
    }
    
    return $true
}

<#
    Function: CheckIfIsANumber
    Description: Checks if a string is a number
    Parameters: 
        -number: The string to check
    Returns: True if the string is a number, false otherwise
#>
function CheckIfIsANumber {
    param(
        [string]$number
    )

    if ($number -match "^[0-9]+$") {
        return $true
    } else {
        return $false
    }
}

<#
    Function: CheckIfLose
    Description: Checks if the user lost the game
    Parameters: 
        -numbers: The array of numbers
        -number: The number to check
    Returns: True if the user lost, false otherwise
#>
function CheckIfLose {
    param(
        [string[]]$numbers,
        [int]$number
    )

    $isEmpty = $true

    <#for ($i = 0; $i -lt $numbers.Count; $i++) {
        if ($numbers[$i] -ne "") {
            if ($numbers[$i] -gt $number) {
                return $true
            }
            break
        }
    }

    for ($i = $numbers.Count-1; $i -ge 0; $i--) {
        if ($numbers[$i] -ne "") {
            if ($numbers[$i] -lt $number) {
                return $true
            }
            break
        }
    }

    return $false#>

    for ($i = 0; $i -lt $numbers.Count; $i++) {
        if ($numbers[$i] -eq "") {
            if ($i -ne $numbers.Count-1) {
                if ($numbers[$i+1] -ne "") {
                    $isEmpty = $false
                    if ($numbers[$i+1] -gt $number) {
                        return $false
                    }
                }
            }
        }
    }

    for ($i = $numbers.Count-1; $i -ge 0; $i--) {
        if ($numbers[$i] -eq "") {
            if ($i -ne 0) {
                if ($numbers[$i-1] -ne "") {
                    $isEmpty = $false
                    if ($numbers[$i-1] -lt $number) {
                        return $false
                    }
                }
            }
        }
    }

    if ($isEmpty -eq $true) {
        return $false
    }
    return $true
}

<#
    Function: CheckIfNotWin
    Description: Checks if the user didn't win the game
    Parameters: 
        -numbers: The array of numbers
    Returns: True if the user didn't win, false otherwise
#>
function CheckIfNotWin {
    # TODO: Use a increment variable to check if the number is equal to the array length instead
    param(
        [string[]]$numbers
    )

    for ($i = 0; $i -lt $numbers.Count; $i++) {
        if ($numbers[$i] -eq "") {
            return $true
        }
    }

    return $false
}

function ShowInstructions {
    # TODO: Show instructions
}

<# 
    Function: ChooseDifficulty
    Description: Asks the user to choose the difficulty of the game with a number between 2 and 50
    Parameters: None
    Returns: The difficulty chosen by the user
#>
function ChooseDifficulty {
    Clear-Host

    Write-Host "-- Choose Difficulty --`n"

    do {
        Write-Host "Choose how many numbers will be on the game (Min: 2 & Max: 50) : "
        $difficulty = Read-Host
        LoadingAnimation
    } while ((CheckIfNumberIsBetween -number $difficulty -min 2 -max 50) -ne $true)

    return $difficulty
}

<# 
    Function: GenerateRandomNumber
    Description: Generates a random number between 1 and 999
    Parameters: None
    Returns: The random number
#>
function GenerateRandomNumber {
    $randomNumber = Get-Random -Minimum 1 -Maximum 999
    return $randomNumber
}

# -----------------Stats Functions----------------- #

function ShowStats {
    Write-Host "Showing stats..."
}

# ---------------Exit Game Functions--------------- #

<# 
    Function: ExitGame
    Description: Exits the game
    Parameters: None
    Returns: None
#>
function ExitGame {
    Write-Host "Pleased to have played with you!"
    Write-Host "Exiting game..."
    LoadingAnimation
    Exit
}

# ----------------------------------------MAIN PROGRAM---------------------------------------- #

Clear-Host
LoadingAnimation
ShowMenu