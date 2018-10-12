## つくるもの
チャットアプリを作ってみましょう。

最初の段階ではハリボテの実装となっています。  
`src/Main.elm` に機能追加をしていくことでハリボテ実装を徐々になくしていきます。
実装例は`src/Sample`にあります。

- 機能
  - トークの表示
  - 新規投稿
  - 削除
- 各トークに表示されるもの
  - 投稿者名
  - 投稿者画像
  - 投稿メッセージ

## Step0. サーバを起動する
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

※再度ソースを変更したあとに画面表示を確かめたいときには、画面をリロードして下さい。

### vscodeで開く

1. vscodeを起動する
1. `ファイル` -> `開く...`
1. cloneしたリポジトリのディレクトリ(`elm-chat`)を選択して`開く`

### デバッグの仕方
ブラウザのコンソールにログ出力できます


`src/Main.elm`に記述していますが、以下のようになります。

```
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        debug1 =
            Debug.log "reached Msg! " msg
    in
```

`let`の中で使って下さい。
`model`をデバッグ表示したい場合には、`Debug.log "reached Msg! " model`となります。
関数内でアクセスできる引数や変数に対して出ないとデバッグできません。


## Step1. トークの表示
ハリボテ表示からModelを使っての表示に変えてみましょう。

*実装例は`src/Sample/Main_1.elm`にあります*

### Modelを変更してみよう
Modelはトーク(`Talk`)を保持していません。 __トークのList__ を保持できるように、プロパティを`type alias Model`に追加してみましょう  

### Modelを初期化してみよう
トークListを追加したModelを初期化するために`initialModel`関数を変更してみましょう  
初期化するトークの値には`sampleTalk1`, `sampleTalk2`を使って下さい

### Modelのトークを使ってviewを実装してみよう
`view関数`では`sampleTalks`を直接呼び出しています

Modelのトークを使って表示するように実装してみましょう

