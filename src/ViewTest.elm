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



-- selectors from https://github.com/cheeriojs/cheerio#-selector-context-root-


find : String -> VirtualDom.Node msg -> List DomNode
find selector node =
    let
        domNode =
            Debug.log "node" <| toDomNode node
    in
        Debug.log "found" <| findDomNode selector domNode


findDomNode : String -> DomNode -> List DomNode
findDomNode selector node =
    case node of
        Tag tagNode ->
            if List.any (\a -> a.value == selector) tagNode.attributes then
                List.map (findDomNode selector) tagNode.children
                    |> Debug.log "matched selector"
                    |> List.concat
                    |> List.append [ node ]
            else
                List.map (findDomNode selector) tagNode.children
                    |> List.concat

        Text _ ->
            []


findFirst : String -> VirtualDom.Node msg -> Maybe DomNode
findFirst selector node =
    find selector node
        |> List.head



-- children : String -> VirtualDom.Node msg -> List DomNode
-- children selector node =
--     case find selector node of
--         Tag tagNode ->
--             tagNode.children
--
--         Text _ ->
--             []


parent : String -> VirtualDom.Node msg -> List DomNode
parent selector node =
    []



-- https://github.com/cheeriojs/cheerio#text-textstring-


text : DomNode -> String
text node =
    case node of
        Tag tagNode ->
            List.map text tagNode.children
                |> String.join " "

        Text textNode ->
            textNode.text



-- Native.ViewTest.text
-- Private


toDomNode : VirtualDom.Node msg -> DomNode
toDomNode node =
    Native.ViewTest.toDomNode node



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
