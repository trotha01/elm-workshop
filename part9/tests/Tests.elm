module Tests exposing (..)

import ElmHub exposing (responseDecoder)
import Expect exposing (Expectation)
import Fuzz exposing (..)
import Json.Decode exposing (Value, decodeString)
import String
import Test exposing (..)


all : Test
all =
    describe "GitHub Response Decoder"
        [ test "it results in an Err for invalid JSON" <|
            \() ->
                let
                    json =
                        """{ "pizza": [] }"""

                    isErrorResult result =
                        case result of
                            Err _ ->
                                True

                            _ ->
                                False

                    -- TODO return True if the given Result is an Err of some sort,
                    -- and False if it is an Ok of some sort.
                    --
                    -- Result docs: http://package.elm-lang.org/packages/elm-lang/core/latest/Result
                in
                json
                    |> decodeString responseDecoder
                    |> isErrorResult
                    |> Expect.true "Expected decoding an invalid response to return an Err."
        , test "it successfully decodes a valid response" <|
            \() ->
                -- /* TODO: put JSON here! */
                """{ "items": [
                  { "id":5, "full_name":"foo", "stargazers_count":42 },
                  { "id": 3, "full_name":"bar", "stargazers_count":77 }
                 ] }"""
                    |> decodeString responseDecoder
                    |> Expect.equal
                        (Ok
                            [ { id = 5, name = "foo", stars = 42 }
                            , { id = 3, name = "bar", stars = 77 }
                            ]
                        )
        , fuzz (list int) "it decodes one SearchResult for each 'item' in the JSON" <|
            \ids ->
                let
                    -- TODO convert this to a fuzz test that generates a random
                    -- list of ids instead of this hardcoded list of three ids.
                    --
                    -- fuzz test docs: http://package.elm-lang.org/packages/elm-community/elm-test/latest/Test#fuzz
                    -- Fuzzer docs: http://package.elm-lang.org/packages/project-fuzzball/test/6.0.0
                    ids =
                        [ 12, 5, 76 ]

                    jsonFromId id =
                        """{"id": """ ++ toString id ++ """, "full_name": "foo", "stargazers_count": 42}"""

                    jsonItems =
                        String.join ", " (List.map jsonFromId ids)

                    json =
                        """{ "items": [""" ++ jsonItems ++ """] }"""
                in
                case decodeString responseDecoder json of
                    Ok results ->
                        List.length results
                            |> Expect.equal (List.length ids)

                    Err err ->
                        Expect.fail ("JSON decoding failed unexpectedly: " ++ err)
        ]
