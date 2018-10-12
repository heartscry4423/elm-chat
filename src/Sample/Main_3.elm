module Main_3 exposing (Member, Model, Msg(..), Talk, init, initialModel, main, update, view, viewEditingTalk, viewTalk)

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



--- Model ---


type alias Model =
    { loginedMemberId : String
    , members : List Member
    , talks : List Talk
    , newTalkTextAreaValue : String
    , nextTalkIdNum : Int
    }



--- Type ---


type alias Talk =
    { id : String
    , memberId : String
    , message : String
    }


type alias Member =
    { id : String
    , name : String
    , imageUrl : String
    }


sampleTalk1 : Talk
sampleTalk1 =
    Talk "t1" "m1" "こんにちは"


sampleTalk2 : Talk
sampleTalk2 =
    Talk "t2" "m2" "ケバブはじめました"


sampleTalks : List Talk
sampleTalks =
    [ sampleTalk1, sampleTalk2 ]


sampleMembers : List Member
sampleMembers =
    [ Member "m1" "パソコンを持つ人" "https://1.bp.blogspot.com/-LoQvKFjTMCo/W3abXvFwxQI/AAAAAAABOAw/Gh5lV3wyGjwaqI-pV9QP1uPi-JRp6zmoACLcBGAs/s180-c/job_computer_technocrat.png"
    , Member "m2" "ケバブ屋さん" "https://4.bp.blogspot.com/-3ndKbo5JNcw/Ws2u06_gISI/AAAAAAABLRk/xz53-cS1koA6iqzrbJ1CntZO0nteFt-qgCLcBGAs/s180-c/food_kebabu_man.png"
    ]



--- Msg ---


type Msg
    = ClickedPostButton
    | ChangedNewTalkTextAreaValue String
    | ClickedTalkDeleteButton String


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { loginedMemberId = "m2", members = sampleMembers, talks = sampleTalks, newTalkTextAreaValue = "", nextTalkIdNum = 3 }



--- Update ---


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        debug1 =
            Debug.log "reached Msg! " msg
    in
    case msg of
        ClickedPostButton ->
            let
                newTalkId =
                    "nT" ++ String.fromInt model.nextTalkIdNum

                newTalk =
                    { id = newTalkId
                    , message = model.newTalkTextAreaValue
                    , memberId = model.loginedMemberId
                    }
            in
            ( { model
                | talks = List.append model.talks [ newTalk ]
                , newTalkTextAreaValue = ""
                , nextTalkIdNum = model.nextTalkIdNum + 1
              }
            , Cmd.none
            )

        ChangedNewTalkTextAreaValue stringValue ->
            ( { model | newTalkTextAreaValue = stringValue }, Cmd.none )

        ClickedTalkDeleteButton talkId ->
            ( { model | talks = List.filter (\talk -> talk.id /= talkId) model.talks }, Cmd.none )



--- View ---


view : Model -> Html Msg
view model =
    div []
        [ node "link" [ href "/css/main.css", rel "stylesheet" ] []
        , div [ class "main-wrap" ]
            [ div [ class "post-form" ]
                [ div [ class "form-left" ]
                    [ img [ class "self-img", src "https://4.bp.blogspot.com/-3ndKbo5JNcw/Ws2u06_gISI/AAAAAAABLRk/xz53-cS1koA6iqzrbJ1CntZO0nteFt-qgCLcBGAs/s180-c/food_kebabu_man.png" ] []
                    ]
                , div [ class "form-right" ]
                    [ textarea [ class "form-area", Html.Attributes.value model.newTalkTextAreaValue, Html.Events.onInput ChangedNewTalkTextAreaValue ] []
                    , button [ class "post-button", onClick ClickedPostButton ] [ text "投稿！" ]
                    ]
                ]
            , div [ class "talks" ] (List.map (viewTalk model) model.talks)
            ]
        ]


viewTalk : Model -> Talk -> Html Msg
viewTalk model talk =
    let
        maybeMember =
            model.members
                |> List.filter (\member_ -> member_.id == talk.memberId)
                |> List.head

        deleteButton =
            if Maybe.map (\member -> member.id) maybeMember == Just model.loginedMemberId then
                button [ class "delete-button", onClick (ClickedTalkDeleteButton talk.id) ] [ text "削除" ]

            else
                text ""
    in
    case maybeMember of
        Just member ->
            div [ class "talk" ]
                [ div [ class "talk-left" ]
                    [ img [ class "poster-img", src member.imageUrl ] [] ]
                , div [ class "talk-right" ]
                    [ div [ class "poster-name" ] [ text member.name ]
                    , div [ class "message" ] [ text talk.message ]
                    , div [ class "talk-footer" ]
                        [ div [ class "buttons" ]
                            [ deleteButton
                            ]
                        ]
                    ]
                ]

        Nothing ->
            text "No exist member talk.."


viewEditingTalk : Html msg
viewEditingTalk =
    div [ class "talk" ]
        [ div [ class "talk-left" ]
            [ img [ class "poster-img", src "https://4.bp.blogspot.com/-3ndKbo5JNcw/Ws2u06_gISI/AAAAAAABLRk/xz53-cS1koA6iqzrbJ1CntZO0nteFt-qgCLcBGAs/s180-c/food_kebabu_man.png" ] [] ]
        , div [ class "talk-right" ]
            [ div [ class "poster-name" ] [ text "ケバブ屋さん" ]
            , textarea [ class "editing-message", value "美味しいよ！" ] []
            , div [ class "talk-footer" ]
                [ div [ class "buttons" ]
                    [ button [ class "edit-button" ] [ text "完了" ]
                    , button [ class "delete-button" ] [ text "削除" ]
                    ]
                ]
            ]
        ]
