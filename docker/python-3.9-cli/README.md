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
