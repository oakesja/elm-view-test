module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (string)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import Dom
import ToHtmlTests


all : Test
all =
    describe "Dom"
        [ test "Shows a string" <|
            \() ->
                view "test"
                    |> Dom.findById "text-id"
                    |> Maybe.map Dom.text
                    |> Maybe.withDefault ""
                    |> Expect.equal "test"
        , ToHtmlTests.all
        ]


type alias Model =
    String


view : String -> Html msg
view str =
    div [ id "text-id" ]
        [ text str ]
