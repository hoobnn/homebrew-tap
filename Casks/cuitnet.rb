cask "cuitnet" do
  version "0.1.0"
  sha256 "a6bee2a7f0fb9aca2069f626afaac96cf2c4937e27bf8308cf0dac90832aff44"

  url "https://github.com/hoobnn/cuit-campus-login/releases/download/v#{version}/CUITNet-#{version}-macOS.dmg"
  name "CUITNet"
  name "CUIT 校园网"
  desc "Automatic login for the CUIT campus network"
  homepage "https://github.com/hoobnn/cuit-campus-login"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "CUITNet.app"

  uninstall quit: "com.ikuyu.cuitnet"

  zap trash: [
    "~/Library/Caches/com.ikuyu.cuitnet",
    "~/Library/HTTPStorages/com.ikuyu.cuitnet",
    "~/Library/Logs/CUITNet",
    "~/Library/Preferences/com.ikuyu.cuitnet.plist",
  ]
end
