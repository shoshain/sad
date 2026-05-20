#requires -Version 5.1
<#
.SYNOPSIS
  Verify all three tier walkthrough approvals are checked.
.DESCRIPTION
  Exit 0: all approved; Exit 2: missing or unchecked (matches hooks/stakeholder-tier-router.json).
.EXAMPLE
  .\check-tier-approvals.ps1 .\specs\001-my-feature
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$FeatureDir
)

$ErrorActionPreference = 'Stop'

function Write-Err { param([string]$Msg) [Console]::Error.WriteLine($Msg) }

function Test-ApprovalLine {
    param([string]$File, [string]$Label)
    if (-not (Test-Path $File)) {
        Write-Err "missing $File"
        return $false
    }
    $pattern = "(?i)^-\s*\[x\].*$([regex]::Escape($Label)).*reviewer"
    $hit = Select-String -Path $File -Pattern $pattern -Quiet
    if (-not $hit) {
        Write-Err "Tier approval not checked for '$Label' in $File"
        return $false
    }
    return $true
}

$ok = $true
if (-not (Test-ApprovalLine (Join-Path $FeatureDir 'walkthroughs\non-technical.md')  'Non-technical'))  { $ok = $false }
if (-not (Test-ApprovalLine (Join-Path $FeatureDir 'walkthroughs\semi-technical.md') 'Semi-technical')) { $ok = $false }
if (-not (Test-ApprovalLine (Join-Path $FeatureDir 'walkthroughs\technical.md')      'Technical'))      { $ok = $false }

if (-not $ok) {
    Write-Err 'One or more tier approvals are incomplete. Complete walkthrough checkboxes per LIFECYCLE.md.'
    exit 2
}
exit 0
