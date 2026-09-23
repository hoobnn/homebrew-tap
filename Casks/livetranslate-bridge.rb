cask "livetranslate-bridge" do
  version "1.0.0"
  sha256 "22c02c0614f9d7d174fe1c8a905825c768b7f67cfa13b115500f0aadb9acb0a3"

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
