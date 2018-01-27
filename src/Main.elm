module Main exposing (..)

import Html exposing (Html, button, div, img, program, text, textarea)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onClick, onInput)
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
    { myselfId : String
    , members : List Member
    , talks : List Talk
    , field : String
    , nextTalkIdNum : Int
    }


emptyMember : Member
emptyMember =
    { id = ""
    , name = ""
    , imageUrl = ""
    }


type alias Talk =
    { id : String
    , memberId : String
    , message : String
    , createdAt : String
    }


type alias Member =
    { id : String
    , name : String
    , imageUrl : String
    }


type Msg
    = ChangeInput String
    | Add


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { myselfId = "m2"
    , members = initMembers
    , talks = initTalks
    , field = ""
    , nextTalkIdNum = 3
    }


initMembers : List Member
initMembers =
    [ Member "m1" "伊達ちゃん" "https://imgcp.aacdn.jp/img-c/680/auto/tipsplus/series/246/20160608_1465380998273.jpg"
    , Member "m2" "とみざわ" "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg"
    ]


initTalks : List Talk
initTalks =
    [ Talk "t1" "m1" "ピザ食いてえ" "2018/01/27 13:00"
    , Talk "t2" "m2" "ちょっと何いってるかわかんないっす" "2018/01/27 13:30"
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeInput text ->
            ( { model | field = text }, Cmd.none )

        Add ->
            let
                nextTalkId =
                    "t" ++ toString model.nextTalkIdNum

                newTalk =
                    Talk nextTalkId model.myselfId model.field "2018/01/27 15:30"
            in
            { model
                | talks = model.talks ++ [ newTalk ]
                , field = ""
                , nextTalkIdNum = model.nextTalkIdNum + 1
            } ! []


view : Model -> Html Msg
view model =
    div [ Styles.mainWrap ]
        [ div [ Styles.postForm ]
            [ div [ Styles.formLeft ]
                [ img [ Styles.selfImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] []
                ]
            , div [ Styles.formRight ]
                [ textarea [ Styles.formArea, value model.field, onInput ChangeInput ] []
                , button [ Styles.postButton, onClick Add ] [ text "投稿！" ]
                ]
            ]
        , div [ Styles.talks ]
            <| List.map (\talk -> viewTalk talk model) model.talks
        ]


viewTalk : Talk -> Model -> Html Msg
viewTalk talk model =
    let
        member =
            model.members
                |> List.filter (\member -> member.id == talk.memberId)
                >> List.head
                >> Maybe.withDefault emptyMember
    in
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src member.imageUrl ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ text member.name ]
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
