## つくるもの
チャットアプリ。

- 各トークに表示されるもの
    - 投稿者名
    - 投稿者画像
    - 投稿メッセージ

- 機能
    - 新規投稿
    - 編集
    - 削除


## Step

### 0. サーバを起動する

```
$ git clone git@github.com:heartscry4423/elm-chat.git
    or
$ git clone https://github.com/heartscry4423/elm-chat.git
```
```
$ cd elm-chat
$ elm reactor
$ open http://localhost:8000/src/Main.elm
```

### 1. トークのリスト表示をElmのList型を利用して表示する
*実装例が`src/Sample/Main_1.elm`にあります*

sampleTalk1, sampleTalk2の部分をListに定義して、そのListを利用してトークが表示されるようにする

```
sampleTalks: List Talk
sampleTalks = [ sampleTalk1, sampleTalk2 ]
```

*viewEditingTalkを呼び出しているところは一旦消して見ましょう*


#### ヒント
- `List.map`をつかってみよう


### 2. initialModelを構成する

*実装例が`src/Sample/Main_2.elm`にあります*

今のviewではsampleTalksやsampleMembersを直接呼び出してviewを構成しています

Model型が`List Talk`や`List Member`を所持できるように修正して

viewではmodel越しに`List Talk`や`List Member`を扱うようにしてみましょう


### 3. 新規投稿機能をつくる
msgとupdateの処理を定義し、アプリケーションの操作に従って  
modelの更新を行えるようにしていきます。

一番上の投稿フォームにテキストを入力して投稿ボタンを押すと、
リストの一番下に新規投稿として追加される機能を追加しましょう。

#### やること

*初めてのelm architectureなので説明が厚めですが、読んでわからなければプロジェクト内の`src/Sample/Main_3.elm`を見てください*

- `type alias Model`の定義を修正して、`textarea`で入力した文字列をModel型で所持できるようにする
- `type Msg`の定義を修正して、"`textarea`が入力されるたびに呼び出される`Msg`"を定義する
- "`textarea`が入力されるたびに呼び出される`Msg`"が`update`に渡されると、`Model`でもつ`textarea`で入力した値を持つ箇所が変更されるように`update`を修正する
- `type Msg`の定義を修正して、`textarea`が入力されるたびに`Model`の値が変化するように`update`を修正する
- `textarea`が入力されると"`textarea`が入力されるたびに呼び出される`Msg`"がupdateに渡されるように`view`を修正する
- `type Msg`の定義を修正して、[「投稿！」ボタンを押した時に呼び出される`Msg` ]を定義する
- [「投稿！」ボタンを押した時に呼び出される`Msg`]が`update`に渡されると、modelの`List Talk`を所持する箇所にtextareaで入力されたテキストから作られる新しい`Talk`が追加されるように`update`を修正する
- [「投稿！」ボタンを押した時に呼び出される`Msg`]が「投稿！」ボタンを押したときにupdateに渡されるように`view`を修正する

### 4. トークの削除機能をつくる
自分が投稿したトークのみ、削除できる機能をつくってみる

自分が投稿したトークにはトークの削除ボタンが表示されるようにしましょう

そのボタンを押すと当該チャットが画面から削除される機能を追加しましょう

#### やること

*実装例が`src/Sample/Main_4.elm`にあります*

- 自分の投稿したトークのみ削除ボタンが表示されるようにする
- トークの削除ボタンが押されると、そのトークは一覧から消えるように`Model`を操作できる`Msg`, `update`, `view`を実装する

### 5. トークの編集機能をつくる

自分が投稿したトークのみ、編集ボタンが表示されるようにしましょう

編集ボタンを押すと当該トークだけ編集中のviewに切り替わり、メッセージ内容を変更できます

完了ボタンを押すと元のトーク表示に戻ります

#### やること

- 自分の投稿したトークのみ、編集ボタンが表示されるようにする
- 編集ボタンを押すと、トークの表示がtextareaに代わり、メッセージの内容を編集できるようにする
- 編集ボタンを押すと、編集完了ボタンと編集キャンセルボタンが表示されるようになる
- 編集完了ボタンを押すと編集した内容が反映されつつ、もとの表示に戻る
- 編集キャンセルボタンを押すと編集した内容が破棄されて、元の表示に戻る