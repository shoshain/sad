#requires -Version 5.1
<#
.SYNOPSIS
  Claude Code PreToolUse adapter for check-tier-approvals.ps1.
.DESCRIPTION
  Claude Code sends the hook input as JSON on stdin; this reads tool_input.file_path
  (a specs\<slug>\tasks.md being written) and checks that feature's tier approvals.
  Exit 0: allow. Exit 2: block; stderr is shown to Claude as the reason.
#>
$ErrorActionPreference = 'Stop'

$filePath = $null
try {
    $filePath = ([Console]::In.ReadToEnd() | ConvertFrom-Json).tool_input.file_path
} catch { }

if (-not $filePath) {
    [Console]::Error.WriteLine('SAD tier gate: could not read tool_input.file_path from the hook input, so tasks.md stays blocked. Check .sad/scripts/hook-tier-gate.ps1.')
    exit 2
}

& (Join-Path $PSScriptRoot 'check-tier-approvals.ps1') (Split-Path -Parent $filePath)
exit $LASTEXITCODE
