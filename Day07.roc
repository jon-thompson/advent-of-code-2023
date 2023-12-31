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
        cardValue
        getType

    out == 
        [ { cards: "32T3K", bid: 765 }
        , { cards: "KTJJT", bid: 220 }
        , { cards: "KK677", bid: 28 }
        , { cards: "T55J5", bid: 684 }
        , { cards: "QQQJA", bid: 483 }
        ]

sortByRank : List Hand, (Str -> Nat), (Hand -> Type) -> List Hand
sortByRank = \hands, cardValuer, getTypeD ->
    hands
        |> List.sortWith (\a, b ->
            aTypeRank = List.findFirstIndex types (\t -> t == getTypeD a) |> Result.withDefault 0
            bTypeRank = List.findFirstIndex types (\t -> t == getTypeD b) |> Result.withDefault 0

            when Num.compare aTypeRank bTypeRank is 
                GT -> GT
                LT -> LT
                EQ -> 
                    List.map2 (Str.graphemes a.cards) (Str.graphemes b.cards) Pair
                        |> List.findFirst (\pair ->
                            when pair is
                                Pair aCard bCard ->
                                    aCard != bCard
                        )
                        |> Result.map (\pair ->
                            when pair is
                                Pair aCard bCard ->
                                    Num.compare (cardValuer aCard) (cardValuer bCard)
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
        |> sortByRank cardValue getType
        |> List.mapWithIndex (\hand, index ->
            hand.bid * (index + 1)
        )
        |> List.sum


expect
    out = getTypeWithJokers { cards: "KTJJT", bid: 765 }

    out == FourOfAKind

getTypeWithJokers : Hand -> Type
getTypeWithJokers = \hand ->
    countsByCard =
        hand.cards
            |> Str.graphemes
            |> List.walk (Dict.empty {}) (\dict, card ->
                Dict.update dict card (\possibleCount ->
                    when possibleCount is
                        Missing -> Present 1
                        Present count -> Present (count + 1)
                )
            )

    jokerCount = Dict.get countsByCard "J" |> Result.withDefault 0

    countsByCardWithoutJokers =
        Dict.remove countsByCard "J"

    counts =
        countsByCardWithoutJokers
            |> Dict.values
            |> List.sortDesc

    countsWithJokers =
        if List.isEmpty counts then
            [jokerCount]
        else
            List.update counts 0 (\count -> count + jokerCount)

    when countsWithJokers is
        [1, 1, 1, 1, 1] -> HighCard
        [2, 1, 1, 1] -> OnePair
        [2, 2, 1] -> TwoPair
        [3, 1, 1] -> ThreeOfAKind
        [3, 2] -> FullHouse
        [4, 1] -> FourOfAKind
        [5] -> FiveOfAKind
        _ -> HighCard
    
expect
    out = cardValueWithJoker "J"

    out == 1


cardValueWithJoker : Str -> Nat
cardValueWithJoker = \card ->
    when card is
        "A" -> 14
        "K" -> 13
        "Q" -> 12
        "J" -> 1
        "T" -> 10
        _ -> Str.toNat card |> Result.withDefault 0

expect
    out = part2 sample

    out == 5905

part2 : Str -> Nat
part2 = \str ->
    str
        |> Str.split "\n"
        |> List.map parseHand
        |> sortByRank cardValueWithJoker getTypeWithJokers
        |> List.mapWithIndex (\hand, index ->
            hand.bid * (index + 1)
        )
        |> List.sum


expect
    out = part2 puzzle

    out == 250057090

expect
    out = sortByRank 
        [ { cards: "32T3K", bid: 765 }
        , { cards: "T55J5", bid: 684 }
        , { cards: "KK677", bid: 28 }
        , { cards: "KTJJT", bid: 220 }
        , { cards: "QQQJA", bid: 483 }
        ]
        cardValueWithJoker
        getTypeWithJokers

    out == 
        [ { cards: "32T3K", bid: 765 }
        , { cards: "KK677", bid: 28 }
        , { cards: "T55J5", bid: 684 }
        , { cards: "QQQJA", bid: 483 }
        , { cards: "KTJJT", bid: 220 }
        ]

expect
    out = getTypeWithJokers { cards: "JJJJJ", bid: 765 }

    out == FiveOfAKind