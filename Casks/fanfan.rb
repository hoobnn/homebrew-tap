cask "fanfan" do
  version "2.0.1"
  sha256 "ac3462c31cacecbf060af84a2db228c092a50007c65b57d9413e785a34566387"

  url "https://github.com/hoobnn/fanfan/releases/download/v#{version}/fanfan-#{version}-macOS.dmg"
  name "FanFan"
  desc "Menu bar fan-speed controller"
  homepage "https://github.com/hoobnn/fanfan"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  app "fanfan.app"

  # Since 1.4 the fan-control helper ships inside the app and the app registers
  # it through SMAppService (one approval in Login Items & Extensions, no
  # password). The helper also removes the pre-1.4 system LaunchDaemon, so the
  # cask needs no sudo steps.
  postflight_steps do
    # Stop the previous in-memory build; the helper restarts onto the new
    # binary by itself once the bundle is replaced.
    terminate_process "{{appdir}}/fanfan.app/Contents/MacOS/fanfan",
                      match:    :full,
                      attempts: 5

    # Relaunch the fresh binary in the background (-g, no focus steal) by full
    # path — Launch Services may not have registered the copied bundle yet.
    # Best effort only: Homebrew runs steps without sudo inside a sandbox that
    # can block app launches (LaunchServices -10810), and a failed relaunch
    # must not roll back the whole install.
    run "/usr/bin/open",
        args:         ["-g", "{{appdir}}/fanfan.app"],
        must_succeed: false,
        print_stderr: false
  end

  # No `launchctl:`/`delete:` here: `brew upgrade` runs this stanza too, and
  # both need sudo and would tear down the registered helper. Deleting the app
  # stops the helper, which runs from inside the bundle.
  # 2.0 renamed the bundle ID; keep the 1.x one so upgrades from it still quit it.
  uninstall quit: [
    "com.ikuyu.fanfan",
    "com.hoobnn.fanfan",
  ]

  zap trash: [
    "~/Library/Application Support/fanfan",
    "~/Library/Caches/com.hoobnn.fanfan",
    "~/Library/Caches/com.ikuyu.fanfan",
    "~/Library/HTTPStorages/com.hoobnn.fanfan",
    "~/Library/HTTPStorages/com.ikuyu.fanfan",
    "~/Library/Preferences/com.hoobnn.fanfan.plist",
    "~/Library/Preferences/com.ikuyu.fanfan.plist",
  ]

  # Process enumeration and Launch Services are unavailable in the install-step
  # sandbox. Upgrade removal already uses `uninstall quit:` above; launching the
  # GUI must be left to the user rather than making it an installation requirement.
  caveats <<~EOS
    After installation or upgrade, open fanfan from Applications.
  EOS
end
