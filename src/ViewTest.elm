module ViewTest exposing (..)

import VirtualDom
import Native.ViewTest
import String


type alias Attribute =
    { name : String
    , value : String
    }


type alias TaggedNode =
    { tag : String
    , attributes : List Attribute
    , children : List DomNode
    }


type alias TextNode =
    { text : String
    }


type DomNode
    = Tag TaggedNode
    | Text TextNode


find : String -> VirtualDom.Node msg -> List DomNode
find selector node =
    toDomNode node
        |> findDomNode selector


findFirst : String -> VirtualDom.Node msg -> Maybe DomNode
findFirst selector node =
    find selector node
        |> List.head


text : DomNode -> String
text node =
    case node of
        Tag tagNode ->
            List.map text tagNode.children
                |> String.join " "

        Text textNode ->
            textNode.text


html : VirtualDom.Node msg -> String
html node =
    Native.ViewTest.htmlToString node


toDomNode : VirtualDom.Node msg -> DomNode
toDomNode node =
    Native.ViewTest.toDomNode node


findDomNode : String -> DomNode -> List DomNode
findDomNode selector node =
    case node of
        Tag tagNode ->
            if List.any (\a -> a.value == selector) tagNode.attributes then
                List.map (findDomNode selector) tagNode.children
                    |> List.concat
                    |> List.append [ node ]
            else
                List.map (findDomNode selector) tagNode.children
                    |> List.concat

        Text _ ->
            []



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
