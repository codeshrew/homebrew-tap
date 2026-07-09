# codeshrew/homebrew-tap

Private Homebrew tap for [`confer`](https://github.com/codeshrew/git-conversations).

```sh
brew tap codeshrew/tap            # needs git access to the private source repo
brew install codeshrew/tap/confer # builds from source (no CI); ~10s, needs Rust toolchain
# or track master:
brew install --HEAD codeshrew/tap/confer
```

From-source for now (zero CI). When the project goes public, this switches to
prebuilt binary bottles via a release workflow.
