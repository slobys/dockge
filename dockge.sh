#!/bin/bash

set -e  # 遇到错误立即退出

echo "🚀 开始安装 Docker..."
curl -fsSL https://get.docker.com | bash

echo "🔹 启动并设置 Docker 开机自启..."
sudo systemctl enable --now docker

echo "🚀 获取最新版本的 Docker Compose..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

echo "🔹 最新版本为：$LATEST_VERSION"
COMPOSE_URL="https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-linux-x86_64"

echo "🚀 开始安装 Docker Compose..."
sudo curl -SL "$COMPOSE_URL" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "✅ Docker 和 Docker Compose 安装完成！"
echo "🔹 Docker 版本："
docker --version
echo "🔹 Docker Compose 版本："
docker compose version

echo "🚀 开始安装 Dockge..."

DOCKGE_DIR="$HOME/dockge"
mkdir -p "$DOCKGE_DIR"
cd "$DOCKGE_DIR"

echo "🔹 下载 Dockge docker-compose 配置文件..."
curl -fsSL https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# 交互输入端口，默认5001
read -rp "请输入宿主机映射的端口号（默认5001）: " HOST_PORT
HOST_PORT=${HOST_PORT:-5001}

echo "🔹 设置 Dockge 监听端口为：$HOST_PORT"

# 替换 compose.yaml 里的端口映射（假设模板里是 33631:5001，替换 33631 为用户输入端口）
# 这里匹配格式为：- 33631:5001  修改为 - $HOST_PORT:5001
sed -i "s/- [0-9]\{1,5\}:5001/- $HOST_PORT:5001/" compose.yaml

echo "🚀 使用 Docker Compose 启动 Dockge 服务..."
docker compose up -d

# 获取服务器公网IP，失败则获取内网IP
IP=$(curl -s https://api.ipify.org || hostname -I | awk '{print $1}')

echo "✅ Dockge 安装并启动完成！"
echo "🔹 请访问以下地址打开 Dockge 界面："
echo "➡️  http://$IP:$HOST_PORT"
