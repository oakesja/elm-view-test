module ToHtmlTests exposing (all)

import Test exposing (..)
import Expect exposing (Expectation)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Keyed
import Html.Lazy
import Dom


all : Test
all =
    describe "htmlToString"
        [ typesOfDomNodesTests
        ]


type Msg
    = Click


typesOfDomNodesTests : Test
typesOfDomNodesTests =
    describe "it can handle a"
        [ test "regular node" <|
            \() ->
                div [] []
                    |> expectHtmlString "<div></div>"
        , test "text node" <|
            \() ->
                text "test"
                    |> expectHtmlString "test"
        , test "keyed node" <|
            \() ->
                Html.Keyed.ol [] [ ( "child1", li [] [ text "item1" ] ) ]
                    |> expectHtmlString "<ol><li>item1</li></ol>"
        , test "custom node" <|
            \() ->
                Html.Keyed.ol [] [ ( "child1", li [] [ text "item1" ] ) ]
                    |> expectHtmlString "<ol><li>item1</li></ol>"
        , test "tagger node" <|
            \() ->
                div [] []
                    |> Html.App.map (\_ -> Click)
                    |> expectHtmlString "<div></div>"
        , test "thunk node" <|
            \() ->
                Html.Lazy.lazy (\str -> div [] [ text str ]) "test"
                    |> expectHtmlString "<div>test</div>"
        ]



{--
look at https://github.com/nthtran/vdom-to-html/blob/master/index.js

types of dom nodes
x node
x text
x keyed-node https://github.com/elm-lang/virtual-dom/blob/master/src/Native/VirtualDom.js#L78
x custom is not actually exposed to anything https://github.com/elm-lang/virtual-dom/blob/master/src/Native/VirtualDom.js#L93
x tagger used by map https://github.com/elm-lang/virtual-dom/blob/master/src/Native/VirtualDom.js#L104
x thunk used by lazy https://github.com/elm-lang/virtual-dom/blob/master/src/Native/VirtualDom.js#L115

attributes to watch out fo r
style
data-*
odd named attributes https://github.com/nthtran/vdom-to-html/blob/master/property-config.js
attributes with booleans https://github.com/nthtran/vdom-to-html/blob/master/create-attribute.js#L32


other tests
svg
events are ignored

--}


expectHtmlString : String -> Html msg -> Expectation
expectHtmlString expected actualHtml =
    Dom.htmlToString actualHtml
        |> Expect.equal expected
