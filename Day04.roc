app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day04.txt" as input : Str
    , "./Day04sample.txt" as sample : Str
    ]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"


Card : { index : Nat, winning: List Nat, have: List Nat }

scoreCards = \str ->
    str
        |> Str.split "\n"
        |> List.map scoreCard
        |> List.sum

scoreCard : Str -> Nat
scoreCard = \str ->
    winning = wins str

    if winning == 0 then
        0
    else
        Num.powInt 2 (winning - 1)


wins : Str -> Nat
wins = \str ->
    str
        |> parseCard
        |> winsCard

winsCard : Card -> Nat
winsCard = \card ->
    card.have
        |> List.countIf (\n -> List.contains card.winning n)


parseCard : Str -> Card
parseCard = \str ->
    index : Nat
    index =
        str
            |> Str.split ": "
            |> List.first
            |> Result.map (\head -> Str.split head " ")
            |> Result.try List.last
            |> Result.try Str.toNat
            |> Result.withDefault 0

    numbers = str
        |> Str.split ": "
        |> List.last
        |> Result.map (\s -> Str.split s " | ")
        |> Result.withDefault []

    { index: index
    , winning:
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

    out == { index: 1, winning: [41, 48, 83, 86, 17], have: [83, 86, 6, 31, 17, 9, 48, 53] }

expect
    out = scoreCard "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"

    out == 8

expect
    out = scoreCard "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19"

    out == 2

expect
    out = scoreCard "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"

    out == 2

expect
    out = scoreCard "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83"

    out == 1

expect
    card = parseCard "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36"

    winning =
        card.have
            |> List.countIf (\n -> List.contains card.winning n)

    winning == 0

expect
    out = scoreCard "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36"

    out == 0

expect
    out = scoreCards sample

    out == 13

# Part 1 test
expect
    out = scoreCards input

    out == 21485


# Part 2

expect
    out = wins "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"

    out == 4


# Walk thru list of cards, count how many have a winning number, tack on new cards from winners
countCards : Str -> Nat
countCards = \str ->
    cards =
        str
            |> Str.split "\n"
            |> List.map parseCard
    
    cards
        |> List.map (\c -> countEmUp cards c)
        |> List.sum

countEmUp : List Card, Card -> Nat
countEmUp = \allCards, card ->
    1 + List.sum (wonCards allCards card |> List.map (\c -> countEmUp allCards c))


wonCards : List Card, Card -> List Card
wonCards = \allCards, card ->
    List.sublist allCards { start: card.index, len: winsCard card }

expect
    out = countCards sample

    out == 30

expect
    out = countCards input

    out == 11024379