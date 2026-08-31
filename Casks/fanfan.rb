cask "fanfan" do
  version "1.2.0"
  sha256 "21b628b85c4ce26d688888ff555f43fccba995b7fe193d4377ef87ccd1779a6f"

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
    socket_path       = "/var/run/fanfan-smcd.sock"
    app_executable    = "#{appdir}/fanfan.app/Contents/MacOS/fanfan"

    # Stop the previous in-memory build before replacing its daemon. Otherwise
    # launch-at-login can keep an older client alive throughout the upgrade.
    system_command "/usr/bin/pkill",
                   args:         ["-f", app_executable],
                   must_succeed: false,
                   print_stderr: false
    app_stopped = begin
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 10
      loop do
        running = system_command "/usr/bin/pgrep",
                                 args:         ["-f", app_executable],
                                 must_succeed: false,
                                 print_stderr: false
        break true unless running&.success?
        break false if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

        sleep 0.25
      end
    end
    raise "previous fanfan process did not exit" unless app_stopped

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
    system_command "/usr/bin/cmp", args: [daemon_src, daemon_dst]
    system_command "/usr/bin/cmp", args: [plist_src, plist_dst]
    system_command "/bin/launchctl",
                   args: ["bootstrap", "system", plist_dst],
                   sudo: true

    # RunAtLoad + KeepAlive makes bootstrap start the daemon. A following
    # `kickstart -k` would kill that fresh process and trigger launchd's
    # minimum-runtime throttle, so wait for the versioned socket instead.
    helper_ready = begin
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 20
      loop do
        ping = system_command "/usr/bin/nc",
                              args:         ["-w", "1", "-U", socket_path],
                              input:        "PINGV2\n",
                              must_succeed: false,
                              print_stderr: false
        break true if ping&.stdout&.match?(/\AOK pong 2 (idle|active|restoring)\r?\n?\z/)
        break false if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

        sleep 0.25
      end
    end
    raise "fanfan privileged helper did not become ready" unless helper_ready

    # Homebrew's `quit` directive is unreliable for an accessory (no Dock icon)
    # menu-bar app on the upgrade path. Once the daemon is confirmed live,
    # relaunch the fresh binary in the background (-g, no focus steal) by full
    # path — Launch Services may not have registered the copied bundle yet.
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
