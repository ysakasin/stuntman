# Stuntman

自分の身代わりとなるTwitter Bot

## Feature

このプログラムは、特定のアカウントと似たようなツイートをする機能を提供する。特定のアカウントからツイートを収集し、その情報を元にツイートを生成する。

機能を実現するために、マルコフ連鎖や形態素解析といった技術・性質を利用している。

### 持っている機能

* それらしい文章を生成してTwitterにツイートする
* CSVからツイートをインポートする
* Twitter APIをつかってツイートをインポートする
* 複数のアカウントからツイートをインポートする

### 持っていない機能

* デーモン化
* リプライへの応答
* 指定の時間につぶやく
* ツイートを自動で収集する

## Getting started

### リポジトリをクローン

```
git clone https://github.com/NKMR6194/stuntman
```

### 異存関係のインストール

日本語の処理に以下のソフトウェアを用いている。環境に合わせて適宜インストールすること。

* MeCab
* [mecab-ipadic-neologd](https://github.com/neologd/mecab-ipadic-neologd)

Gem Packageの管理をBundlerで管理している。以下のコマンドでGemをインストールする。
```sh
bundle install
```

### Config

`config.rb`に以下の項目を設定する。

* `:consumer_key`
* `:consumer_secret`
* `:mecab_dic_path` MeCabの辞書データへのパス

### Initialize

データベースを生成する。

```
rake db:migrate
```

アカウントにアクセスする。表示されるURLにアクセスし、PINを入力する。

```
rake oauth
```

CSVもしくはTwitter APIを用いて今までのツイートを読み込む。Usageを参照

## Usage

全ての操作には`Rake`を用いる。

### post

```
rake post NAME=screen_name
```
生成したツイートをTwitterに投稿する

* `NAME` : ツイートするアカウントのID

### gen

```
rake gen
```

生成したツイートをコマンドラインに表示する。Twitterへの投稿は行わない

### oauth

```
rake oauth
```

ユーザー認証を行う

### import_csv

```
rake import_csv CSV=path/to/csv NAME=screen_name
```

CSVからツイートを読み込む

* `CSV` : CSVへのファイルパス
* `NAME` : CSVのアカウントID

### import_api

```
rake import_api
```

認証を行った全てのアカウントにおいて、Twitter APIを用いてツイートを読み込む。対象となるツイートは、今までに読み込んでいないツイートのみである

### delete

```
rake delete
```

今までに読み込んだツイートデータを削除する。

### モジュール

`lib/stantman.rb`をロードすることで各モジュールを利用することもできる。しかし、ドキュメントは未整備であり、急な仕様変更が予想されるため推奨しない。

## License

MIT License
