class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.4/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ac213baf217ef4db5ec0f63f68027bf3c5d356b648fd54bf1a32ca570954b4f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.4/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "197dcb1ed44e4202e5d94c75e18a9965d2b320051a2a5b7281560ebf2cf354d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.4/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "af40a7d6f57e2b60c8b500464d5c55bacedc0a4500604da45cdc620c136b920a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.4/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8b10f7ffc580a5ebc9e4eeaa2aeb1de5ccdee2811e4a85baffe3ae9d37bb770a"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "confer" if OS.mac? && Hardware::CPU.arm?
    bin.install "confer" if OS.mac? && Hardware::CPU.intel?
    bin.install "confer" if OS.linux? && Hardware::CPU.arm?
    bin.install "confer" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
