Function Show-CompourriLogo {
    <#
        .SYNOPSIS
            Displays the Compourri logo in ASCII art.
        .DESCRIPTION
            This function displays the Compourri logo in ASCII art format.
        .PARAMETER None
            No parameters are required for this function.
        .EXAMPLE
            Show-CompourriLogo
            Prints the Compourri logo in ASCII art format to the console.
    #>

    $asciiArt = @"

       @@@@@@    @@@@@@    @@@      @@@  @@@@@@@     @@@@@@    @@@    @@@  @@@@@@@   #@@@@@@  =@@@
     @@.    =  @@@    @@@  @*@@     @@@  @@@   @@@ @@@    %@@  %@%    @*@  @@   @@:  @@   @@%
    @@        @@@      @@  @*%@@   @ @@  @@@   @@@ @@       @@ #@%    @*@  @@   @@   @@   @@  -@@@
    @@        @@@      @@  @#: @@ @+ @@  @@@@@@@   @@       @@ @@=    *-@  @@@@@     @@@@@     @@*
    -@@        @@#    @@@  @%%  @@#  @@  @@-       @@@    .@@   @@    @@   @@  @@@   @@  @@@   @@*
      %@@@@@@    @@@@@@    @@@       @@  @@@         @@@@@@      @@@@@@   @@@   @@@ #@@   @@@.=@@@

                                     ====Compourri Software Essentials====
"@

    Write-Host $asciiArt
}