Listの要素を変換するのに、[List.map](https://package.elm-lang.org/packages/elm/core/latest/List#map)関数を使います

### 投稿者もModelに定義してviewで使ってみよう
トークと同様に投稿者(`Member`)についても実装してみましょう

- Modelに投稿者Listを保持するようにプロパティを追加する
- Modelの初期化のために`initialModel`関数で`sampleMembers`関数を使うように変更する
- `viewTalk`関数を以下のように変更します
  - 引数を追加します。第一引数に投稿者Listを追加
  - `sampleMembers`関数を呼んでいる箇所を引数の投稿者Listを使用するように変更
- `view`関数内での`viewTalk`関数呼び出しで、Modelの投稿者Listを渡すように変更します


## Step2. 新規投稿機能をつくる
一番上の投稿フォームにテキストを入力して投稿ボタンを押すと、リストの一番下に新規投稿として追加される機能を追加しましょう。

msgとupdateの処理を定義し、アプリケーションの操作に従ってmodelの更新を行えるようにしていきます。

*実装例は`src/Sample/Main_2.elm`にあります*

### テキストエリアの入力値を扱う
#### Modelを変更してみよう
テキストエリアで入力した文字列を保持できるように、プロパティをModelに追加してみよう

#### Msgを変更してみよう
テキストエリアに入力される度に発生するイベントに対応するMsg`ChangedNewTalkTextAreaValue String`を`type Msg`に追加してみよう  
`type Msg`はカスタムタイプなので`|`で区切って複数の値を定義します

#### updateを変更してみよう
テキストエリアに入力されると、`Modelでもつテキストエリアで入力した値をもつプロパティ`が変更されるように修正してみよう

Msgが`ChangedNewTalkTextAreaValue stringValue`の時に、`Modelでもつテキストエリアで入力した値をもつプロパティ`の値を`stringValue`の値に変えるように実装してみよう  
Modelはレコードなので、現在のレコードを元に該当箇所のみ更新した新しいレコードを生成させます

#### viewを変更してみよう
入力値が反映されるように、[textarea](https://package.elm-lang.org/packages/elm/html/latest/Html#textarea)関数の属性(第一引受数のList)に[Html.Attributes.value](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#value)を追加します  
`Html.Attributes.value` の引数には`Modelに保持しているテキストエリアで入力した値を持つプロパティ`を追加します

テキストエリアの入力イベントが発生するように`view`関数を変更します  
`textarea`関数の属性(第一引受数のList)に[Html.Events.onInput](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput)を追加します。  
`onInput`関数の引数には発生させたいMsgを渡します。

### 投稿できるようにする
#### Msgについて
`「投稿！」ボタンを押した時に発生するイベントに対応するMsg`は、予め用意した`ClickedPostButton`を使って下さい

#### updateを変更してみよう
「投稿！」ボタンが押された時に、Modelのトークが更新されるように修正してみよう

Msgが`ClickedPostButton`の時の実装を変えていきます。

idを採番します。  
重複を起こさないようにすればどんなルールで採番してもよいです。  
サンプルではModelで次のidを管理するようにしています。

新しい投稿を作ります。
`type alias Talk`の定義を見ながら作ってみて下さい

`「投稿！」ボタンを押した時に発生するイベントに対応するMsg`の時に、Modelのトークを更新します  
Listの結合を行いレコードの更新を行います。  
Listの結合には、`++`、または[List.append](https://package.elm-lang.org/packages/elm/core/latest/List#append)関数を使います  
`++`の例だと`[1,1,2] ++ [3,5,8] == [1,1,2,3,5,8]`のように使います。

#### viewを変更してみよう
「投稿！」ボタンを押した時にイベントが発生するように、`view`関数を変更します

クリックイベントが発生するように、[textarea](https://package.elm-lang.org/packages/elm/html/latest/Html#textarea)関数の属性(第一引受数のList)に[Html.Events.onClick](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onClick) を追加します。
`onClick`関数の引数には発生させたいMsgを渡します。


## Step3. トークの削除機能をつくる
自分が投稿したトークのみ、削除できる機能をつくってみましょう

自分の投稿者idは`Model.loginedMemberId`です

*実装例が`src/Sample/Main_3.elm`にあります*

### 削除ボタンの表示
自分が投稿したトークには、トークの削除ボタンが表示されるようにしましょう

`viewTalk`関数で、自分が投稿したトークの場合は削除ボタンを表示し、他人が投稿したトークの場合は空のplain textが表示されるようにしてみよう

`Maybe.map`関数を使って、`Maybe a`の`Member`要素をidに変換してみよう

### トークの削除
トークの削除ボタンを押すと、当該トークが画面から削除される機能を追加しましょう

#### Msgについて
`削除ボタンを押した時に発生するイベントに対応するMsg`を追加して下さい。  
削除するにはトークのidが必要になります。

#### updateを変更してみよう
削除ボタンが押された時に、Modelのトークが更新されるように修正してみよう

[List.filter](https://package.elm-lang.org/packages/elm/core/latest/List#filter)を使ってみて下さい。

#### viewを変更してみよう
削除ボタンを押した時にイベントが発生するように、`viewTalk`関数で追加した削除ボタンにクリックイベントを追加してみましょう

トークのidを渡すことを忘れずにしてください

## チャレンジ編！！
めっちゃ速く終わってしまった方は以下にチャレンジしてみよう！  
なお実装例は用意していません。。。

- トークの編集機能をつくる
- モジュール分割してみよう
- 説明がないところはおまじない的に見えると思うので、そこを調べてみる

### トークの編集機能をつくる
自分が投稿したトークのみ、編集ボタンが表示されるようにしましょう

編集ボタンを押すと当該トークだけ編集中のviewに切り替わり、メッセージ内容を変更できます  
完了ボタンを押すと元のトーク表示に戻ります

#### やること

- 自分の投稿したトークのみ、編集ボタンが表示されるようにする
- 編集ボタンを押すと、トークの表示がtextareaに代わり、メッセージの内容を編集できるようにする
- 編集ボタンを押すと、編集完了ボタンと編集キャンセルボタンが表示されるようになる
- 編集完了ボタンを押すと編集した内容が反映されつつ、もとの表示に戻る
- 編集キャンセルボタンを押すと編集した内容が破棄されて、元の表示に戻る

※`viewEditingTalk`関数を使って下さい

### モジュール分割してみよう
今回はMain.elmの1ファイルのみで作成していますが、例えばView, Model, Updateを別ファイルに切り出してみよう
