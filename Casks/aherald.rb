cask "aherald" do
  version "0.12.0"
  sha256 "71b5bf6a7572c79ff496b9a20a9ddfd1a44ccfe9f02033e280886d50b578dfcf"

  url "https://github.com/proprock/aHerald/releases/download/v#{version}/aherald-v#{version}-macos-arm64.dmg"
  name "aHerald"
  desc "Notification companion for Codex and Claude Code"
  homepage "https://github.com/proprock/aHerald"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "aHerald.app"

  # Homebrew runs as the user who owns the agent hooks, so aHerald's own entries are removed
  # here, before the program is deleted. The resident is stopped first through its own control
  # command: it has no windows or menus, so Homebrew's AppleScript `quit` cannot reach it.
  # A failure stops the uninstall and shows its message; see the README for the repair path.
  uninstall script: {
    executable:   "/bin/sh",
    args:         [
      "-c",
      "app=\"$1/aHerald.app/Contents/MacOS/aherald\"; \"$app\" --quit; \"$app\" --unsetup --apply",
      "sh",
      appdir.to_s,
    ],
    must_succeed: true,
  }

  # Configuration, logs and the setup receipt; hooks are handled by the preflight above.
  zap trash: "~/Library/Application Support/aHerald"

  caveats <<~EOS
    aHerald is ad-hoc signed only, not notarized. The first start of the downloaded app is
    blocked by Gatekeeper. Try to open aHerald.app once, then choose Open Anyway in System Settings,
    Privacy & Security (macOS 15 and later; a right-click, Open no longer works).
    Or remove the quarantine mark directly:
      xattr -dr com.apple.quarantine /Applications/aHerald.app
    Then pick Codex and/or Claude Code in the setup window and press Apply.
  EOS
end
