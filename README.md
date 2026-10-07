# yrambler2001/tap

A personal [Homebrew](https://brew.sh) tap. It holds one cask:

| Cask | App |
|---|---|
| `7zip-macos` | [7-Zip for macOS](https://github.com/yrambler2001/7zip-macos), an unofficial native port of the 7-Zip File Manager |

## Install

```sh
brew install --cask yrambler2001/tap/7zip-macos
```

Homebrew 7 and later loads casks from a third-party tap only when it is trusted. A command that
names the cask in full (`yrambler2001/tap/7zip-macos`) works as it is; for `brew upgrade` (all
casks) to include this one, trust the tap once:

```sh
brew trust yrambler2001/tap
```

Update with `brew upgrade --cask 7zip-macos`; remove with `brew uninstall --cask 7zip-macos` (add
`--zap` to delete its settings and caches too).

Requires macOS 14 (Sonoma) or newer; the app is universal (Apple silicon and Intel).

## Gatekeeper: the cask removes the quarantine flag

The app is **ad-hoc signed, not notarized** (the project has no paid Apple Developer ID). Homebrew
downloads it with the quarantine attribute, like a browser does, and macOS would then block the
first launch of every new version until you click **Open Anyway** in System Settings.

So this cask **removes the quarantine flag itself**: after every install and every upgrade its
`postflight_steps` run

```sh
xattr -dr com.apple.quarantine /Applications/7-Zip.app
```

and 7-Zip opens directly. Installing the cask is the consent to that. If you would rather keep
Gatekeeper's check, install from the disk image on the
[Releases page](https://github.com/yrambler2001/7zip-macos/releases) instead and use *Open Anyway*;
the project's README explains it: <https://github.com/yrambler2001/7zip-macos#first-launch-gatekeeper>.

## Finder integration

macOS does not switch app extensions on by itself. After the first launch tick
**Options ▸ 7-Zip ▸ Integrate 7-Zip to shell context menu**, or switch the 7-Zip extensions on in
**System Settings ▸ General ▸ Login Items & Extensions**.

## How the cask is updated

The release workflow of [yrambler2001/7zip-macos](https://github.com/yrambler2001/7zip-macos)
rewrites `version` and `sha256` in `Casks/7zip-macos.rb` when a release is published, and nothing
else, so the quarantine step stays as it is (its `docs/releasing.md` describes the token it uses). The cask's version is `<port>,<upstream>`, for
example `1.0.0,26.03` — the port's own version and the 7-Zip engine version, both of which appear
in the disk image's name `7-Zip-26.03-macOS-1.0.0.dmg`. `brew livecheck --cask 7zip-macos` reads
the latest GitHub release.

Problems with the app go to [its issue tracker](https://github.com/yrambler2001/7zip-macos/issues),
not to Homebrew or to 7-Zip.

## License

The cask files are under the [BSD 2-Clause License](LICENSE), the license of Homebrew and of
`homebrew/cask` itself, so a cask here can move to or from the official repositories unchanged.
The app the cask installs has its own license (GNU LGPL 2.1 or later with the unRAR restriction,
see its repository).
