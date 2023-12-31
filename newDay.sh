#!/usr/bin/env bash

# Get the day number from the command line arguments
day_number=$1
file_type=$2

# Check if day_number is not empty
if [[ -z "$day_number" ]]; then
    echo "Day number cannot be empty"
    exit 1
fi

# Check if file_type is not empty and is either 'roc' or 'elm'
if [[ -z "$file_type" ]] || ([[ "$file_type" != "roc" ]] && [[ "$file_type" != "elm" ]]); then
    echo "File type must be either 'roc' or 'elm'"
    exit 1
fi

# Create two empty .txt files
touch "Day${day_number}puzzle.txt"
touch "Day${day_number}sample.txt"

# Create a .roc or .elm file with the specified content
if [[ "$file_type" == "roc" ]]; then
    cat << EOF > "Day${day_number}.roc"
app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day${day_number}puzzle.txt" as puzzle : Str
    , "./Day${day_number}sample.txt" as sample : Str
    ]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"
EOF

    # Replace tasks with Roc commands in ./.vscode/tasks.json
    cat << EOF > ./.vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "test",
            "type": "shell",
            "command": "roc test Day${day_number}.roc",
        },
        {
            "label": "test:watch",
            "type": "shell",
            "command": "./testWatch.sh"
        },
        {
            "label": "run",
            "type": "shell",
            "command": "roc test Day${day_number}.roc",
        }
    ]
}
EOF

elif [[ "$file_type" == "elm" ]]; then
    cat << EOF > "./src/Day${day_number}.elm"
module Day${day_number} exposing (..)

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
    describe "Day ${day_number}"
        [ test "test something" <|
            \_ -> 
                Expect.equal 0 0
        ]

EOF

    # Replace tasks with Roc commands in ./.vscode/tasks.json
    cat << EOF > ./.vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "test",
            "type": "shell",
            "command": "elm-test 'src/Day${day_number}.elm'",
        },
        {
            "label": "test:watch",
            "type": "shell",
            "command": "elm-test --watch 'src/Day${day_number}.elm'"
        },
        {
            "label": "run",
            "type": "shell",
            "command": "npx elm-pages run src/Day${day_number}.elm",
        }
    ]
}
EOF
fi

echo "Files created successfully"