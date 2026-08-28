class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.28/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "27c5794d84fd17078665e10782baba89128320a26322adb0be1011575b2b94ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.28/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1f6020200af59c36fa1c2ba770414e1812606cf175fb2aa832b8eadb269e3345"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.28/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "75624ef519bca48c0b17b040b1cfc63c030abf4486b0a1c9b60a31d33f602ad4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.28/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8a55d15746ff1a3f55011179f8fff89c9a86a782f6ab61c87bd9f20a766a55b8"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "confer"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "confer"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "confer"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "confer"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
