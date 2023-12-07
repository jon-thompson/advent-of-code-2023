app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day07puzzle.txt" as puzzle : Str
    , "./Day07sample.txt" as sample : Str
    ]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"


expect
    out = parseHand "32T3K 765"

    out == { cards: "32T3K", bid: 765 }

Hand : { cards: Str, bid: Nat }

parseHand : Str -> Hand
parseHand = \str ->
    parts = Str.split str " "

    { cards:
        parts
            |> List.first
            |> Result.withDefault ""
    , bid:
        parts
            |> List.last
            |> Result.try Str.toNat
            |> Result.withDefault 0

    }