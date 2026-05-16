cask "fanfan" do
  version "1.0.6"
  sha256 "b8615728048f29d0fed4a49b09f8aa6c39411f4056adb3ff32508ca6ae8a7f16"

  url "https://github.com/hoobnn/fanfan/releases/download/v#{version}/fanfan-v#{version}-macos.dmg"
  name "fanfan"
  desc "Menu bar fan-speed controller"
  homepage "https://github.com/hoobnn/fanfan"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  app "fanfan.app"

  # Install the privileged SMC daemon during the cask run so the app's own
  # first-launch installer is skipped. Homebrew caches sudo within a single
  # cask run, so this and the uninstall step share one password prompt.
  postflight do
    daemon_src = "#{appdir}/fanfan.app/Contents/Resources/fanfan-smcd"
    plist_src  = "#{appdir}/fanfan.app/Contents/Resources/com.hoobnn.fanfan.smcd.plist"
    daemon_dst = "/usr/local/libexec/fanfan-smcd"
    plist_dst  = "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist"

    system_command "/bin/mkdir",
                   args: ["-p", "/usr/local/libexec", "/Library/LaunchDaemons"],
                   sudo: true
    system_command "/bin/cp",         args: ["-f", daemon_src, daemon_dst], sudo: true
    system_command "/usr/sbin/chown", args: ["root:wheel", daemon_dst],     sudo: true
    system_command "/bin/chmod",      args: ["755", daemon_dst],            sudo: true
    system_command "/bin/cp",         args: ["-f", plist_src, plist_dst],   sudo: true
    system_command "/usr/sbin/chown", args: ["root:wheel", plist_dst],      sudo: true
    system_command "/bin/chmod",      args: ["644", plist_dst],             sudo: true
    system_command "/bin/launchctl",
                   args:         ["bootout", "system", plist_dst],
                   sudo:         true,
                   must_succeed: false
    system_command "/bin/launchctl",
                   args: ["bootstrap", "system", plist_dst],
                   sudo: true
    system_command "/bin/launchctl",
                   args: ["kickstart", "-k", "system/com.hoobnn.fanfan.smcd"],
                   sudo: true
  end

  uninstall launchctl: "com.hoobnn.fanfan.smcd",
            delete:    [
              "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist",
              "/usr/local/libexec/fanfan-smcd",
            ]

  zap trash: [
    "~/Library/Application Support/fanfan",
    "~/Library/Caches/com.hoobnn.fanfan",
    "~/Library/HTTPStorages/com.hoobnn.fanfan",
    "~/Library/Preferences/com.hoobnn.fanfan.plist",
  ]
end
