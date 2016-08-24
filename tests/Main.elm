port module Main exposing (..)

import Test exposing (describe)
import Test.Runner.Node exposing (run)
import Json.Encode exposing (Value)
import ToHtmlTests
import ViewTestTests


main : Program Never
main =
    describe "all tests"
        [ ToHtmlTests.all
        , ViewTestTests.all
        ]
        |> run emit


port emit : ( String, Value ) -> Cmd msg
