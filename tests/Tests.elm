module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import ToHtmlTests
import ViewTestTests


all : Test
all =
    describe "all tests"
        [ ToHtmlTests.all
        , ViewTestTests.all
        ]
