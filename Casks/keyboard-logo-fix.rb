cask "keyboard-logo-fix" do
  version "0.2.5"
  sha256 "0fdc8360c1ec8a8329b28622e508049570156bee95176ffacb32eb207189a821"

  url "https://github.com/hoobnn/macos-keyboard-logo-fix/releases/download/v#{version}/Keyboard-Logo-Fix-#{version}-macOS.dmg"
  name "Keyboard Logo Fix"
  desc "Restores the LOGO lighting effect saved on SCC100 and FMate98 keyboards"
  homepage "https://github.com/hoobnn/macos-keyboard-logo-fix"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Keyboard Logo Fix.app"

  uninstall launchctl: [
              "com.ikuyu.keyboard-logo-fix",
              "local.codex.t100-logo-white",
            ],
            quit:      "com.ikuyu.keyboard-logo-fix",
            delete:    [
              "~/Library/LaunchAgents/com.ikuyu.keyboard-logo-fix.plist",
              "~/Library/LaunchAgents/local.codex.t100-logo-white.plist",
            ]

  zap trash: [
    "~/Library/Application Support/KeyboardLogoFix",
    "~/Library/Application Support/T100Logo",
    "~/Library/Logs/KeyboardLogoFix.log",
  ]

  caveats <<~EOS
    Open Keyboard Logo Fix once to install its background service, then allow it
    in System Settings → Privacy & Security → Input Monitoring.
  EOS
end
