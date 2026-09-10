cask "fanfan" do
  version "1.3.1"
  sha256 "b87e88ca173f140d6cd3c6d162971166d26a89010c6ad5a3cbcc1127fe018452"

  url "https://github.com/hoobnn/fanfan/releases/download/v#{version}/fanfan-#{version}-macOS.dmg"
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
  postflight_steps do
    # Stop the previous in-memory build before replacing its daemon. Otherwise
    # launch-at-login can keep an older client alive throughout the upgrade.
    terminate_process "{{appdir}}/fanfan.app/Contents/MacOS/fanfan",
                      match:    :full,
                      attempts: 5

    run "/bin/mkdir",
        args: ["-p", "/Library/PrivilegedHelperTools", "/Library/LaunchDaemons"],
        sudo: true

    run "/bin/launchctl",
        args:         ["bootout", "system", "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist"],
        sudo:         true,
        must_succeed: false,
        print_stderr: false
    remove ["/Library/PrivilegedHelperTools/fanfan-smcd", "/usr/local/libexec/fanfan-smcd"], sudo: true

    # `copy` 用 FileUtils.cp 且无 sudo 选项，写不进 root 拥有的目录；
    # `set_permissions` 的 chmod 也固定 sudo: false。改用 install(1)
    # 一步完成复制 + owner + mode。
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "755",
               "{{appdir}}/fanfan.app/Contents/Resources/fanfan-smcd",
               "/Library/PrivilegedHelperTools/fanfan-smcd"],
        sudo: true
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "644",
               "{{appdir}}/fanfan.app/Contents/Resources/com.hoobnn.fanfan.smcd.plist",
               "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist"],
        sudo: true

    run "/usr/bin/xattr",
        args:         ["-d", "com.apple.quarantine", "/Library/PrivilegedHelperTools/fanfan-smcd"],
        sudo:         true,
        must_succeed: false,
        print_stderr: false
    run "/usr/bin/xattr",
        args:         ["-d", "com.apple.quarantine", "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist"],
        sudo:         true,
        must_succeed: false,
        print_stderr: false

    # RunAtLoad + KeepAlive makes bootstrap start the daemon, so no kickstart
    # is needed: that would kill the fresh process and trip launchd's
    # minimum-runtime throttle.
    run "/bin/launchctl",
        args: ["bootstrap", "system", "/Library/LaunchDaemons/com.hoobnn.fanfan.smcd.plist"],
        sudo: true

    # Homebrew's `quit` directive is unreliable for an accessory (no Dock icon)
    # menu-bar app on the upgrade path, so relaunch the fresh binary in the
    # background (-g, no focus steal) by full path — Launch Services may not
    # have registered the copied bundle yet.
    run "/usr/bin/open", args: ["-g", "{{appdir}}/fanfan.app"]
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
