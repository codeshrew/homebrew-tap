class Confer < Formula
  desc "A git-native coordination substrate for fleets of AI agents — an append-only, signed, verifiable message log with a thin liveness layer, no database and no server."
  homepage "https://github.com/codeshrew/confer"
  version "0.6.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.3/confer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "eb0df2380f61808d3258ce8579e0f2fe5a8456395db0a17670e0f457450c523c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.3/confer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c8e51d6678f8fec2157242c81aea737e8ba4c5e71152207a657b5b8ee6a5ca33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.3/confer-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a7e0c46745f9913b95ea3ec53f6dcf758f8ddae3e7234a095bafcf78270eafe7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codeshrew/confer/releases/download/v0.6.3/confer-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "69c40c6cab9b151a173d20a8667856861094210b32f787136ec588808bd8b2dc"
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
