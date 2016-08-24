module ViewTest exposing (..)

import VirtualDom
import Native.ViewTest


type DomNode
    = DomNode



-- selectors from https://github.com/cheeriojs/cheerio#-selector-context-root-


find : String -> VirtualDom.Node msg -> List DomNode
find selector node =
    toCheerio node
        |> Native.ViewTest.find selector


findFirst : String -> VirtualDom.Node msg -> Maybe DomNode
findFirst selector node =
    find selector node
        |> List.head


children : String -> VirtualDom.Node msg -> List DomNode
children selector node =
    toCheerio node
        |> Native.ViewTest.children selector


parent : String -> VirtualDom.Node msg -> List DomNode
parent selector node =
    []



-- https://github.com/cheeriojs/cheerio#text-textstring-


text : DomNode -> String
text =
    Native.ViewTest.text



-- Private


toCheerio : VirtualDom.Node msg -> DomNode
toCheerio node =
    Native.ViewTest.htmlToString node
        |> Native.ViewTest.stringToCheerio



{-
   other potention useful ones
   parent
   children
   at(index)
   is(selector)
   not(selector)
   contains(node)
   equals(node)
   equals(attribute)


-}
