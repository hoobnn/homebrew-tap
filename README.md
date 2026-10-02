# hoobnn/homebrew-tap

**简体中文** · [English](#english)

我自己写的几个 macOS 应用的 Homebrew tap。安装包都来自各项目的 GitHub Releases，已签名并经过 Apple 公证。

## 安装

```sh
brew tap hoobnn/tap
brew install --cask fanfan
```

也可以不先 tap，直接写全名：`brew install --cask hoobnn/tap/fanfan`。

| Cask | 说明 | 系统要求 |
| --- | --- | --- |
| [`fanfan`](https://github.com/hoobnn/fanfan) | 菜单栏风扇控制与温度监控 | macOS 26+，Apple Silicon / Intel |
| [`livetranslate-bridge`](https://github.com/hoobnn/livetranslate-bridge) | 通话、会议和 App 声音的实时翻译与双语字幕 | macOS 27+，Apple Silicon |
| [`keyboard-logo-fix`](https://github.com/hoobnn/macos-keyboard-logo-fix) | 恢复 SCC100、FMate98 键盘自己设置的 LOGO 灯效 | macOS 12+ |

升级和卸载：

```sh
brew upgrade --cask fanfan
brew uninstall --cask fanfan          # 加 --zap 会顺带删掉偏好设置
```

## 版本更新

各项目打 `v*` 标签发布后，CI 会通过 [ci-workflows](https://github.com/hoobnn/ci-workflows) 自动改写这里对应 cask 的 `version` 和 `sha256`，一般不需要手动改。安装时提示 sha256 不匹配，多半是发布流程中途失败了，欢迎到对应项目提 issue。

## English

A Homebrew tap for my macOS apps. Every download comes from the project's GitHub Releases, signed and notarized by Apple.

```sh
brew tap hoobnn/tap
brew install --cask fanfan                 # Mac fan control & temperature monitor
brew install --cask livetranslate-bridge   # live translation & subtitles for calls and app audio
brew install --cask keyboard-logo-fix      # restore logo lighting on SCC100 / FMate98 keyboards
```

Casks are bumped automatically by each project's release workflow.
