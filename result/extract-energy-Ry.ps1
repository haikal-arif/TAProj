foreach ($val in [regex]::Matches((Get-Content .\LiCl.dat | Select-String Total | Select-String energy),  "\-?\d+(\.\d+)?")) {Write-Output $([float]$val.Value * 2)}
