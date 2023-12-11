module Cli exposing (run)

import BackendTask exposing (BackendTask)
import BackendTask.File
import FatalError exposing (FatalError)
import Pages.Script as Script exposing (Script)


run : Script
run =
    Script.withoutCliOptions
        (BackendTask.combine
            [ readFile "Day07sample.txt"
            , readFile "Day07puzzle.txt"
            ]
            |> BackendTask.andThen
                (\files ->
                    case files of
                        [ sample, input ] ->
                            Script.log sample

                        _ ->
                            Script.log "Wrong number of files loaded"
                )
        )


readFile : String -> BackendTask FatalError String
readFile filename =
    BackendTask.File.rawFile filename
        |> BackendTask.allowFatal
