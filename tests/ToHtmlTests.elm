module ToHtmlTests exposing (all)

import Test exposing (..)
import Expect exposing (Expectation)
import Html exposing (..)
import Html.Attributes exposing (..)
import Dom


all : Test
all =
    describe "htmlToString"
        [ test "simple div" <|
            \() ->
                div [] []
                    |> expectHtmlString "<div></div>"
        ]


expectHtmlString : String -> Html msg -> Expectation
expectHtmlString expected actualHtml =
    Dom.htmlToString actualHtml
        |> Expect.equal "<div></div>"
