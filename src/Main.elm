module Main exposing (..)

import Html exposing (Html, button, div, img, program, text, textarea)
import Html.Attributes exposing (src, value)
import Styles


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    { talks : List Talk }


type alias Talk =
    { imageUrl : String
    , name : String
    , message : String
    , createdAt : String
    }


type Msg
    = Hoge


init : ( Model, Cmd Msg )
init =
    ( { talks = initTalks }, Cmd.none )


initTalks : List Talk
initTalks =
    [ { imageUrl = "https://imgcp.aacdn.jp/img-c/680/auto/tipsplus/series/246/20160608_1465380998273.jpg"
    , name = "ダテちゃん"
    , message = "寿司食いてえ"
    , createdAt = "2018/01/27 13:00"
    }
    , { imageUrl = "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg"
    , name = "とみざわ"
    , message = "ちょっと何言ってるかわかんないっす"
    , createdAt = "2018/01/27 13:30"
    }
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Hoge ->
            ( model, Cmd.none )


view : Model -> Html Msg
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
        , div [ Styles.talks ]
            <| List.map viewTalk model.talks
        ]


viewTalk : Talk -> Html Msg
viewTalk talk =
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src talk.imageUrl ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ text talk.name ]
            , div [ Styles.message ] [ text talk.message ]
            , div [ Styles.talkFooter ]
                [ text talk.createdAt]
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
