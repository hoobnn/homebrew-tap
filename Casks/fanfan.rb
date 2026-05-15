cask "fanfan" do
  version "1.0.4"
  sha256 "75fa0f2e0474dca3c2997bfc64f6dcf65c26db9b87f93b8384f668c630901e03"

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
