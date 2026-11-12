# hoobnn/homebrew-tap

**简体中文** · [English](#english)

hoobnn/homebrew-tap 是 hoobnn 个人 macOS 应用的 Homebrew tap，用 `brew install --cask` 安装 FanFan（菜单栏风扇控制与温度监控）、Verelay（实时语音翻译与双语字幕）、Keyboard Logo Fix（键盘 LOGO 灯效恢复）和 CUITNet（成都信息工程大学校园网自动登录）。安装包都来自各项目的 GitHub Releases，已签名并经过 Apple 公证。

## 安装

```sh
brew tap hoobnn/tap
brew install --cask fanfan
```

也可以不先 tap，直接写全名：`brew install --cask hoobnn/tap/fanfan`。

| Cask | 说明 | 系统要求 | 项目 |
| --- | --- | --- | --- |
| `fanfan` | 菜单栏风扇控制与温度监控 | macOS 26+，Apple Silicon / Intel | [官网](https://hoobnn.github.io/fanfan/) · [GitHub](https://github.com/hoobnn/fanfan) |
| `verelay` | 通话、会议和 App 声音的实时翻译与双语字幕 | macOS 27+，Apple Silicon | [官网](https://hoobnn.github.io/verelay/) · [GitHub](https://github.com/hoobnn/verelay) |
| `keyboard-logo-fix` | 恢复 SCC100、FMate98 键盘自己设置的 LOGO 灯效 | macOS 12+ | [GitHub](https://github.com/hoobnn/macos-keyboard-logo-fix) |
| `cuitnet` | 成都信息工程大学校园网自动登录 | macOS 14+，Apple Silicon / Intel | [GitHub](https://github.com/hoobnn/cuit-campus-login) |

升级和卸载：

```sh
brew upgrade --cask fanfan
brew uninstall --cask fanfan          # 加 --zap 会顺带删掉偏好设置
```

## 常见问题

**这些应用在官方 homebrew-cask 里吗？**
不在，只能通过本 tap 安装。不想用 Homebrew 的话，也可以到各项目的 GitHub Releases 页面直接下载 `.dmg`。

**`brew tap hoobnn/tap` 为什么不是 `homebrew-tap`？**
Homebrew 会自动给仓库名补上 `homebrew-` 前缀，所以 `hoobnn/tap` 对应的就是 `hoobnn/homebrew-tap`。

**`brew upgrade` 没有升级 FanFan 或 CUITNet？**
这两个应用自带更新（`auto_updates`），Homebrew 默认不会替它们升级。想用 Homebrew 强制升级，运行 `brew upgrade --cask --greedy fanfan`。

**更新频率？版本是怎么更新的？**
各项目打 `v*` 标签发布后，CI 会通过 [ci-workflows](https://github.com/hoobnn/ci-workflows) 自动改写这里对应 cask 的 `version` 和 `sha256`，一般不需要手动改。

**安装时提示 sha256 不匹配？**
多半是发布流程中途失败了，欢迎到对应项目提 issue。先运行 `brew update` 排除本地 tap 缓存过期。

**Keyboard Logo Fix 装好后没反应？**
先打开一次应用安装后台服务，再到「系统设置 › 隐私与安全性 › 输入监控」里允许它。

**macOS 版本太低装不上？**
每个应用的最低系统版本见上表，来自 cask 的 `depends_on macos`。

## English

hoobnn/homebrew-tap is the Homebrew tap for hoobnn's personal macOS apps: FanFan (menu bar fan control and temperature monitor), Verelay (real-time speech translation and bilingual subtitles), Keyboard Logo Fix (restores logo lighting on SCC100 / FMate98 keyboards) and CUITNet (auto login for the CUIT campus network). Install with `brew install --cask`. Every download comes from the project's GitHub Releases, signed and notarized by Apple.

```sh
brew tap hoobnn/tap
brew install --cask fanfan                 # Mac fan control & temperature monitor
brew install --cask verelay   # live translation & subtitles for calls and app audio
brew install --cask keyboard-logo-fix      # restore logo lighting on SCC100 / FMate98 keyboards
brew install --cask cuitnet                # auto login for the CUIT campus network
```

Or without tapping first: `brew install --cask hoobnn/tap/fanfan`.

| Cask | Requires | Project |
| --- | --- | --- |
| `fanfan` | macOS 26+, Apple Silicon / Intel | [Website](https://hoobnn.github.io/fanfan/) · [GitHub](https://github.com/hoobnn/fanfan) |
| `verelay` | macOS 27+, Apple Silicon | [Website](https://hoobnn.github.io/verelay/) · [GitHub](https://github.com/hoobnn/verelay) |
| `keyboard-logo-fix` | macOS 12+ | [GitHub](https://github.com/hoobnn/macos-keyboard-logo-fix) |
| `cuitnet` | macOS 14+, Apple Silicon / Intel | [GitHub](https://github.com/hoobnn/cuit-campus-login) |

### FAQ

**Are these apps in the official homebrew-cask?**
No, only through this tap. If you'd rather not use Homebrew, download the `.dmg` from each project's GitHub Releases page.

**Why `hoobnn/tap` and not `hoobnn/homebrew-tap`?**
Homebrew adds the `homebrew-` prefix to the repository name automatically, so `hoobnn/tap` is `hoobnn/homebrew-tap`.

**`brew upgrade` skipped FanFan or CUITNet?**
Both update themselves (`auto_updates`), so Homebrew leaves them alone by default. To force it, run `brew upgrade --cask --greedy fanfan`.

**How are versions updated?**
When a project publishes a `v*` tag, CI rewrites the cask's `version` and `sha256` here through [ci-workflows](https://github.com/hoobnn/ci-workflows). No manual edits are normally needed.

**sha256 mismatch on install?**
The release workflow most likely failed halfway; please open an issue on the app's repository. Run `brew update` first to rule out a stale local tap.

**Keyboard Logo Fix does nothing after install?**
Open the app once to install its background service, then allow it under System Settings › Privacy & Security › Input Monitoring.
