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
docker-compose --version

echo "🚀 开始安装 Dockge..."

DOCKGE_DIR="$HOME/dockge"
mkdir -p "$DOCKGE_DIR"
cd "$DOCKGE_DIR"

echo "🔹 下载 Dockge docker-compose.yml 配置文件..."
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

echo "🚀 使用 Docker Compose 启动 Dockge 服务..."
sudo docker-compose up -d

echo "✅ Dockge 安装并启动完成！"
echo "🔹 请访问 http://localhost:8000 查看 Dockge 界面"
