# Guidelines that agents need to follow

## General Coding Habit

- When writing something intended for human consumption, (comment, commit message, reply to prompt) use as few words as possible. Pick every word meticulously to reduce the volume to a strict minimum. Be down to the point. Less is more.
- Avoid superlatives and praise. Stop telling me I am absolutely right. Give me the cold hard truth too.
- Reduce code indentation. Avoid Arrow Anti-Pattern. Leverage early return and continue.
- Let the reader of the code breathe. Add empty lines between logical blocks of code.

## ソースコメント規約

- 既存のコメントが日本語で書かれている場合、新たに追加するコメントも日本語で書くこと
- 英単語を日本語テキスト内で使用する場合、英単語の前後に半角スペースを**含めない**こと
  - 悪い「モジュールから upgrade 関数を取得する」
  - 良い「モジュールからupgrade関数を取得する」
- 関数コメント（DocString）を書く場合、以下のルールを基本とする
  - 1行目は1文で完結に関数の外部向け概要を記載する
  - 1行目の概要には句点をつけない
  - 1行目の概要はです・ます調にしない。「◯◯する」のように言い切りにする
  - より詳細な説明は概要から空行を1行入れて記載する
  - コメントには内部実装について過度に言及しない。あくまで関数の利用者が把握すべき関数の入出力仕様や注意点を記載する
