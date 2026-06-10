# _sad-doctor-extended.ps1 — theater + substrate checks (dot-sourced by doctor.ps1).

function Invoke-SadDoctorExtended {
    param(
        [string]$Root,
        [System.Collections.Generic.List[object]]$Results
    )

    . (Join-Path $PSScriptRoot '_sad-approval-lib.ps1')

    function Add-ExtCheck {
        param([string]$Name, [string]$Status, [string]$Message, [string]$Hint = '')
        $Results.Add([pscustomobject]@{ name=$Name; status=$Status; message=$Message; hint=$Hint })
    }

    $pendingDays = 14
    $constitution = Join-Path $Root '.sad\memory\constitution.md'
    if (Test-Path $constitution) {
        $cb = Get-Content $constitution -Raw
        if ($cb -match '(?i)pending approval.*?(\d+)\s*days|PENDING_APPROVAL_DAYS.*?(\d+)') {
            $pendingDays = [int]($Matches[1], $Matches[2] | Where-Object { $_ } | Select-Object -First 1)
        }
    }

    $specs = Join-Path $Root 'specs'
    if (Test-Path $specs) {
        foreach ($f in Get-ChildItem $specs -Directory) {
            foreach ($tier in @('non-technical','semi-technical','technical')) {
                $label = Get-SadTierLabel $tier
                $file  = Get-SadTierFile $f.FullName $tier
                $st    = Get-SadApprovalStatus $file $label
                if ($st -ne 'pending') { continue }
                $since = Get-SadApprovalField $file '(?i)pending since:'
                if ($since -and ([datetime]::TryParse($since, [ref]$null))) {
                    $days = ((Get-Date) - [datetime]$since).Days
                    if ($days -gt $pendingDays) {
                        Add-ExtCheck "gates.$($f.Name).${tier}.stale_pending" 'yellow' `
                            "$($f.Name): $tier pending ${days}d (threshold ${pendingDays}d)" `
                            'Send review packet via /sad-stakeholder-report or escalate delegate'
                    }
                }
            }
            $nt = Get-SadTierFile $f.FullName 'non-technical'
            $st = Get-SadTierFile $f.FullName 'semi-technical'
            $t  = Get-SadTierFile $f.FullName 'technical'
            $ov = Get-SadWalkthroughOverlapPct $nt $st
            if ($ov -ge 70) {
                Add-ExtCheck "theater.$($f.Name).collapse_nt_st" 'yellow' `
                    "$($f.Name): non-technical vs semi-technical walkthrough ${ov}% overlap" `
                    'Differentiate tiers; see SAD_USER_GUIDE §16 single-tier collapse'
            }
            $ov = Get-SadWalkthroughOverlapPct $st $t
            if ($ov -ge 70) {
                Add-ExtCheck "theater.$($f.Name).collapse_st_t" 'yellow' `
                    "$($f.Name): semi-technical vs technical walkthrough ${ov}% overlap" `
                    'Technical walkthrough should include PR/eval detail ST tier omits'
            }
        }
    }

    $featCount = 0
    if (Test-Path $specs) { $featCount = (Get-ChildItem $specs -Directory).Count }
    if ($featCount -gt 0) {
        foreach ($tier in @('non-technical','semi-technical','technical')) {
            $sf = Join-Path $Root ".sad\stakeholders\$tier.md"
            if ((Test-Path $sf) -and ((Get-Content $sf -Raw) -match 'TBD|\[List people')) {
                Add-ExtCheck "theater.stakeholders.${tier}_tbd" 'yellow' `
                    "$featCount feature(s) exist but stakeholders/$tier.md still TBD" `
                    'Name real reviewers -- collapsing tiers is spec theater'
            }
        }
    }

    $claimed = ''
    if (Test-Path $constitution) {
        $m = Select-String -Path $constitution -Pattern 'Level [0-9]+' | Select-Object -First 1
        if ($m) { $claimed = $m.Matches.Value }
    }
    $lessonsDir = Join-Path $Root '.sad\memory\lessons'
    $lessonCount = 0
    if (Test-Path $lessonsDir) {
        $lessonCount = (Get-ChildItem $lessonsDir -Filter 'L-*.md' -ErrorAction SilentlyContinue).Count
    }
    if ($claimed -match 'Level [34]' -and $lessonCount -lt 3) {
        Add-ExtCheck 'substrate.lessons_shallow' 'yellow' `
            "Claimed $claimed but only $lessonCount lesson(s) in .sad/memory/lessons/" `
            'Compound after features; substrate suggests lower maturity'
    }

    $codeUp = 0
    $specUp = 0
    if (Test-Path $specs) {
        Get-ChildItem $specs -Recurse -Filter 'reconciliation.md' | ForEach-Object {
            $rb = Get-Content $_.FullName -Raw
            if ($rb -match 'code-update') { $codeUp++ }
            if ($rb -match 'spec-update') { $specUp++ }
        }
    }
    $total = $codeUp + $specUp
    if ($total -ge 5 -and $codeUp -gt ($specUp * 3)) {
        Add-ExtCheck 'substrate.reconcile_drift' 'yellow' `
            "Reconciliation skew: $codeUp code-update vs $specUp spec-update verdicts" `
            'Review spec quality or implementation discipline'
    }

    if ((Test-Path $constitution) -and ((Get-Content $constitution -Raw) -match '(?i)Level 0|Solo SAD')) {
        if ((Get-Content $constitution -Raw) -notmatch '(?i)last calibrated') {
            Add-ExtCheck 'substrate.standin_calibration' 'yellow' `
                'Level 0 / stand-in active but no calibration line in constitution' `
                "Add 'Tier X reviewer is AI-stand-in (last calibrated YYYY-MM-DD)' per MATURITY.md"
        }
    }
}
