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
import Dom


-- rename to virtual dom tests


all : Test
all =
    describe "htmlToString"
        [ typesOfDomNodesTests
        , htmlAttributes
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


htmlAttributes : Test
htmlAttributes =
    describe "it can handle html attributes"
        [ test "basic attribute with string values" <|
            \() ->
                div [ id "testId" ] []
                    |> expectHtmlString "<div id=\"testId\"></div>"
          -- boolean ones are weird hidden is only visible for True, checkbox is never visible, and download does ="true|false"
          -- , test "basic attribute with boolean values" <|
          --     \() ->
          --         div [ hidden True ] []
          --             |> expectHtmlString "<div id=\"testId\"></div>"
        , test "acceptCharset maps to accept-charset" <|
            \() ->
                Html.form [ acceptCharset "ISO-8859-1" ] []
                    |> expectHtmlString "<form accept-charset=\"ISO-8859-1\"></form>"
        , test "className maps to class" <|
            \() ->
                div [ class "testClass" ] []
                    |> expectHtmlString "<div class=\"testClass\"></div>"
        , test "htmlFor maps to for" <|
            \() ->
                VirtualDom.node "meta" [ httpEquiv "refresh" ] []
                    |> expectHtmlString "<meta http-equiv=\"refresh\"></meta>"
        , test "defaultText maps to value" <|
            \() ->
                input [ defaultValue "defaultText" ] []
                    |> expectHtmlString "<input value=\"defaultText\"></input>"
        , test "defaultText maps to value" <|
            \() ->
                input [ defaultValue "defaultText" ] []
                    |> expectHtmlString "<input value=\"defaultText\"></input>"
        , test "downloadAs maps to download" <|
            \() ->
                a [ downloadAs "test.txt" ] []
                    |> expectHtmlString "<a download=\"test.txt\"></a>"
        , test "classList combines the applicable classes into a single string" <|
            \() ->
                div [ classList [ ( "class1", True ), ( "class2", False ), ( "class3", True ) ] ] []
                    |> expectHtmlString "<div class=\"class1 class3\"></div>"
        , test "type' maps to type" <|
            \() ->
                button [ type' "submit" ] []
                    |> expectHtmlString "<button type=\"submit\"></button>"
        , test "style attributes are combined into a single string" <|
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
        ]



{--
attributes with booleans https://github.com/nthtran/vdom-to-html/blob/master/create-attribute.js#L32
attributeNS  https://github.com/elm-lang/virtual-dom/blob/master/src/Native/VirtualDom.js#L1455
attribute vs property

void elements https://github.com/nthtran/vdom-to-html/blob/master/void-elements.js

look at https://github.com/facebook/react/blob/master/src/renderers/dom/shared/HTMLDOMPropertyConfig.js
--}


expectHtmlString : String -> Html msg -> Expectation
expectHtmlString expected actualHtml =
    Dom.htmlToString actualHtml
        |> Expect.equal expected
