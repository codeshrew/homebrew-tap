class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.34"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.34/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f5361b58b8809898e9e45ad45eeeee0759896209a0e43d6b5f378d12c97e9d00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.34/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "47b9ee45f5fd878a4ba85a29ed6a1fb04f8541c4e564e7208641384afcad91de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.34/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6027433de4a013710828ababf6edb74f17522696b68bd769e56416e432b60c60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.34/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5bef2491517f85d859676fab10c7cc9b50400a2eb60e942f24f0a00b0651463f"
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
