module ViewTestTests exposing (..)

import Test exposing (Test, describe, test)
import Expect
import Html exposing (Html, div)
import Html.Attributes exposing (id, classList)
import ViewTest exposing (..)


all : Test
all =
    describe "ViewTest"
        [ test "find" <|
            \() ->
                view [ ( "todo1", False ), ( "todo2", True ) ]
                    |> find ".done"
                    |> List.length
                    |> Expect.equal 1
        , test "findFirst and text" <|
            \() ->
                view [ ( "todo1", False ), ( "todo2", True ) ]
                    |> findFirst ".done"
                    |> Maybe.map text
                    |> Maybe.withDefault ""
                    |> Expect.equal "todo2"
        , test "children" <|
            \() ->
                view [ ( "todo1", False ), ( "todo2", True ) ]
                    |> children "#todos"
                    |> List.head
                    |> Maybe.map text
                    |> Maybe.withDefault ""
                    |> Expect.equal "todo1"
        ]


type alias Todo =
    ( String, Bool )


view : List Todo -> Html msg
view todos =
    div [ id "todos" ] <|
        List.map displayTodo todos


displayTodo : Todo -> Html msg
displayTodo ( name, done ) =
    div
        [ classList
            [ ( "done", done )
            , ( "todo", not done )
            ]
        ]
        [ Html.text name ]
