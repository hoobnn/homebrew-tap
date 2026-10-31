cask "livetranslate-bridge" do
  version "1.2.1"
  sha256 "f9bce76de28ad7b81303bbc0e9663b539849c5f717a3d4e554c6802416e7db24"

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
