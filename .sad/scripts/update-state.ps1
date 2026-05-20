#requires -Version 5.1
<#
.SYNOPSIS
  Patch fields in .sad/state/sad-state.md (simple key/value lines).
.EXAMPLE
  .\update-state.ps1 -Feature      001-my-feature
  .\update-state.ps1 -Phase        walkthrough
  .\update-state.ps1 -LastCommand  /sad-plan
#>
[CmdletBinding()]
param(
    [string]$Feature,
    [string]$Phase,
    [string]$LastCommand
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Resolve-Path (Join-Path $scriptDir '..\..')
$state     = Join-Path $root '.sad\state\sad-state.md'

if (-not (Test-Path $state)) { exit 1 }

function Replace-Kv {
    param([string]$Key, [string]$Val)
    if (-not $Val) { return }
    $content = Get-Content $state -Raw
    $escapedKey = [regex]::Escape($Key)
    # Template uses '- **Slug:** [...]' (colon inside bold). Match exactly that.
    $pattern = "(?m)^(- \*\*${escapedKey}:\*\* ).*$"
    $replacement = "`${1}$Val"
    $new = [regex]::Replace($content, $pattern, $replacement)
    if ($new -ne $content) {
        Set-Content -Path $state -Value $new -Encoding utf8 -NoNewline
    } else {
        Write-Warning "No '- **${Key}:** ...' line found in $state"
    }
}

Replace-Kv 'Slug'         $Feature
Replace-Kv 'Phase'        $Phase
Replace-Kv 'Last command' $LastCommand

Write-Output "Updated $state"
