cask "aherald" do
  version "0.9.1"
  sha256 "2f835193689d9fcb37dc53be7acece45331b3ac6eef7e87a86a51f445c3619b0"

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
  # here, before the program is deleted. A failure stops the uninstall and shows its message;
  # see the README for the repair path.
  uninstall quit:   "io.github.proprock.aherald",
            script: {
              executable:   "#{appdir}/aHerald.app/Contents/MacOS/aherald",
              args:         ["--unsetup", "--apply"],
              must_succeed: true,
            }

  # Configuration, logs and the setup receipt; hooks are handled by the preflight above.
  zap trash: "~/Library/Application Support/aHerald"

  caveats <<~EOS
    aHerald is ad-hoc signed only, not notarized. The first start of the downloaded app is
    blocked by Gatekeeper: right-click aHerald.app in Applications and choose Open.
    Then pick Codex and/or Claude Code in the setup window and press Apply.
  EOS
end
