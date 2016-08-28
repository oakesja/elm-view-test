module ToHtmlTests exposing (all)

import Test exposing (..)
import Expect exposing (Expectation)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events
import Html.Keyed
import Html.Lazy
import Json.Encode
import VirtualDom
import ViewTest exposing (html)


all : Test
all =
    describe "htmlToString"
        [ typesOfDomNodesTest
        , attributeNameTest
        , booleanAttributeTest
        , specialAttributeTest
        , voidElementTest
        ]


type Msg
    = Click


typesOfDomNodesTest : Test
typesOfDomNodesTest =
    describe "it handles the virtual dom node types"
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


attributeNameTest : Test
attributeNameTest =
    describe "it writes the correct names for attributes"
        [ test "basic attributes that don't need changed" <|
            \() ->
                div [ id "testId" ]
                    []
                    |> expectHtmlString "<div id=\"testId\"></div>"
        , test "acceptCharset maps to accept-charset" <|
            \() ->
                Html.form [ acceptCharset "ISO-8859-1" ]
                    []
                    |> expectHtmlString "<form accept-charset=\"ISO-8859-1\"></form>"
        , test "className maps to class" <|
            \() ->
                div [ class "testClass" ]
                    []
                    |> expectHtmlString "<div class=\"testClass\"></div>"
        , test "httpEquiv maps to http-equiv" <|
            \() ->
                VirtualDom.node "meta"
                    [ httpEquiv "refresh" ]
                    []
                    |> expectHtmlString "<meta http-equiv=\"refresh\">"
        , test "defaultValue maps to value" <|
            \() ->
                input [ defaultValue "defaultText" ]
                    []
                    |> expectHtmlString "<input value=\"defaultText\">"
        , test "downloadAs maps to download" <|
            \() ->
                a [ downloadAs "test.txt" ] []
                    |> expectHtmlString "<a download=\"test.txt\"></a>"
        , test "classList combines the applicable classes into a single string" <|
            \() ->
                div [ classList [ ( "class1", True ), ( "class2", False ), ( "class3", True ) ] ]
                    []
                    |> expectHtmlString "<div class=\"class1 class3\"></div>"
        , test "type' maps to type" <|
            \() ->
                button [ type' "submit" ] []
                    |> expectHtmlString "<button type=\"submit\"></button>"
        ]


booleanAttributeTest : Test
booleanAttributeTest =
    describe "it handles attributes with boolean values"
        [-- test "boolean attributes that are true are used" <|
         --     \() ->
         --         div [ hidden True ] []
         --             |> expectHtmlString "<div hidden></div>"
         --   , test "boolean attributes that are false are not used" <|
         --       \() ->
         --           div [ hidden False ] []
         --               |> expectHtmlString "<div></div>"
         -- download
         --   test in style attribute
        ]


specialAttributeTest : Test
specialAttributeTest =
    describe "it handles special attributes"
        [ test "style attributes are combined into a single string" <|
            \() ->
                div
                    [ style
                        [ ( "backgroundColor", "red" )
                        , ( "height", "90px" )
                        , ( "width", "100%" )
                        ]
                    ]
                    []
                    |> expectHtmlString "<div style=\"background-color: red; height: 90px; width: 100%;\"></div>"
        , test "style with an empty list of attributes is ignored" <|
            \() ->
                div [ style [] ]
                    []
                    |> expectHtmlString "<div></div>"
        , test "events are ignored" <|
            \() ->
                div [ Html.Events.onClick () ]
                    []
                    |> expectHtmlString "<div></div>"
        , test "custom attributes" <|
            \() ->
                VirtualDom.node "div"
                    [ VirtualDom.attribute "class" "testClass" ]
                    []
                    |> expectHtmlString "<div class=\"testClass\"></div>"
        ]


voidElementTest : Test
voidElementTest =
    let
        voidElements =
            [ ( "area", VirtualDom.node "area" )
            , ( "base", VirtualDom.node "base" )
            , ( "br", br )
            , ( "col", col )
            , ( "command", VirtualDom.node "command" )
            , ( "embed", embed )
            , ( "hr", hr )
            , ( "img", img )
            , ( "input", input )
            , ( "keygen", keygen )
            , ( "link", VirtualDom.node "link" )
            , ( "meta", VirtualDom.node "meta" )
            , ( "param", VirtualDom.node "param" )
            , ( "source", VirtualDom.node "source" )
            , ( "track", track )
            , ( "wbr", VirtualDom.node "wbr" )
            ]
    in
        describe "it handles html elements that should not have an end tag" <|
            List.map
                (\( name, htmlTag ) ->
                    test name <|
                        \() ->
                            htmlTag [] []
                                |> expectHtmlString ("<" ++ name ++ ">")
                )
                voidElements



{--
look at https://github.com/facebook/react/blob/master/src/renderers/dom/shared/HTMLDOMPropertyConfig.js
attributeNS  https://github.com/elm-lang/virtual-dom/blob/master/src/Native/VirtualDom.js#L1455
--}


expectHtmlString : String -> Html msg -> Expectation
expectHtmlString expected actualHtml =
    html actualHtml
        |> Expect.equal expected
