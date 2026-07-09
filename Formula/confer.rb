class Confer < Formula
  desc "Git-native coordination substrate for a fleet of AI agents"
  homepage "https://github.com/codeshrew/git-conversations"
  # From-source (no CI): brew clones the (private) source at the tag and builds it.
  # Uses your existing git auth for the private repo. Switch to prebuilt bottles
  # via a release workflow when the project goes public.
  url "https://github.com/codeshrew/git-conversations.git",
      using:    :git,
      tag:      "v0.1.0",
      revision: "4bfa1adfb2bfd366b04981878084755f3b6a1cdc"
  version "0.1.0"
  head "https://github.com/codeshrew/git-conversations.git", branch: "master"
  license "MIT"

  depends_on "rust" => :build

  def install
    # the crate lives in the confer/ subdir of the repo
    system "cargo", "install", *std_cargo_args(path: "confer")
  end

  test do
    assert_match "confer 0.1.0", shell_output("#{bin}/confer --version")
  end
end
