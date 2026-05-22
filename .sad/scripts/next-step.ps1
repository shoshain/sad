#requires -Version 5.1
<#
.SYNOPSIS
  Read-only state inspector for the SAD conductor and SessionStart hooks.

.DESCRIPTION
  Reads .sad/state/sad-state.md, the constitution, and the active feature directory,
  then prints one of:

    SAD next step: /sad-<command>                   (a non-human phase is next)
    SAD next step: GATE walkthrough <slug>          (paused on tier approvals)
    SAD next step: GATE reconcile <slug>            (paused on semi-technical verdict approval)
    SAD next step: /sad-setup                       (no .sad/ yet)
    SAD next step: /sad-constitution                (constitution missing/unfilled)
    SAD next step: /sad-brainstorm                  (no active feature)

  Exit codes:
    0  conductor can advance autonomously to the printed command
    2  a human gate (tier approval or reconciliation sign-off) blocks progression
    3  setup or constitution is missing (printed command is project-level, not feature-level)

.PARAMETER Json
  Emit a single-line JSON object instead of the human-readable line.

.PARAMETER Quiet
  Exit code only, no stdout.

.EXAMPLE
  .\next-step.ps1
  .\next-step.ps1 -Json
#>
[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Resolve-Path (Join-Path $scriptDir '..\..')
$state     = Join-Path $root '.sad\state\sad-state.md'
$const     = Join-Path $root '.sad\memory\constitution.md'
$specs     = Join-Path $root 'specs'

function Emit {
    param(
        [string]$Kind,
        [string]$Cmd,
        [string]$Slug,
        [string]$Reason,
        [int]$ExitCode
    )
    if ($Quiet) { exit $ExitCode }
    if ($Json) {
        $obj = [ordered]@{ kind=$Kind; next=$Cmd; slug=$Slug; reason=$Reason; exit=$ExitCode }
        Write-Output (($obj | ConvertTo-Json -Compress))
    } else {
        switch ($Kind) {
            'gate'  { Write-Output "SAD next step: GATE $Cmd $Slug  -- $Reason" }
            'done'  { Write-Output "SAD next step: feature complete -- set Phase: none in .sad/state/sad-state.md for the next feature." }
            default { Write-Output "SAD next step: $Cmd  -- $Reason" }
        }
    }
    exit $ExitCode
}

# 1. Project-level checks
if (-not (Test-Path (Join-Path $root '.sad'))) {
    Emit -Kind 'setup' -Cmd '/sad-setup' -Slug '' -Reason '.sad/ not present in this project' -ExitCode 3
}
$constMissing = -not (Test-Path $const)
$constUnfilled = $false
$constHasArticles = $true
if (-not $constMissing) {
    $constBody = Get-Content $const -Raw -ErrorAction SilentlyContinue
    if ($constBody -match '\[name\]|\[who\]|\[List people') { $constUnfilled = $true }
    if ($constBody -notmatch '(?m)^##? ') { $constHasArticles = $false }
}
if ($constMissing -or $constUnfilled -or -not $constHasArticles) {
    Emit -Kind 'setup' -Cmd '/sad-constitution' -Slug '' -Reason 'constitution missing or has unfilled placeholders' -ExitCode 3
}

# 2. Parse state file
$slug    = ''
$phase   = 'none'
$lastCmd = ''
if (Test-Path $state) {
    $lines = Get-Content $state -ErrorAction SilentlyContinue
    foreach ($line in $lines) {
        if     ($line -match '^- \*\*Slug:\*\*\s*(.*)$')         { $raw = $Matches[1].Trim() }
        elseif ($line -match '^- \*\*Phase:\*\*\s*(.*)$')        { $rawPhase = $Matches[1].Trim() }
        elseif ($line -match '^- \*\*Last command:\*\*\s*(.*)$') { $rawLast  = $Matches[1].Trim() }
    }
    if ($raw      -and $raw      -notmatch '^\[.*\]')       { $slug    = ($raw -split '\s+')[0] }
    if ($rawPhase -and $rawPhase -notmatch '^\[.*\]')       { $phase   = ($rawPhase -split '\s+')[0].ToLowerInvariant() }
    if ($rawLast  -and $rawLast  -notmatch '^\[.*\]')       { $lastCmd = ($rawLast -split '\s+')[0] }
}

# 3. Phase -> next-command lookup, plus gate detection
switch ($phase) {
    { $_ -in @('none','') } {
        $hasFeatures = (Test-Path $specs) -and ((Get-ChildItem -Path $specs -Directory -ErrorAction SilentlyContinue).Count -gt 0)
        $reason = if ($hasFeatures) { 'no active feature recorded -- pick one from specs/ or start a new one' } else { 'no active feature -- start by brainstorming requirements' }
        Emit -Kind 'run' -Cmd '/sad-brainstorm' -Slug '' -Reason $reason -ExitCode 0
    }
    'setup-needed'        { Emit -Kind 'setup' -Cmd '/sad-setup'             -Slug $slug -Reason 'setup not yet run' -ExitCode 3 }
    'constitution-needed' { Emit -Kind 'setup' -Cmd '/sad-constitution'      -Slug $slug -Reason 'constitution not yet filled' -ExitCode 3 }
    'brainstorm'          { Emit -Kind 'run'   -Cmd '/sad-specify'           -Slug $slug -Reason 'brainstorm complete' -ExitCode 0 }
    'specify'             { Emit -Kind 'run'   -Cmd '/sad-clarify'           -Slug $slug -Reason 'spec drafted' -ExitCode 0 }
    'clarify'             { Emit -Kind 'run'   -Cmd '/sad-impact-forecast'   -Slug $slug -Reason 'spec stable' -ExitCode 0 }
    'impact-forecast'     { Emit -Kind 'run'   -Cmd '/sad-plan'              -Slug $slug -Reason 'impact forecast written' -ExitCode 0 }
    'plan'                { Emit -Kind 'run'   -Cmd '/sad-walkthrough'       -Slug $slug -Reason 'plan written' -ExitCode 0 }
    'walkthrough' {
        $featDir = Join-Path $specs $slug
        $approverScript = Join-Path $root '.sad\scripts\check-tier-approvals.ps1'
        if ($slug -and (Test-Path (Join-Path $featDir 'walkthroughs')) -and (Test-Path $approverScript)) {
            try {
                & powershell -NoProfile -ExecutionPolicy Bypass -File $approverScript $featDir 2>$null | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Emit -Kind 'run' -Cmd '/sad-analyze' -Slug $slug -Reason 'all three tiers approved' -ExitCode 0
                }
            } catch { }
        }
        Emit -Kind 'gate' -Cmd 'walkthrough' -Slug $slug -Reason "awaiting tier approvals -- see specs/$slug/walkthroughs/" -ExitCode 2
    }
    'walkthrough-approved' { Emit -Kind 'run' -Cmd '/sad-analyze'   -Slug $slug -Reason 'walkthroughs approved' -ExitCode 0 }
    'analyze'              { Emit -Kind 'run' -Cmd '/sad-tasks'     -Slug $slug -Reason 'analysis complete' -ExitCode 0 }
    'tasks'                { Emit -Kind 'run' -Cmd '/sad-implement' -Slug $slug -Reason 'task list written' -ExitCode 0 }
    'implement'            { Emit -Kind 'run' -Cmd '/sad-review'    -Slug $slug -Reason 'implementation complete' -ExitCode 0 }
    'review'               { Emit -Kind 'run' -Cmd '/sad-reconcile' -Slug $slug -Reason 'reviewer fleet finished' -ExitCode 0 }
    'reconcile'            { Emit -Kind 'gate' -Cmd 'reconcile'     -Slug $slug -Reason 'awaiting semi-technical sign-off on reconciliation verdicts' -ExitCode 2 }
    'reconcile-approved'   { Emit -Kind 'run' -Cmd '/sad-compound'  -Slug $slug -Reason 'reconciliation approved' -ExitCode 0 }
    'compound'             { Emit -Kind 'done' -Cmd ''              -Slug $slug -Reason 'feature complete' -ExitCode 0 }
    default                { Emit -Kind 'run'  -Cmd '/sad-doctor'   -Slug $slug -Reason "unrecognized phase '$phase' -- run doctor to diagnose" -ExitCode 0 }
}
