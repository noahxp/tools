FROM python:3.9.2-slim as base

WORKDIR /app
COPY app/ /app
RUN pip install -r requirements.txt
# m1 目前還不支援 pep517 ，所以安裝 pandas 要拉出來
RUN pip install pandas --no-use-pep517