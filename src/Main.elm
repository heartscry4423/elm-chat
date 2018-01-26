module Main exposing (..)

import Html exposing (program, Html, div, img, text, textarea, button)
import Html.Attributes exposing (src, value)
import Styles as Styles


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    { hoge : String }


type Msg
    = Hoge


init : ( Model, Cmd Msg )
init =
    ( { hoge = "hogehoge" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Hoge ->
            ( model, Cmd.none )


view : Model -> Html msg
view model =
    div [ Styles.mainWrap ]
        [ div [ Styles.postForm ]
            [ div [ Styles.formLeft ]
              [ img [ Styles.selfImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] []
              ]
            , div [ Styles.formRight ]
              [ textarea [ Styles.formArea ] []
              , button [ Styles.postButton ] [ text "投稿！" ]
              ]
            ]
        , div [ Styles.talk ]
            [ div [ Styles.talkLeft ]
                [ img [ Styles.posterImg, src "https://imgcp.aacdn.jp/img-c/680/auto/tipsplus/series/246/20160608_1465380998273.jpg" ] [] ]
            , div [ Styles.talkRight ]
                [ div [ Styles.posterName ] [ text "伊達ちゃん" ]
                , div [ Styles.message ] [ text "ピザ食いてえ" ]
                , div [ Styles.talkFooter ]
                    [ text "2018/01/27 13:00"]
                ]
            ]
        , div [ Styles.talk ]
            [ div [ Styles.talkLeft ]
                [ img [ Styles.posterImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] [] ]
            , div [ Styles.talkRight ]
                [ div [ Styles.posterName ] [ text "とみざわ" ]
                , div [ Styles.message ] [ text "ちょっと何言ってるかわかんないっす" ]
                , div [ Styles.talkFooter ]
                    [ text "2018/01/27 13:30"
                    , div [ Styles.buttons ]
                        [ button [ Styles.editButton ] [ text "編集" ]
                        , button [ Styles.deleteButton ] [ text "削除" ]
                        ]
                    ]
                ]
            ]
        ]


-- cf. 編集中はメッセージがtextarea表示になり、変更できるようになります
viewEditingTalk : Html msg
viewEditingTalk =
        div [ Styles.talk ]
            [ div [ Styles.talkLeft ]
                [ img [ Styles.posterImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] [] ]
            , div [ Styles.talkRight ]
                [ div [ Styles.posterName ] [ text "とみざわ" ]
                , textarea [ Styles.editingMessage, value "僕ちゃんとピッザって言いましたよ" ] []
                , div [ Styles.talkFooter ]
                    [ text "2018/01/27 13:30"
                    , div [ Styles.buttons ]
                        [ button [ Styles.editButton ] [ text "完了" ]
                        , button [ Styles.deleteButton ] [ text "削除" ]
                        ]
                    ]
                ]
            ]
