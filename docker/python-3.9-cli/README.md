# python cli dockerize

## 使用方法

- 請先安裝 docker

- 申請 docker hub 帳號

- 安裝好的 docker ，用 cli 確認 docker 是否正常執行，並且登入 docker hub 帳號

```bash
# 確認版本
$ docker version

# 登入 docker hub
$ docker login
```

- 打包 cli

```bash
# docker images build
$ docker build -t="python:3.9-cli" .
```

- 設定 alias (linux/macos)

```bash
# 設定 alias
$ alias python="docker run --rm -v $(pwd):/app python:3.9-cli python "
# 執行 docker
$ python demo.py
```

## docker 補充

### Dockerfile

- 用來撰寫建置 Docker Image 的指令文件
- Dockerfile 內容 [官方文件](https://docs.docker.com/engine/reference/builder/)
- 建置 Docker Images

  ```bash
  docker build -t="python:latest" .
  # python 為 docker image 的 repository ，亦可用「/」作為分類，如「noah/python」
  # latest 為 tag ，未指定時，預設 tag 即為 latest
  ```

### 常用指令

  ```bash
  # 檢登 docker 是否成功安裝
  $ docker version

  # 登入 docker hub
  $ docker login

  # 列出所有 images
  $ docker images

  # 刪除 images，如果有執行中或已停止的 container ，則 images 無法被刪除，如果要刪除，需加「-f」
  $ docker rmi IMAGE_ID
  $ docker rmi -f IMAGE_ID  # force remove image

  # 執行 container
  $ docker run -it -d nginx
  # -it : i:interactive, t:tty, 可互動虛擬終端機
  # -d: detach, container 以背景方式執行
  # local 如果沒有該 IMAGE , 即會從 docker hub 下載

  # 執行 container II
  $ docker run -it -d -p 8080:80 -v ./hostfolder:/etc/nginx/html nginx:latest
  # -p 將 container 的 port 輸出，8080 為 host port, 80 為 container port ，亦即 container 可以註冊到 host 不同的 port
  # -v 將 host 的 path link 到 container 裡

  # 重啟 container
  $ docker restart CONTAINER_ID

  # 暫停 container
  $ docker pause CONTAINER_ID

  # 恢復 pause 的 container
  $ docker unpause CONTAINER_ID

  # 關閉執行中的 container
  $ docker stop CONTAINER_ID

  # 以終端機互動模式(tty)，連進 docker container
  $ docker exec -it CONTAINER_ID /bin/bash

  # 限制 CPU,Memory 的使用
  $ docker run -it --cpus=0.5 --memory=300m --memory-swap=0m -p 8080:80 -d nginx:latest

  # 查看 docker container
  $ docker ps
  $ docker ps -a
  # -a 為顯示已停掉的 container

  # 查看 docker container 使用 cpu/memory/network/disk-io等用量
  $ docker stats

  # 查詢 docker container 內部執行程序
  $ docker top CONTAINER_ID

  # 檢查 docker image/container 的配置
  $ docker inspect IMAGE_ID/CONTAINER

  # 追蹤 container log
  $ docker logs -f CONTAINER_ID

  # 刪除已停止的 container
  $ docker rm $(docker ps -f="status=exited" -f="status=created" -q)

  # 刪除被標為 <none> 的 images
  $ docker rmi $(docker images -f "dangling=true" -q)
  ```

### 進階應用

- [Dockerfile multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/)
- [docker compose](https://docs.docker.com/compose/)

### multi-arch

```bash
$ docker buildx create --use --name build
$ docker docker buildx build --push --platform linux/amd64,linux/arm64 --tag noahxp/python:3.9.2-cli .
```

### VS Code 搭配 Docker 開發環境

參考文件: https://docs.microsoft.com/zh-tw/learn/modules/use-docker-container-dev-env-vs-code/

- VS Code 安裝 Docker / Remote - Containers 二個 Extenstions
- cmd+shift+p ，輸入「 >Remote-Containers: Add Development Container Configuration Files」
- 依提示選擇語言，Python的話，選擇「Python 3 」，版本 「3.9」，「 install node.js 不要選 」
  - vscode 將會自動新增「.devcontainer」資料夾及相關檔案
  - .devcontainer 資料夾裡有 devcontainer.json 及 Dockerfile ，可以需求調整內容，例如需預裝的套件寫在 Dockerfile 裡
- cmd+shift+p，輸入「reopen in container 」選取「Remote-Containers: Reopen in Container」，重開後即會進入 container 開發模式 (第一次啟動會比較久)
  - 切回 local 開發模式，指令為「>Reopen Locally」或重啟 VS Code
