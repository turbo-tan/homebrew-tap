class Tqllm < Formula
  desc "Fast exact LLM serving on Apple Silicon (tqserve on MLX)"
  homepage "https://tqllm.com"
  url "https://github.com/turbo-tan/tqllm/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "77e192268af7d017d33cc1736b955ca4d1c0a645d21ca68ecad3d6932d8fac95"
  license "Apache-2.0"
  head "https://github.com/turbo-tan/tqllm.git", branch: "main"

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on "python@3.12"

  # tqserve links the C++ library inside the mlx wheel; its ABI changes between releases
  MLX = "mlx==0.32.4".freeze

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    system python, "-m", "venv", libexec
    pip = libexec/"bin/pip"
    system pip, "install", "--no-cache-dir", MLX, "huggingface_hub>=0.24", "scikit-build-core>=0.10"
    system pip, "install", "--no-cache-dir", "--no-build-isolation", "--no-deps", buildpath
    bin.install_symlink libexec/"bin/tqllm"
  end

  def caveats
    <<~EOS
      Start the server (downloads the model and drafter on first run):
        tqllm serve
      Point Claude Code or Codex at it:
        tqllm claude
        tqllm codex
    EOS
  end

  test do
    assert_match "serve", shell_output("#{bin}/tqllm --help")
    assert_path_exists libexec/Language::Python.site_packages(Formula["python@3.12"].opt_bin/"python3.12")/"tqllm/bin/tqserve"
  end
end
