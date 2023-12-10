module Cli exposing (run)

import BackendTask exposing (BackendTask)
import BackendTask.File
import FatalError exposing (FatalError)
import Pages.Script as Script exposing (Script)


run : Script
run =
    Script.withoutCliOptions
        (readFile "Day07sample.txt"
            |> BackendTask.andThen Script.log
        )


readFile : String -> BackendTask FatalError String
readFile filename =
    BackendTask.File.rawFile filename
        |> BackendTask.allowFatal
