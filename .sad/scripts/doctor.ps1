#requires -Version 5.1
<#
.SYNOPSIS
  /sad-doctor — project-wide SAD health check.
.DESCRIPTION
  Reports green / yellow / red per check with one-line remediation hints.
  Exit 0 if no reds. Exit 1 if any reds. Exit 0 with non-empty yellow list is non-fatal.
#>
[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Resolve-Path (Join-Path $scriptDir '..\..')

$results = [System.Collections.Generic.List[object]]::new()

function Add-Check {
    param(
        [string]$Name,
        [ValidateSet('green','yellow','red')] [string]$Status,
        [string]$Message,
        [string]$Hint = ''
    )
    $results.Add([pscustomobject]@{
        name    = $Name
        status  = $Status
        message = $Message
        hint    = $Hint
    })
}

# --- Constitution ---
$constitution = Join-Path $root '.sad\memory\constitution.md'
if (-not (Test-Path $constitution)) {
    Add-Check 'constitution.exists' 'red' '.sad/memory/constitution.md is missing' 'Run /sad-constitution or copy a starter from .sad/templates/constitutions/'
} else {
    $body = Get-Content $constitution -Raw
    # Distinguish "untouched ships-with-the-kit template" (yellow, expected in the
    # methodology repo itself and on day 0 of a consuming project) from "someone
    # started filling it in and abandoned mid-edit" (red, blocks the gate).
    if ($body -match '(?m)^> \*\*Template\.\*\*') {
        Add-Check 'constitution.identity' 'yellow' 'Constitution is still the unmodified template' 'Run /sad-constitution or copy a starter from .sad/templates/constitutions/'
    } elseif ($body -match '\[name\]' -or $body -match '\[who\]') {
        Add-Check 'constitution.identity' 'red' 'Constitution still contains [name] / [who] placeholders' 'Fill in Identity section'
    } else {
        Add-Check 'constitution.identity' 'green' 'Identity section filled' ''
    }
    if ($body -notmatch '(?m)^\| A\d') {
        Add-Check 'constitution.articles' 'yellow' 'No article rows (A1, A2, ...) in the article index' 'Add at least 3 articles for the architectural-conformance reviewer'
    } else {
        Add-Check 'constitution.articles' 'green' 'Article index populated' ''
    }
    if ($body -notmatch 'Maturity level') {
        Add-Check 'constitution.maturity' 'red' 'Maturity level line missing in Identity' 'Add "Maturity level (initial): Level X" -- see MATURITY.md'
    } else {
        Add-Check 'constitution.maturity' 'green' 'Maturity level declared' ''
    }
}

# --- Stakeholders ---
foreach ($tier in @('non-technical','semi-technical','technical')) {
    $f = Join-Path $root ".sad\stakeholders\$tier.md"
    if (-not (Test-Path $f)) {
        Add-Check "stakeholders.$tier" 'red' "stakeholders/$tier.md missing" 'Run /sad-setup or copy from .sad/templates'
    } else {
        $b = Get-Content $f -Raw
        if ($b -match 'TBD' -or $b -match '\[List people') {
            Add-Check "stakeholders.$tier" 'yellow' "stakeholders/$tier.md still has TBD or placeholder names" 'Name real reviewers (or named placeholder roles)'
        } else {
            Add-Check "stakeholders.$tier" 'green' "stakeholders/$tier.md filled" ''
        }
    }
}

# --- Hooks ---
$hooksDir = Join-Path $root 'hooks'
if (Test-Path $hooksDir) {
    $hookCount = (Get-ChildItem $hooksDir -Filter '*.json' -ErrorAction SilentlyContinue | Measure-Object).Count
    Add-Check 'hooks.present' 'green' "$hookCount hook descriptor(s) found" ''
} else {
    Add-Check 'hooks.present' 'yellow' 'hooks/ directory missing (kit not fully installed?)' 'Re-run the installer'
}

# --- Per-feature ---
$specsDir = Join-Path $root 'specs'
if (Test-Path $specsDir) {
    $features = Get-ChildItem $specsDir -Directory
    if ($features.Count -eq 0) {
        Add-Check 'features.any' 'yellow' 'specs/ exists but is empty -- no features yet' 'Run .sad/scripts/create-feature.{sh,ps1} to scaffold your first feature'
    }
    foreach ($f in $features) {
        $required = @(
            'feature.spec.md','feature.plan.md','tasks.md','reconciliation.md',
            'walkthroughs\non-technical.md','walkthroughs\semi-technical.md','walkthroughs\technical.md'
        )
        $missing = @()
        foreach ($r in $required) {
            if (-not (Test-Path (Join-Path $f.FullName $r))) { $missing += $r }
        }
        if ($missing.Count -gt 0) {
            Add-Check "feature.$($f.Name).artifacts" 'yellow' "$($f.Name) missing: $($missing -join ', ')" 'Re-run create-feature or fill in manually'
        } else {
            Add-Check "feature.$($f.Name).artifacts" 'green' "$($f.Name) has all required artifacts" ''
        }
    }
} else {
    Add-Check 'features.any' 'yellow' 'specs/ directory missing' 'Create at the project root; convention: specs/<NNN>-<slug>/'
}

# --- Scripts executable on this platform ---
$scriptsDir = Join-Path $root '.sad\scripts'
$psScripts  = Get-ChildItem $scriptsDir -Filter '*.ps1' -ErrorAction SilentlyContinue
$shScripts  = Get-ChildItem $scriptsDir -Filter '*.sh'  -ErrorAction SilentlyContinue
if ($IsWindows -or [Environment]::OSVersion.Platform -eq 'Win32NT') {
    if ($psScripts.Count -ge 4) {
        Add-Check 'scripts.platform' 'green' 'PowerShell scripts present (Windows-ready)' ''
    } else {
        Add-Check 'scripts.platform' 'yellow' "Only $($psScripts.Count) .ps1 scripts found; expected at least 4" 'See .sad/scripts/ for the expected set: create-feature, check-tier-approvals, drift-scan, update-state'
    }
} else {
    if ($shScripts.Count -ge 4) {
        Add-Check 'scripts.platform' 'green' 'Bash scripts present (POSIX-ready)' ''
    } else {
        Add-Check 'scripts.platform' 'yellow' "Only $($shScripts.Count) .sh scripts found; expected at least 4" ''
    }
}

# --- Output ---
$reds    = @($results | Where-Object { $_.status -eq 'red' }).Count
$yellows = @($results | Where-Object { $_.status -eq 'yellow' }).Count
$greens  = @($results | Where-Object { $_.status -eq 'green' }).Count

if ($Json) {
    [pscustomobject]@{
        summary = @{ red=$reds; yellow=$yellows; green=$greens }
        checks  = $results
    } | ConvertTo-Json -Depth 4
} elseif (-not $Quiet) {
    Write-Output "/sad-doctor -- $greens green, $yellows yellow, $reds red"
    Write-Output ('-' * 60)
    foreach ($r in $results) {
        $tag = switch ($r.status) {
            'green'  { '[OK] '   }
            'yellow' { '[WARN]'  }
            'red'    { '[FAIL]'  }
        }
        Write-Output "$tag $($r.name) -- $($r.message)"
        if ($r.hint) { Write-Output "       hint: $($r.hint)" }
    }
}

if ($reds -gt 0) { exit 1 } else { exit 0 }
