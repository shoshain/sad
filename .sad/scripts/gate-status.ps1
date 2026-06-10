#requires -Version 5.1
<#
.SYNOPSIS
  Program-level approval queue across all specs/<slug>/ features.
.EXAMPLE
  .\gate-status.ps1
  .\gate-status.ps1 -Json
#>
[CmdletBinding()]
param(
    [switch]$Json,
    [string]$RepoRoot
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_sad-approval-lib.ps1')

if (-not $RepoRoot) {
    $RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
} else {
    $RepoRoot = Resolve-Path $RepoRoot
}

$specs = Join-Path $RepoRoot 'specs'
if (-not (Test-Path $specs)) {
    Write-Output "No specs/ directory under $RepoRoot"
    exit 0
}

function Get-Symbol([string]$Status) {
    switch ($Status) {
        'approved'  { return '✅' }
        'pending'   { return '⏳' }
        default     { return '⬜' }
    }
}

$rows = @()
foreach ($f in Get-ChildItem $specs -Directory | Sort-Object Name) {
    $pendingSince = ''
    $delegate     = ''
    $tierSyms     = @{}
    foreach ($tier in @('non-technical','semi-technical','technical')) {
        $label = Get-SadTierLabel $tier
        $file  = Get-SadTierFile $f.FullName $tier
        $st    = Get-SadApprovalStatus $file $label
        $tierSyms[$tier] = Get-Symbol $st
        if ($st -eq 'pending' -and -not $pendingSince) {
            $pendingSince = Get-SadApprovalField $file '(?i)pending since:'
            $delegate     = Get-SadApprovalField $file '(?i)prepared for:'
        }
    }
    $rec = '—'
    $recFile = Join-Path $f.FullName 'reconciliation.md'
    if (Test-Path $recFile) {
        $rb = Get-Content $recFile -Raw
        $rec = if ($rb -match '(?im)^-\s*\[x\].*Semi-technical.*reviewer') { '✅' } else { '⏳' }
    }
    $rows += [pscustomobject]@{
        feature       = $f.Name
        non_technical = $tierSyms['non-technical']
        semi_technical= $tierSyms['semi-technical']
        technical     = $tierSyms['technical']
        reconcile     = $rec
        pending_since = $pendingSince
        delegate      = $delegate
    }
}

if ($Json) {
    $rows | ConvertTo-Json -Compress
    exit 0
}

Write-Output "/sad-gate-status -- approval queue ($($rows.Count) feature(s))"
Write-Output ('-' * 80)
$rows | Format-Table -Property feature, non_technical, semi_technical, technical, reconcile, pending_since, delegate -AutoSize
