module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (string)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import ToHtmlTests


all : Test
all =
    describe "ViewTest"
        [ ToHtmlTests.all
        ]
