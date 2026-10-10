cask "livetranslate-bridge" do
  version "1.1.1"
  sha256 "23d2c8c7ca81394c99a3900a0c86d24ee533afca4fd9ef47c3501d65d82b56ba"

  url "https://github.com/hoobnn/livetranslate-bridge/releases/download/v#{version}/LiveTranslateBridge-#{version}-macOS.dmg"
  name "LiveTranslateBridge"
  desc "Live transcription and translation for app audio and microphone"
  homepage "https://github.com/hoobnn/livetranslate-bridge"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :golden_gate

  app "LiveTranslateBridge.app"

  uninstall quit: "com.ikuyu.livetranslate-bridge"

  zap trash: [
    "~/Library/Caches/com.ikuyu.livetranslate-bridge",
    "~/Library/HTTPStorages/com.ikuyu.livetranslate-bridge",
    "~/Library/Preferences/com.ikuyu.livetranslate-bridge.plist",
  ]
end
