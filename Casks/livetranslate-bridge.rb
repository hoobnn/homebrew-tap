cask "livetranslate-bridge" do
  version "1.0.0"
  sha256 "95e3298209721f6135575c1444ce7d6f5e416059b318b839975718098c1c9115"

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
