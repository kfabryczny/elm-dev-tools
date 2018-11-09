module Main exposing (main)

import Browser exposing (..)
import Debug.Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)


type Msg
    = NameInput String
    | PassInput String
    | CountInput Int
    | LogIn
    | LogOut


type Page
    = Login { name : String, pass : String }
    | Counter { name : String, count : Int }


init =
    { page = Login { name = "", pass = "" }
    }


update msg model =
    case msg of
        NameInput name ->
            case model.page of
                Login state ->
                    { model | page = Login { state | name = name } }

                _ ->
                    model

        PassInput pass ->
            case model.page of
                Login state ->
                    { model | page = Login { state | pass = pass } }

                _ ->
                    model

        CountInput count ->
            case model.page of
                Counter state ->
                    { model | page = Counter { state | count = count } }

                _ ->
                    model

        LogIn ->
            case model.page of
                Login state ->
                    { model | page = Counter { name = state.name, count = 0 } }

                _ ->
                    model

        LogOut ->
            case model.page of
                Counter _ ->
                    { model | page = Login { name = "", pass = "" } }

                _ ->
                    model


view model =
    case model.page of
        Counter state ->
            div []
                [ text ("Hello " ++ state.name)
                , button [ onClick LogOut ] [ text "Log Out" ]
                , div []
                    [ button [ onClick (CountInput (state.count + 1)) ] [ text "+" ]
                    , div [] [ text (fromInt state.count) ]
                    , button [ onClick (CountInput (state.count - 1)) ] [ text "-" ]
                    ]
                ]

        Login state ->
            div []
                [ input
                    [ type_ "text"
                    , value state.name
                    , onInput NameInput
                    ]
                    []
                , input
                    [ type_ "password"
                    , value state.pass
                    , onInput PassInput
                    ]
                    []
                , button
                    [ disabled (String.length state.pass < 1 || String.length state.name < 1)
                    , onClick LogIn
                    ]
                    [ text "Log In" ]
                ]


main =
    Debug.Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
