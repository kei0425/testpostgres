# ベースイメージ
FROM clipcross2/db

# 管理者情報
MAINTAINER Keisuke Okada <keisuke_okada@nikkei-r.co.jp>

#conf編集 アーカイブ無効、ログを標準エラー
RUN sed -i -e '/^archive_mode/d' -e '/^logging_collector/d' /var/lib/pgsql/data/postgresql.conf

# 起動
USER postgres

ADD crosstesttemplatedb.sql.gz /var/lib/pgsql/crosstesttemplatedb.sql.gz
ENV dbname crossdb
RUN /usr/local/pgsql/bin/pg_ctl -D /var/lib/pgsql/data start && sleep 2 && /usr/local/pgsql/bin/createdb --encoding=utf8 -h localhost -p 15432 -T template0 ${dbname} && zcat /var/lib/pgsql/crosstesttemplatedb.sql.gz | psql -h localhost -p 15432 ${dbname}  && /usr/local/pgsql/bin/pg_ctl -D /var/lib/pgsql/data stop
# 終了

RUN echo 'host    all             all             192.168.255.0/24         trust' >> /var/lib/pgsql/data/pg_hba.conf

# コンテナ起動時のコマンド
CMD ["/usr/local/pgsql/bin/postgres", "-D", "/var/lib/pgsql/data"]
#CMD ["/bin/bash"]
ADD Dockerfile /Dockerfile
