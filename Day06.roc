app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day06.txt" as input : Str
    , "./Day06sample.txt" as sample : Str
    ]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"


parseNumbers : Str -> List Nat
parseNumbers = \str ->
    str
        |> Str.split " "
        |> List.map Str.trim
        |> List.keepOks Str.toNat


expect
    out = parseNumbers "  7  15   30"

    out == [7, 15, 30]