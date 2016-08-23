module Private.ViewTest exposing (..)

import Native.ViewTest
import Html exposing (Html)


htmlToString : Html msg -> String
htmlToString node =
    Native.ViewTest.htmlToString node
