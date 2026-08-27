class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.25/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b571958e0868f5dc6b52c2f4844e046267e12c50b14da886c4830a9bfccc9728"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.25/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7df59a9af905fd7ecc8c2beb81a23c3850edf0ff9822b6479142a36e196d9945"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.25/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c202d45158a657c321cdd6ac43222510137e23d35a83bd295f55cc6f3684c0fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.25/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "793ed0412b90e662c13b9660ff727a097f3afa32cc5c3e639422a0062d309b50"
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
