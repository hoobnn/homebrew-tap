cask "fanfan" do
  version "1.2.0"
  sha256 "b2bbe96d8a52e5ddf17cf866c55ec6ba89495c871ee702727f333040798ed772"

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
    daemon_dst        = "/Library/PrivilegedHelperTools/fanfan-smcd"
    legacy_daemon_dst = "/usr/local/libexec/fanfan-smcd"
    plist_dst         = "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist"

    system_command "/bin/mkdir",
                   args: ["-p", "/Library/PrivilegedHelperTools", "/Library/LaunchDaemons"],
                   sudo: true
    system_command "/bin/launchctl",
                   args:         ["bootout", "system", plist_dst],
                   sudo:         true,
                   must_succeed: false,
                   print_stderr: false
    system_command "/bin/rm",
                   args: ["-f", daemon_dst, legacy_daemon_dst],
                   sudo: true
    system_command "/usr/bin/install",
                   args: ["-o", "root", "-g", "wheel", "-m", "755", daemon_src, daemon_dst],
                   sudo: true
    system_command "/usr/bin/install",
                   args: ["-o", "root", "-g", "wheel", "-m", "644", plist_src, plist_dst],
                   sudo: true
    system_command "/usr/bin/xattr",
                   args:         ["-d", "com.apple.quarantine", daemon_dst],
                   sudo:         true,
                   must_succeed: false,
                   print_stderr: false
    system_command "/usr/bin/xattr",
                   args:         ["-d", "com.apple.quarantine", plist_dst],
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

  uninstall launchctl: "com.hoobnn.fanfan.smcd",
            quit:      "com.hoobnn.fanfan",
            delete:    [
              "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist",
              "/Library/PrivilegedHelperTools/fanfan-smcd",
              "/usr/local/libexec/fanfan-smcd",
            ]

  zap trash: [
    "~/Library/Application Support/fanfan",
    "~/Library/Caches/com.hoobnn.fanfan",
    "~/Library/HTTPStorages/com.hoobnn.fanfan",
    "~/Library/Preferences/com.hoobnn.fanfan.plist",
  ]
end
