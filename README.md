# turbo-tan/homebrew-tap

Homebrew formulae for [tqLLM](https://tqllm.com) on Apple Silicon (macOS 15 or later).

```sh
brew install turbo-tan/tap/tqllm
tqllm serve            # downloads the model and drafter on first run
tqllm claude           # Claude Code pointed at the local server
```

Same build as `pip install "tqllm[mlx]"`: tqserve compiled against the stock MLX wheel in a private
virtualenv under the formula's prefix. Linux users run the Docker images, see
[turbo-tan/tqllm](https://github.com/turbo-tan/tqllm).
