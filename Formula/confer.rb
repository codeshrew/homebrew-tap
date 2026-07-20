class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.1/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "957885ea4014b51a1b993a7452d6ba14aba7f5b8a8410cbb8bd79c6c1932f842"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.1/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7d4c7e48c88db16dd3554cc925ea61acd96bdece7cec68ff7d7355eff942bc4b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.1/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b0701dde7791f67620ed67c7de478d18b6571841963a971d027f53cf5e9520c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.1/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "da679117f1bb9a992862f9bfb4099910e072541a21d61155c7aafcecbe506686"
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
