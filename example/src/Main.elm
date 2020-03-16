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
    { getName : String
    , setName : String
    , setVal : String
    , message : String
    }


type Msg
    = Noop
    | GetNameChanged String
    | SetNameChanged String
    | SetValChanged String
    | GetBt
    | SetBt


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
    ( { getName = ""
      , setName = ""
      , setVal = ""
      , message = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNameChanged s ->
            ( { model | getName = s }, Cmd.none )

        SetNameChanged s ->
            ( { model | setName = s }, Cmd.none )

        SetValChanged s ->
            ( { model | setVal = s }, Cmd.none )

        GetBt ->
            ( model, LS.getLocalVal ( model.getName, "wat" ) )

        SetBt ->
            ( model, LS.storeLocalVal ( model.setName, model.setVal ) )

        Noop ->
            ( model, Cmd.none )



--                         , LS.storeLocalVal ( "uid", info.uid )
--                     LS.clearLocalStorage ()
-- ( _, _ ) ->
--     ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Local Storage Tester"
    , body =
        [ E.layout [] <|
            E.column []
                [ E.row [ E.width E.fill ]
                    [ EI.text []
                        { onChange = GetNameChanged
                        , text = model.getName
                        , label = EI.labelLeft [] <| E.text "getName"
                        , placeholder = Nothing
                        }
                    , EI.button buttonStyle
                        { onPress = Just GetBt
                        , label = E.text "Get Local"
                        }
                    ]
                , E.row [ E.width E.fill ]
                    [ E.column [ E.width E.fill ]
                        [ EI.text []
                            { onChange = SetNameChanged
                            , text = model.setName
                            , label = EI.labelLeft [] <| E.text "setName"
                            , placeholder = Nothing
                            }
                        , EI.text []
                            { onChange = SetValChanged
                            , text = model.setVal
                            , label = EI.labelLeft [] <| E.text "setVal"
                            , placeholder = Nothing
                            }
                        ]
                    , EI.button buttonStyle
                        { onPress = Just SetBt
                        , label = E.text "Set Local"
                        }
                    ]
                , E.text model.message
                ]
        ]
    }


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> S.none
        , view = view
        }
