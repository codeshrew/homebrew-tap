class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.32"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.32/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "00e86e07fd7c7410292841bacb04dd1d12e38a0ac297d265d5d1cc937ddb91bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.32/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0497ab27e567946fe49f010fdcdb155606c049a55b4c276592459a35ae5fb4ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.32/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "81a909c859949c462345a2a67986ca0d9db91ce274656115266f4aacec9f2df8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.32/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "54396ea838d64979ddd686613e1bed4424b123ab1bce61f7186ee55f9fd90f9f"
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
