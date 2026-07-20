class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.5/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "914317fa0f15d396af93808741916053f46664202c4a38b0bf0d8c9d9e810561"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.5/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9da6ff61a464336ca3e67c62e86b6a8b91ce7fa106f86ef507ce4b7cf13675cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.5/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "49588b6a9d59e7b8aaee91e2f0ceb75d88850ba3a41c9dd2a503d50b80f002f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.5/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "53843e0cca8f9e8278979f9c26ffeefcf630962ae9589da730ac25b22111ad6d"
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
