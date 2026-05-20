#requires -Version 5.1
<#
.SYNOPSIS
  List features missing reconciliation artifact (batch / CI helper).
.DESCRIPTION
  Exit 0: every feature dir has reconciliation.md.
  Exit 2: at least one feature dir is missing reconciliation.md.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Resolve-Path (Join-Path $scriptDir '..\..')
$specs     = Join-Path $root 'specs'

if (-not (Test-Path $specs)) {
    Write-Output "No specs/ directory at $specs (nothing to scan)."
    exit 0
}

$rc = 0
Get-ChildItem -Path $specs -Directory | ForEach-Object {
    $rec = Join-Path $_.FullName 'reconciliation.md'
    if (-not (Test-Path $rec)) {
        Write-Output "MISSING_RECONCILIATION $($_.FullName)"
        $rc = 2
    }
}
exit $rc
