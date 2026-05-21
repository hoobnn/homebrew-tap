cask "fanfan" do
  version "1.0.8"
  sha256 "cbe85c2682f9b34113d455ab86af6189c087e6a65bb0305fdf4b044eedbe0922"

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
                   must_succeed: false,
                   print_stderr: false
    system_command "/bin/launchctl",
                   args: ["bootstrap", "system", plist_dst],
                   sudo: true
    system_command "/bin/launchctl",
                   args: ["kickstart", "-k", "system/com.hoobnn.fanfan.smcd"],
                   sudo: true

    # Homebrew's `quit` directive is unreliable for an accessory (no Dock icon)
    # menu-bar app on the upgrade path, so a pre-upgrade instance keeps running
    # the old binary from memory. After the new build is staged and the daemon
    # is live, terminate any lingering instance and relaunch the fresh binary in
    # the background (-g, no focus steal) by full path — Launch Services may not
    # have registered the just-copied bundle yet.
    system_command "/usr/bin/pkill",
                   args:         ["-f", "#{appdir}/fanfan.app/Contents/MacOS/fanfan"],
                   must_succeed: false
    sleep 1
    system_command "/usr/bin/open", args: ["-g", "#{appdir}/fanfan.app"]
  end

  uninstall quit:      "com.hoobnn.fanfan",
            launchctl: "com.hoobnn.fanfan.smcd",
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
