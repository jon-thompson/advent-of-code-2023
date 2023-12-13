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
    List (List (Maybe Pipe))


type alias Position =
    ( Int, Int )


{-| | is a vertical pipe connecting north and south.

  - is a horizontal pipe connecting east and west.
    L is a 90-degree bend connecting north and east.
    J is a 90-degree bend connecting north and west.
    7 is a 90-degree bend connecting south and west.
    F is a 90-degree bend connecting south and east.
    . is ground; there is no pipe in this tile.
    S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

-}
type Pipe
    = Starting
    | Vertical
    | Horizontal
    | NorthEast
    | NorthWest
    | SouthWest
    | SouthEast


charToMaybePipe : Char -> Maybe Pipe
charToMaybePipe char =
    case char of
        '|' ->
            Just Vertical

        '-' ->
            Just Horizontal

        'L' ->
            Just NorthEast

        'J' ->
            Just NorthWest

        '7' ->
            Just SouthWest

        'F' ->
            Just SouthEast

        'S' ->
            Just Starting

        _ ->
            Nothing


type Direction
    = North
    | East
    | South
    | West


pipeToCardinalDirections : Pipe -> List Direction
pipeToCardinalDirections pipe =
    case pipe of
        Vertical ->
            [ North, South ]

        Horizontal ->
            [ East, West ]

        NorthEast ->
            [ North, East ]

        NorthWest ->
            [ North, West ]

        SouthWest ->
            [ South, West ]

        SouthEast ->
            [ South, East ]

        Starting ->
            Debug.todo "Starting pipe has no cardinal directions"


parseGrid : String -> Grid
parseGrid input =
    input
        |> String.lines
        |> List.map (String.toList >> List.map charToMaybePipe)


startingPosition : String -> Position
startingPosition input =
    let
        grid =
            parseGrid input

        positionsAndChars : List ( Position, Maybe Pipe )
        positionsAndChars =
            grid
                |> List.indexedMap
                    (\y row ->
                        row
                            |> List.indexedMap
                                (\x maybePipe ->
                                    ( ( x, y ), maybePipe )
                                )
                    )
                |> List.concat
    in
    positionsAndChars
        |> List.filter (\( _, maybePipe ) -> maybePipe == Just Starting)
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
                        [ [ Just SouthWest, Just Horizontal, Just SouthEast ]
                        , [ Nothing, Just SouthEast, Just NorthWest ]
                        ]
        , test "startingPosition" <|
            \_ ->
                """-L|F7
7-7|S
L|7|||"""
                    |> startingPosition
                    |> Expect.equal ( 4, 1 )
        , test "pipeToCardinalDirections" <|
            \_ ->
                NorthEast
                    |> pipeToCardinalDirections
                    |> Expect.equal [ North, East ]
        ]
