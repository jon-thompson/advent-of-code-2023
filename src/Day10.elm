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


suite : Test
suite =
    describe "Day 10"
        [ test "test something" <| \_ -> Expect.equal 0 0
        ]
