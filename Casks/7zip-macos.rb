cask "7zip-macos" do
  # "<port>,<upstream>": the tag is v<port>, the disk image is named after both.
  # Rewritten on every release by yrambler2001/7zip-macos's release workflow (Mac/scripts/update-cask.sh).
  version "1.1.0,26.04"
  sha256 "f1314e412f3cded47c5497551712e52dcde9f15d21776867c588d980f10417de"

  url "https://github.com/yrambler2001/7zip-macos/releases/download/v#{version.csv.first}/7-Zip-#{version.csv.second}-macOS-#{version.csv.first}.dmg"
  name "7-Zip for macOS"
  desc "Native port of the 7-Zip File Manager"
  homepage "https://github.com/yrambler2001/7zip-macos"

  livecheck do
    url :url
    regex(/^7-Zip[._-]v?(\d+(?:\.\d+)+)[._-]macOS[._-]v?(\d+(?:\.\d+)+)\.dmg$/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  depends_on macos: :sonoma

  app "7-Zip.app"

  uninstall quit: "com.yrambler2001.7zip"

  zap trash: [
    "~/Library/Application Scripts/com.yrambler2001.7zip.*",
    "~/Library/Caches/com.yrambler2001.7zip",
    "~/Library/Containers/com.yrambler2001.7zip.*",
    "~/Library/HTTPStorages/com.yrambler2001.7zip",
    "~/Library/Preferences/com.yrambler2001.7zip.plist",
    "~/Library/Saved Application State/com.yrambler2001.7zip.savedState",
  ]

  caveats <<~EOS
    7-Zip for macOS is ad-hoc signed, not notarized: macOS blocks its first launch after
    every install and every upgrade. Open 7-Zip once and dismiss the warning, then click
    "Open Anyway" in System Settings > Privacy & Security and confirm. Details:
      https://github.com/yrambler2001/7zip-macos#first-launch-gatekeeper

    Homebrew 7 loads casks from a third-party tap only once it is trusted. Installing by
    full name works as it is; for a plain `brew upgrade` to include 7-Zip, trust the tap once:
      brew trust yrambler2001/tap

    To add 7-Zip to Finder's right-click menu, tick
      Options > 7-Zip > Integrate 7-Zip to shell context menu
    or switch on the 7-Zip extensions in
      System Settings > General > Login Items & Extensions
  EOS
end
