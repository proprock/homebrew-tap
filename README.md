# proprock Homebrew tap

```bash
brew tap proprock/tap
brew install --cask aherald
```

## aHerald

`aherald` installs the Apple Silicon disk image of [aHerald](https://github.com/proprock/aHerald)
from its GitHub release (version and SHA-256 are taken from the release).

- **Not notarized.** The app is ad-hoc signed only, so Gatekeeper blocks its first start:
  right-click `aHerald.app` in Applications and choose Open. This tap does not remove the
  quarantine mark.
- **Setup.** Opening the app shows the setup window: choose Codex and/or Claude Code and press
  Apply. Nothing is configured by Homebrew itself.
- **Update.** `brew upgrade --cask aherald` replaces the app. A running resident is not
  stopped by the upgrade; quit it from its menu-bar icon and open the app again.
- **Uninstall.** `brew uninstall --cask aherald` first runs `aherald --unsetup --apply` as your
  user, which removes only aHerald's own hook entries (a backup is kept), then deletes the app.
  If that step fails, the uninstall stops and Homebrew prints the error. Repair: fix the
  reported file (for example malformed `~/.claude/settings.json`) and uninstall again, or run
  `/Applications/aHerald.app/Contents/MacOS/aherald --unsetup --apply` yourself.
- `brew uninstall --zap --cask aherald` also deletes `~/Library/Application Support/aHerald`
  (configuration, logs, setup receipt).

## Updating a cask

`./update-cask.sh aherald TAG` rewrites `version` and `sha256` from the release's `.dmg.sha256`.
The aHerald release workflow runs it and opens a pull request here for each stable release.
