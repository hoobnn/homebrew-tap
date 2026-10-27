cask "livetranslate-bridge" do
  version "1.2.0"
  sha256 "7afda792b57117ae3198b08053925e489f58700adb0c8bc3ea0b373429d934d5"

  url "https://github.com/hoobnn/livetranslate-bridge/releases/download/v#{version}/LiveTranslateBridge-#{version}-macOS.dmg"
  name "LiveTranslate Bridge"
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
