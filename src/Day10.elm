module Day10 exposing (..)

import Cli
import Expect
import Pages.Script exposing (Script)
import Test exposing (Test, describe, test)


run : Script
run =
    Cli.runSolvers
        { part1 = part1
        , part2 = part2
        }


part1 : String -> Int
part1 input =
    0


part2 : String -> Int
part2 input =
    0


type alias Grid =
    List (List Char)


type alias Position =
    ( Int, Int )


parseGrid : String -> Grid
parseGrid input =
    input
        |> String.lines
        |> List.map String.toList


startingPosition : Grid -> Position
startingPosition grid =
    let
        positionsAndChars : List ( Position, Char )
        positionsAndChars =
            grid
                |> List.indexedMap
                    (\y row ->
                        row
                            |> List.indexedMap
                                (\x char ->
                                    ( ( x, y ), char )
                                )
                    )
                |> List.concat
    in
    positionsAndChars
        |> List.filter (\( _, char ) -> char == 'S')
        |> List.head
        |> Maybe.map (\( pos, _ ) -> pos)
        |> (\maybePos ->
                case maybePos of
                    Just pos ->
                        pos

                    Nothing ->
                        Debug.todo "No starting position found"
           )


suite : Test
suite =
    describe "Day 10"
        [ test "parseGrid" <|
            \_ ->
                """7-F
.FJ"""
                    |> parseGrid
                    |> Expect.equal
                        [ [ '7', '-', 'F' ]
                        , [ '.', 'F', 'J' ]
                        ]
        , test "startingPosition" <|
            \_ ->
                [ [ '7', '-', 'F' ]
                , [ 'S', 'F', 'J' ]
                , [ '.', '7', 'R' ]
                ]
                    |> startingPosition
                    |> Expect.equal ( 0, 1 )
        ]
