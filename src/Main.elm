module Main exposing (Member, Model, Msg(..), Talk, emptyMember, init, initMembers, initTalks, initialModel, main, update, view, viewEditingTalk, viewTalk)

import Browser exposing (element)
import Html exposing (Html, button, div, img, node, text, textarea)
import Html.Attributes exposing (class, href, rel, src, value)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    element
        { init = \_ -> init
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
    , Member "m2" "とみざわ" "https://d19vfv6p26udb5.cloudfront.net/wp-content/uploads/2016/10/03023515/gorilla-752875_960_720-768x544.jpg"
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
                    "t" ++ String.fromInt model.nextTalkIdNum

                newTalk =
                    Talk nextTalkId model.myselfId model.field "2018/01/27 15:30"
            in
            ( { model
                | talks = model.talks ++ [ newTalk ]
                , field = ""
                , nextTalkIdNum = model.nextTalkIdNum + 1
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ node "link" [ href "/css/main.css", rel "stylesheet" ] []
        , div [ class "main-wrap" ]
            [ div [ class "post-form" ]
                [ div [ class "form-left" ]
                    [ img [ class "self-img", src "https://d19vfv6p26udb5.cloudfront.net/wp-content/uploads/2016/10/03023515/gorilla-752875_960_720-768x544.jpg" ] []
                    ]
                , div [ class "form-right" ]
                    [ textarea [ class "form-area", value model.field, onInput ChangeInput ] []
                    , button [ class "post-button", onClick Add ] [ text "投稿！" ]
                    ]
                ]
            , div [ class "talks" ] <|
                List.map (\talk -> viewTalk talk model) model.talks
            ]
        ]


viewTalk : Talk -> Model -> Html Msg
viewTalk talk model =
    let
        member =
            model.members
                |> List.filter (\member_ -> member_.id == talk.memberId)
                >> List.head
                >> Maybe.withDefault emptyMember
    in
    div [ class "talk" ]
        [ div [ class "talk-left" ]
            [ img [ class "poster-img", src member.imageUrl ] [] ]
        , div [ class "talk-right" ]
            [ div [ class "poster-name" ] [ text member.name ]
            , div [ class "message" ] [ text talk.message ]
            , div [ class "talk-footer" ]
                [ text talk.createdAt ]
            ]
        ]



-- cf. 編集中はメッセージがtextarea表示になり、変更できるようになります


viewEditingTalk : Html msg
viewEditingTalk =
    div [ class "talk" ]
        [ div [ class "talk-left" ]
            [ img [ class "poster-img", src "https://d19vfv6p26udb5.cloudfront.net/wp-content/uploads/2016/10/03023515/gorilla-752875_960_720-768x544.jpg" ] [] ]
        , div [ class "talk-right" ]
            [ div [ class "poster-name" ] [ text "とみざわ" ]
            , textarea [ class "editing-message", value "僕ちゃんとピッザって言いましたよ" ] []
            , div [ class "talk-footer" ]
                [ text "2018/01/27 13:30"
                , div [ class "buttons" ]
                    [ button [ class "edit-button" ] [ text "完了" ]
                    , button [ class "delete-button" ] [ text "削除" ]
                    ]
                ]
            ]
        ]
