class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.43"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.43/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2b6e398462be454efeeead752ca2abe01368c9cc802a597298ec13510950dacc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.43/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8a8d0849100be207171e015d9e087dc5dc357b1ba1277b5ecc3921dad864631e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.43/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "58126e9ed65465387ddf85cccddf9eb03681f70a93675491c2b0ff33f40a94aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.43/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fc7a478266a12acd9c08e1ac1aaba4a0970f21a4109c99a2ca29dba369d2823b"
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
