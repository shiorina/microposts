FROM ruby:2.6.3

ENV TZ Asia/Tokyo
RUN mkdir /app

ENV APP_ROOT /app
WORKDIR $APP_ROOT

# 必要なものをインストール
RUN apt-get update
RUN apt-get install -y nodejs mariadb-client graphviz --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# ホスト側のGemfileをコピー
ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

# bundle install
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem uninstall bundler && gem install bundler -v '2.1.4'
RUN bundle config --global build.nokogiri --use-system-libraries
RUN bundle config --global jobs 4
RUN bundle install

ADD . $APP_ROOT

# docker runした時に起動するコマンドを設定、ポートは3000を設定
EXPOSE  3000

