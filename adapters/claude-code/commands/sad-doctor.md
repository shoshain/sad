# /sad-doctor

This is the Claude Code slash-command pointer. The canonical prompt lives at `commands/sad-doctor.md` in the SAD repo (this project's root).

When invoked, run the doctor script appropriate for the platform:

- POSIX: `bash .sad/scripts/doctor.sh`
- Windows: `pwsh -File .sad/scripts/doctor.ps1`

Surface the green/yellow/red report to the user. Do not edit any files in response to findings — `/sad-doctor` is read-only.

(The installer generates equivalent pointer files for every `commands/sad-*.md`; this is the documented example.)
