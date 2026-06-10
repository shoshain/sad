#requires -Version 5.1
<#
.SYNOPSIS
  Verify all three tier walkthrough approvals are checked.
.DESCRIPTION
  Exit 0: all approved; Exit 2: missing, unchecked, or pending (blocks tasks.md).
  -ReportOnly prints per-tier status without failing on pending (still exit 2 unless all approved).
.EXAMPLE
  .\check-tier-approvals.ps1 .\specs\001-my-feature
  .\check-tier-approvals.ps1 .\specs\001-my-feature -ReportOnly -Json
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$FeatureDir,
    [switch]$ReportOnly,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_sad-approval-lib.ps1')

function Write-Err { param([string]$Msg) [Console]::Error.WriteLine($Msg) }

$tiers = @('non-technical','semi-technical','technical')
$rows  = @()

foreach ($tier in $tiers) {
    $label = Get-SadTierLabel $tier
    $file  = Get-SadTierFile $FeatureDir $tier
    $st    = Get-SadApprovalStatus $file $label
    $prep  = Get-SadApprovalField $file '(?i)prepared for:'
    $since = Get-SadApprovalField $file '(?i)pending since:'
    $rows += [pscustomobject]@{ tier=$tier; status=$st; prepared_for=$prep; pending_since=$since }
}

if ($ReportOnly -or $Json) {
    if ($Json) {
        $rows | ConvertTo-Json -Compress
    } else {
        foreach ($r in $rows) {
            Write-Output "$($r.tier): $($r.status) (prepared_for=$($r.prepared_for), pending_since=$($r.pending_since))"
        }
    }
    if (Test-SadAllTiersApproved $FeatureDir) { exit 0 } else { exit 2 }
}

$ok = $true
foreach ($r in $rows) {
    $label = Get-SadTierLabel $r.tier
    $file  = Get-SadTierFile $FeatureDir $r.tier
    switch ($r.status) {
        'approved' { }
        'pending' {
            Write-Err "Tier '$label' is pending async review in $file -- blocks /sad-tasks until approved."
            $ok = $false
        }
        'missing' {
            Write-Err "missing $file"
            $ok = $false
        }
        default {
            Write-Err "Tier approval not checked for '$label' in $file"
            $ok = $false
        }
    }
}

if (-not $ok) {
    Write-Err 'One or more tier approvals are incomplete. Complete walkthrough checkboxes or run /sad-stakeholder-report for async packets.'
    exit 2
}
exit 0
