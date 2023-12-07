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
            if a.bid > b.bid then 
                GT
            else
                LT
        )
