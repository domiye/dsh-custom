#!/bin/sh
# 独立开发的启动脚本：使用仓库内的独立 DSH_HOME（.dsh-dev），
# 不读写 ~/.dsh 下的个人 profile，避免和已安装的 dsh 互相污染。
#
# 用法：
#   ./my-dsh-plugins/dev.sh                # 默认 3080 端口（若被占用请传 --port）
#   ./my-dsh-plugins/dev.sh --port 3085
#   ./my-dsh-plugins/dev.sh --patch ./my-dsh-plugins/hello/cordis.yml
set -eu
REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$REPO_ROOT"

export DSH_HOME="$REPO_ROOT/.dsh-dev"
mkdir -p "$DSH_HOME"

set -- --patch "$REPO_ROOT/my-dsh-plugins/hello/cordis.yml" "$@"
exec pnpm dsh web "$@"
