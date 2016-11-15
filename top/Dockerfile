# ベースイメージ
FROM centos:centos6.6

# 管理者情報
MAINTAINER Keisuke Okada <keisuke_okada@nikkei-r.co.jp>

# プロキシの設定
ENV http_proxy http://proxy.nikkei-r.co.jp:8080/

RUN yum -y install epel-release
RUN yum -y install npm
RUN yum -y install tar which

WORKDIR /root
RUN npm install -g n
RUN n latest
ADD top /root/top
WORKDIR /root/top

# コンテナ起動時のコマンド
CMD ["npm", "start"]
ADD Dockerfile /Dockerfile
