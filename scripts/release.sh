#!/bin/bash
# Point Formula/tqllm.rb at a tqllm release: ./scripts/release.sh 1.4.2.1 [bottle.json] (TAG=mac-v1.4.2.1 for a Mac-only tag)
# The bottle (from `brew bottle --json`) is uploaded to this repo's release tqllm-<version> before the formula is pushed.
set -euo pipefail
V=$1; F=Formula/tqllm.rb
URL=https://github.com/turbo-tan/tqllm/archive/refs/tags/${TAG:-v$V}.tar.gz
SHA=$(curl -fsSL "$URL" | sha256sum | cut -d' ' -f1)
sed -i -e "s|^  url .*|  url \"$URL\"|" -e "s|^  sha256 .*|  sha256 \"$SHA\"|" "$F"
sed -i '/^  bottle do/,/^  end/d' "$F"
if [ -n "${2:-}" ]; then
  python3 - "$2" "$F" "$V" <<'PY'
import json, sys
j, f, v = sys.argv[1:4]
b = next(iter(json.load(open(j)).values()))["bottle"]
lines = [f'  bottle do\n    root_url "https://github.com/turbo-tan/homebrew-tap/releases/download/tqllm-{v}"\n']
for tag, t in b["tags"].items():
    lines.append(f'    sha256 cellar: :any, {tag}: "{t["sha256"]}"\n')
lines.append("  end\n\n")
s = open(f).read(); i = s.index("  depends_on")
open(f, "w").write(s[:i] + "".join(lines) + s[i:])
PY
fi
echo "$F -> v$V sha256 $SHA"
