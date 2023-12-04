app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day04.txt" as input : Str]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"


Card : { winning: List Nat, have: List Nat }

parseCard : Str -> Card
parseCard = \str ->
    numbers = str
        |> Str.split ": "
        |> List.last
        |> Result.map (\s -> Str.split s " | ")
        |> Result.withDefault []

    { winning:
        numbers
            |> List.get 0
            |> Result.map (\s ->
                s
                    |> Str.split " "
                    |> List.map (\n ->
                        n |> Str.toNat |> Result.withDefault 0
                    )
            )
            |> Result.withDefault []

    , have: [] }


expect
    out = parseCard "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"

    out == { winning: [41, 48, 83, 86, 17], have: [83, 86, 6, 31, 17, 9, 48, 53] }