# 概要

`LaTeX-thesis-linter`は「`LaTeX`で執筆された日本語論文の校正を補助するツール」です。

（あくまでも、校正を補助するためのものであり、論文自体の正確性や文章の完全性を保証するものではありません。）

# 動作に必要なもの

- `Node.js`: `8.2.0`以上
- `npm`: `5.2.0`以上
- `Ruby`: `2.6.0`以上

# セットアップ

```zsh:ターミナル
$ git clone https://github.com/2754github/LaTeX-thesis-linter.git # DL&解答でも可
$ cd <LaTeX-thesis-linterフォルダへのpath>
$ npm install
```

# 使用方法

```zsh:ターミナル
$ cd <LaTeX-thesis-linterフォルダへのpath>
$ ruby file_linter.rb <校正したいファイルへのpath>
$ ruby dir_linter.rb <校正したいファイル群が置かれているディレクトリへのpath>

# サンプル
$ ruby file_linter.rb sample/bad_sentences.tex
```

# カスタマイズ

- `.textlintrc`: `textlint`の各ルールを設定します
  - 各ルールの概要は`LaTeX-thesis-linter/sample/bad_sentences.tex`に書いてあります
- `prh.yml`: 表記の統一ルールを設定します
  - [`prh.yml`の書き方](https://github.com/prh/prh/blob/master/misc/prh.yml)
  - [このリスト](https://raw.githubusercontent.com/WorksApplications/SudachiDict/develop/src/main/text/synonyms.txt)にあるものは`@textlint-ja/no-synonyms`のルールに内包されているので`prh.yml`には書かなくて大丈夫です
- `file_linter.rb`:
  - このファイルから`textlint`を呼び出してファイルを走査します
  - さらに`textlint`で対応できない追加のルール（カンマ/ピリオドに関するルール等）を付与してファイルを走査します
- `dir_linter.rb`: ディレクトリ下を再帰的に読み込み、ファイルを走査します

<details>
<summary>「`textlint`で対応できない追加のルール」はこちら</summary>

- 全角のスペース/読点/句点/カンマ/ピリオド/丸かっこを使用しない
- 半角のスペース/カンマ/ピリオド/丸かっこ（以下「␣」「,」「.」「(」「)」）を使用する
- 「,」「.」の前に「␣」を挿入しない
- 「,」「.」の後に「␣」を挿入する
- 「,␣(改行)」「,(改行)」で文が終了している場合に警告する
- 文頭が数式の場合に警告する
- `\int`コマンド使用時、被積分関数の後に`\,`を挿入する
- 「式`\eqref`」と記述する
- 「~`\cite`」と記述する
- ファイルの最後には改行を挿入する

</details>

# それでも対応できないルールは・・・

「`grep`をかける」「pdf を検索する」など、地道に確認しましょう・・・😭

例えば

- `{\\bf 初出の単語}`を心がける
- 数式に合わせたかっこの大きさ

などのルールです。

# 参考

- [textlint-ja](https://github.com/textlint-ja): 文章校正ツール（`LaTeX`非対応 😭）
- [textlint-plugin-latex2e](https://github.com/textlint/textlint-plugin-latex2e): `textlint-ja`で`LaTeX`ファイルが読み込めるようになるプラグイン（神 ☺️）
- [LaTeX における正しい論文の書き方](https://qiita.com/birdwatcher/items/5ec42b35d84d3ee2ffbb)

#### 「ご意見」「ルール追加/削除のご要望」「バグ報告」などありましたら、お気軽にお寄せください 🙇‍♂️
