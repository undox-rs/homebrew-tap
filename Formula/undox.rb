class Undox < Formula
  desc "A static site generator for multi-repo documentation"
  homepage "https://undox.dev"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.8/undox-aarch64-apple-darwin.tar.xz"
      sha256 "8eed2d4ecfea763a7cda10e5dc8b2f0c87a5d5bc648406aeb1e0eb0f45404949"
    end
    if Hardware::CPU.intel?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.8/undox-x86_64-apple-darwin.tar.xz"
      sha256 "3286d739f9607b7e9f5520d999cd788ba45ac0e24f500bb675737325079e4908"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.8/undox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e40ccd6a1f53b2e245e185193f1861196438d05cd5c4eb8960a0a91d655d0af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/undox-rs/undox/releases/download/v0.1.8/undox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "167af90ca512d54b6ad3b6bffe68d09afea00579f6dc2ba3c8fffb076b7fec66"
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
