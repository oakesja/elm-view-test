module ToHtmlTests exposing (all)

import Test exposing (..)
import Expect exposing (Expectation)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Keyed
import Html.Lazy
import VirtualDom
import Dom


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
          -- classList
          -- type'
          -- custom
        ]



{--
attributes to watch out for
style
data-*
odd named attributes https://github.com/nthtran/vdom-to-html/blob/master/property-config.js
attributes with booleans https://github.com/nthtran/vdom-to-html/blob/master/create-attribute.js#L32


attributes per html tag such as accept-charset is only for forms http://package.elm-lang.org/packages/elm-lang/html/1.1.0/Html-Attributes

validation for things such as http://www.w3schools.com/tags/att_meta_http_equiv.asp

look at https://github.com/facebook/react/blob/master/src/renderers/dom/shared/HTMLDOMPropertyConfig.js

other tests
svg
events are ignored

--}


expectHtmlString : String -> Html msg -> Expectation
expectHtmlString expected actualHtml =
    Dom.htmlToString actualHtml
        |> Expect.equal expected
