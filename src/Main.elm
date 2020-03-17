module Main exposing (Model)

import Browser
import Browser.Dom as BD exposing (Element, getElement)
import Browser.Events as BE
import Browser.Navigation as BN
import Element as E
import Element.Background as EBk
import Element.Border as EB
import Element.Events as EE
import Element.Font as EF
import Element.Input as EI
import LocalStorage as LS
import Platform.Sub as S


type alias Model =
    { getFor : String
    , getName : String
    , setName : String
    , setVal : String
    , received : LS.ReceiveValue
    }


type Msg
    = GetForChanged String
    | GetNameChanged String
    | SetNameChanged String
    | SetValChanged String
    | GetBt
    | SetBt
    | ClearBt
    | ReceiveLocalVal { for : String, name : String, value : Maybe String }


type alias Flags =
    ()


buttonStyle : List (E.Attribute msg)
buttonStyle =
    [ EBk.color <| E.rgb255 52 101 164
    , EF.color <| E.rgb 1 1 1
    , EB.color <| E.rgb255 32 74 135
    , E.paddingXY 10 5
    , EB.rounded 3
    ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { getFor = "test1"
      , getName = "widgetCount"
      , setName = "widgetCount"
      , setVal = "500"
      , received = { for = "", name = "", value = Nothing }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetForChanged s ->
            ( { model | getFor = s }, Cmd.none )

        GetNameChanged s ->
            ( { model | getName = s }, Cmd.none )

        SetNameChanged s ->
            ( { model | setName = s }, Cmd.none )

        SetValChanged s ->
            ( { model | setVal = s }, Cmd.none )

        GetBt ->
            ( model
            , LS.getLocalVal
                { name = model.getName
                , for = model.getFor
                }
            )

        SetBt ->
            ( model
            , LS.storeLocalVal
                { name = model.setName
                , value = model.setVal
                }
            )

        ClearBt ->
            ( model
            , LS.clearLocalStorage ()
            )

        ReceiveLocalVal lv ->
            ( { model | received = lv }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Local Storage Tester"
    , body =
        [ E.layout [] <|
            E.column [ E.spacing 5 ]
                [ E.row [ E.width E.fill, E.spacing 5, EB.width 2 ]
                    [ EI.button buttonStyle
                        { onPress = Just SetBt
                        , label = E.text "Set Local"
                        }
                    , EI.text []
                        { onChange = SetNameChanged
                        , text = model.setName
                        , label = EI.labelLeft [ E.centerY ] <| E.text "name"
                        , placeholder = Nothing
                        }
                    , EI.text []
                        { onChange = SetValChanged
                        , text = model.setVal
                        , label = EI.labelLeft [ E.centerY ] <| E.text "value"
                        , placeholder = Nothing
                        }
                    ]
                , E.row [ E.width E.fill, E.spacing 5, EB.width 2 ]
                    [ EI.button buttonStyle
                        { onPress = Just GetBt
                        , label = E.text "Get Local"
                        }
                    , EI.text [ E.centerY ]
                        { onChange = GetNameChanged
                        , text = model.getName
                        , label = EI.labelLeft [ E.centerY ] <| E.text "name"
                        , placeholder = Nothing
                        }
                    , EI.text [ E.centerY ]
                        { onChange = GetForChanged
                        , text = model.getFor
                        , label = EI.labelLeft [ E.centerY ] <| E.text "for"
                        , placeholder = Nothing
                        }
                    ]
                , E.row [ E.width E.fill, E.spacing 5, EB.width 2 ]
                    [ EI.button buttonStyle
                        { onPress = Just ClearBt
                        , label = E.text "Clear Local Storage"
                        }
                    ]
                , E.row [ E.width E.fill, E.spacing 5 ]
                    [ E.column []
                        [ E.el [ EF.bold ] <| E.text "for: "
                        , E.el [ EF.bold ] <| E.text "name: "
                        , E.el [ EF.bold ] <| E.text "value: "
                        ]
                    , E.column []
                        [ E.text <| "\"" ++ model.received.for ++ "\""
                        , E.text <| "\"" ++ model.received.name ++ "\""
                        , E.text <|
                            case model.received.value of
                                Nothing ->
                                    "Nothing"

                                Just v ->
                                    "Just " ++ "\"" ++ v ++ "\""
                        ]
                    ]
                ]
        ]
    }


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> LS.localVal ReceiveLocalVal
        , view = view
        }
