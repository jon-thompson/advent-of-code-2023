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


Race : { time : Nat, recordDistance : Nat }

parseRaces : Str -> List Race
parseRaces = \str ->
    numberLines =
        str
            |> Str.split "\n"
            |> List.map parseNumbers

    times = 
        numberLines
            |> List.first
            |> Result.withDefault []


    recordDistances = 
        numberLines
            |> List.last
            |> Result.withDefault []

    List.map2 times recordDistances (\time, recordDistance ->
        { time, recordDistance })


expect
    out = parseRaces sample
    
    out == 
        [ { time: 7, recordDistance: 9 }
        , { time: 15, recordDistance: 40 }
        , { time: 30, recordDistance: 200 }
        ]

countWaysToBeatRecord : Race -> Nat
countWaysToBeatRecord = \race ->
    List.range { start: At 1, end: Before race.time }
        |> List.walk 0 (\count, timeToHold ->
            speed = timeToHold
            timeToRace = race.time - timeToHold
            distance = speed * timeToRace

            if distance > race.recordDistance
            then count + 1
            else count
        )

expect
    out = countWaysToBeatRecord { time: 7, recordDistance: 9 }

    out == 4


part1 : Str -> Nat
part1 = \str ->
    str
        |> parseRaces
        |> List.map countWaysToBeatRecord
        |> List.product

expect 
    out = part1 sample

    out == 288