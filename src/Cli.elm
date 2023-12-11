module Cli exposing (run, runSolvers)

import BackendTask exposing (BackendTask)
import BackendTask.File
import FatalError exposing (FatalError)
import Pages.Script as Script exposing (Script)


type alias Solver =
    String -> Int


run : Script
run =
    runSolvers
        { part1 = always 1
        , part2 = always 2
        }


runSolvers : { part1 : Solver, part2 : Solver } -> Script
runSolvers { part1, part2 } =
    Script.withoutCliOptions
        (BackendTask.combine
            [ readFile "Day07sample.txt"
            , readFile "Day07puzzle.txt"
            ]
            |> BackendTask.andThen
                (\files ->
                    case files of
                        [ sample, puzzle ] ->
                            Script.log <|
                                "Part 1: "
                                    ++ String.fromInt (part1 sample)
                                    ++ "\n"
                                    ++ "Part 2: "
                                    ++ String.fromInt (part2 puzzle)

                        _ ->
                            Script.log "Wrong number of files loaded"
                )
        )


readFile : String -> BackendTask FatalError String
readFile filename =
    BackendTask.File.rawFile filename
        |> BackendTask.allowFatal
