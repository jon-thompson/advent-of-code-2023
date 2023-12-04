app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day04.txt" as input : Str]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"


Card : { winning: List Nat, have: List Nat }

scoreCard : Str -> Nat
scoreCard = \str ->
    card = parseCard str

    winning =
        card.have
            |> List.countIf (\n -> List.contains card.winning n)

    Num.powInt 2 (winning - 1)


parseCard : Str -> Card
parseCard = \str ->
    numbers = str
        |> Str.split ": "
        |> List.last
        |> Result.map (\s -> Str.split s " | ")
        |> Result.withDefault []

    { winning:
        numbers
            |> List.first
            |> Result.map parseNumbers
            |> Result.withDefault []

    , have: 
        numbers
            |> List.last
            |> Result.map parseNumbers
            |> Result.withDefault [] }


parseNumbers : Str -> List Nat
parseNumbers = \str ->
    str
        |> Str.split " "
        |> List.keepOks Str.toNat


expect
    out = parseCard "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"

    out == { winning: [41, 48, 83, 86, 17], have: [83, 86, 6, 31, 17, 9, 48, 53] }

expect
    out = scoreCard "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"

    out == 8