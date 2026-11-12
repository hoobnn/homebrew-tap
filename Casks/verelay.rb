cask "verelay" do
  version "1.2.1"
  sha256 "f9bce76de28ad7b81303bbc0e9663b539849c5f717a3d4e554c6802416e7db24"

  # The current release still has the original archive and app name.
  # CI updates version/sha256 on the first Verelay release.
  artifact_name = version.to_s == "1.2.1" ? "LiveTranslateBridge" : "Verelay"

  url "https://github.com/hoobnn/verelay/releases/download/v#{version}/#{artifact_name}-#{version}-macOS.dmg"
  name "Verelay"
  desc "Live transcription and translation for app audio and microphone"
  homepage "https://github.com/hoobnn/verelay"

  livecheck do
    # The current release still has the original archive and app name.
  # CI updates version/sha256 on the first Verelay release.
  artifact_name = version.to_s == "1.2.1" ? "LiveTranslateBridge" : "Verelay"

  url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :golden_gate

  app "#{artifact_name}.app"

  uninstall quit: "com.ikuyu.livetranslate-bridge"

  zap trash: [
    "~/Library/Caches/com.ikuyu.livetranslate-bridge",
    "~/Library/HTTPStorages/com.ikuyu.livetranslate-bridge",
    "~/Library/Preferences/com.ikuyu.livetranslate-bridge.plist",
  ]
end
