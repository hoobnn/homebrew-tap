cask "fanfan" do
  version "1.0.5"
  sha256 "4f203b411ad8a204042e93e1ec60d61f777d64b3d4ad3f2d2a051e345b706c4c"

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
