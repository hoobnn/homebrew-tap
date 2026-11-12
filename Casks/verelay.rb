cask "verelay" do
  version "1.3.0"
  sha256 "0add5b65e9533f59b2b24ef9144944d77b5c56bf3f339957566080c2005a8ca4"

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
