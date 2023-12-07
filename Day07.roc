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

Type: [HighCard , OnePair , TwoPair , ThreeOfAKind ,  FullHouse , FourOfAKind , FiveOfAKind]

types : List Type
types = [HighCard , OnePair , TwoPair , ThreeOfAKind ,  FullHouse , FourOfAKind , FiveOfAKind]

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

expect
    out = getType { cards: "32T3K", bid: 765 }

    out == OnePair

expect
    out = getType { cards: "32T1K", bid: 765 }

    out == HighCard

getType : Hand -> Type
getType = \hand ->
    counts =
        hand.cards
            |> Str.graphemes
            |> List.walk (Dict.empty {}) (\dict, card ->
                Dict.update dict card (\possibleCount ->
                    when possibleCount is
                        Missing -> Present 1
                        Present count -> Present (count + 1)
                )
            )
            |> Dict.values
            |> List.sortDesc

    when counts is
        [1, 1, 1, 1, 1] -> HighCard
        [2, 1, 1, 1] -> OnePair
        [2, 2, 1] -> TwoPair
        [3, 1, 1] -> ThreeOfAKind
        [3, 2] -> FullHouse
        [4, 1] -> FourOfAKind
        [5] -> FiveOfAKind
        _ -> HighCard


expect
    out = sortByRank 
        [ { cards: "32T3K", bid: 765 }
        , { cards: "T55J5", bid: 684 }
        , { cards: "KK677", bid: 28 }
        , { cards: "KTJJT", bid: 220 }
        , { cards: "QQQJA", bid: 483 }
        ]

    out == 
        [ { cards: "32T3K", bid: 765 }
        , { cards: "KTJJT", bid: 220 }
        , { cards: "KK677", bid: 28 }
        , { cards: "T55J5", bid: 684 }
        , { cards: "QQQJA", bid: 483 }
        ]

sortByRank : List Hand -> List Hand
sortByRank = \hands ->
    hands
        |> List.sortWith (\a, b ->
            aTypeRank = List.findFirstIndex types (\t -> t == getType a) |> Result.withDefault 0
            bTypeRank = List.findFirstIndex types (\t -> t == getType b) |> Result.withDefault 0

            if aTypeRank > bTypeRank then 
                GT
            else if aTypeRank < bTypeRank then 
                LT
            else # type ranks equal
                List.map2 (Str.graphemes a.cards) (Str.graphemes b.cards) Pair
                    |> List.findFirst (\pair ->
                        when pair is
                            Pair aCard bCard ->
                                aCard != bCard
                    )
                    |> Result.map (\pair ->
                        when pair is
                            Pair aCard bCard ->
                                if cardValue aCard > cardValue bCard then
                                    GT
                                else LT
                    )
                    |> Result.withDefault EQ
        )

cardValue : Str -> Nat
cardValue = \card ->
    when card is
        "A" -> 14
        "K" -> 13
        "Q" -> 12
        "J" -> 11
        "T" -> 10
        _ -> Str.toNat card |> Result.withDefault 0


expect
    out = part1 sample

    out == 6440

expect
    out = part1 puzzle

    out == 248812215

part1 : Str -> Nat
part1 = \str ->
    str
        |> Str.split "\n"
        |> List.map parseHand
        |> sortByRank
        |> List.mapWithIndex (\hand, index ->
            hand.bid * (index + 1)
        )
        |> List.sum