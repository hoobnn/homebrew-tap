cask "verelay" do
  version "1.3.0"
  sha256 "0add5b65e9533f59b2b24ef9144944d77b5c56bf3f339957566080c2005a8ca4"

  url "https://github.com/hoobnn/verelay/releases/download/v#{version}/Verelay-#{version}-macOS.dmg"
  name "Verelay"
  desc "Live transcription and translation for app audio and microphone"
  homepage "https://github.com/hoobnn/verelay"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :golden_gate

  app "Verelay.app"

  uninstall quit: "com.ikuyu.livetranslate-bridge"

  zap trash: [
    "~/Library/Caches/com.ikuyu.livetranslate-bridge",
    "~/Library/HTTPStorages/com.ikuyu.livetranslate-bridge",
    "~/Library/Preferences/com.ikuyu.livetranslate-bridge.plist",
  ]
end
