class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.8.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.17/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ec6e6af6f16f75b797c59faa404c02b5b99a74d4196d5167deedd1b660fdc1e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.17/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a8d8ab8b3204db75702272aa19ba7ca7f06aba13cd6141e19a0a545a396330bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.17/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3ee6f529f28347f2d7062cd724bd102c3c63efa3d75b3af5d9a3fe8c9eb3600f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.8.17/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "578ef829c6adb0b746ebe93210b23045214d574b7eb7b90a93842a7861e45b8d"
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
