class Undox < Formula
  desc "A static site generator for multi-repo documentation"
  homepage "https://undox.dev"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.7/undox-aarch64-apple-darwin.tar.xz"
      sha256 "f98c2548fad0520b98bb38eab81aaba0e2a9aa7cc42db68888f1e29e9710018c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.7/undox-x86_64-apple-darwin.tar.xz"
      sha256 "ce197d18c5731ffb910d6d4ad2dcd2d097a69ee664ba418e290108b6c31ceefd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.7/undox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d62034a9538154c9359aa30feea95a1e3761f16a2f4b5e167561f85cce62b7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.7/undox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "610fe51a181978357f22088dde4dc82f7845c6c187898e47f2cd40f5459a370b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "undox" if OS.mac? && Hardware::CPU.arm?
    bin.install "undox" if OS.mac? && Hardware::CPU.intel?
    bin.install "undox" if OS.linux? && Hardware::CPU.arm?
    bin.install "undox" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
