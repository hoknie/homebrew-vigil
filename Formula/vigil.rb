class Vigil < Formula
  desc "Host protection agent that turns changes on a host into findings"
  homepage "https://github.com/hoknie/vigil"
  url "https://github.com/hoknie/vigil/releases/download/v1.2.0/vigil_1.2.0.macos.universal.tar.gz"
  version "1.2.0"
  sha256 "fe56d9c30ea544eedebfe15945b6857ce90cc149ec37a354d4d08a2900a04170"
  license "Apache-2.0"

  depends_on :macos

  def install
    sbin.install "vigild"
    bin.install "vigil"
    libexec.install "vigil-container-dump", "vigil-firewall-dump", "vigil-launches-spool", "uninstall"
    pkgshare.install "config" => "defaults"
    doc.install "README.md", "README-macos.md", "LICENSE", "NOTICE", "THIRD-PARTY.md"
  end

  service do
    run [opt_sbin/"vigild", "#{Dir.home}/.config/vigil/vigil.yaml"]
    keep_alive true
    log_path "#{Dir.home}/Library/Logs/vigil/vigild.log"
    error_log_path "#{Dir.home}/Library/Logs/vigil/vigild.log"
  end

  def caveats
    <<~EOS
      vigil runs as your own account, with no sudo. Three steps:

        vigild configure
        brew services start vigil
        vigil ui

      Without root the agent cannot see everything a Mac holds; each collector says what it
      could not read. An agent run by root is installed from the .pkg, not from Homebrew.

      Stop the service before you remove the formula:

        brew services stop vigil

      brew uninstall keeps ~/.config/vigil, ~/.local/state/vigil and ~/Library/Logs/vigil.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vigil --version")
    assert_match version.to_s, shell_output("#{sbin}/vigild --version")
  end
end
