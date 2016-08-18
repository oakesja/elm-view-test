module Dom exposing (..)

import Native.Dom
import Html exposing (Html)


type DomNode
    = DomNode


htmlToString : Html msg -> String
htmlToString node =
    Native.Dom.htmlToString node


find : String -> Html msg -> List DomNode
find query html =
    htmlToString html
        |> stringToCheerio
        |> Native.Dom.find query


findById : String -> Html msg -> Maybe DomNode
findById id html =
    htmlToString html
        |> stringToCheerio
        |> Native.Dom.findById id


text : DomNode -> String
text =
    Native.Dom.text


findInNode : String -> DomNode -> List DomNode
findInNode query node =
    Native.Dom.find query node


stringToCheerio : String -> DomNode
stringToCheerio html =
    Native.Dom.stringToCheerio html


contains : String -> DomNode -> Bool
contains string node =
    Native.Dom.contains string node
