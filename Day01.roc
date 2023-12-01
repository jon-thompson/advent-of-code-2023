app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout
    , "./Day01.txt" as input : Str]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"



# Day 1

line : Str -> U128
line = \str ->
    chars = Str.graphemes str

    digits = List.keepOks chars Str.toU128

    first = List.first digits |> Result.withDefault 0

    last = List.last digits |> Result.withDefault 0

    first * 10 + last

expect
    out = line "1abc2"
    
    out == 12

expect
    out = line "pqr3stu8vwx"
    
    out == 38

expect
    out = line "a1b2c3d4e5f"
    
    out == 15

expect
    out = line "treb7uchet"
    
    out == 77


multiline : Str -> U128
multiline = \str ->
    str
        |> Str.split "\n"
        |> List.map line
        |> List.sum


expect
    out = multiline "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
    
    out == 142

expect
    out = multiline input
    
    out == 55816



lineWithWords : Str -> U128
lineWithWords = \str ->
    str
        |> Str.graphemes
        |> List.walk "" (\char, s -> 
            Str.concat char s
                |> replaceDigitNames
        )
        |> line


replaceDigitNames : Str -> Str
replaceDigitNames = \str ->
    str
        |> Str.replaceFirst "one" "1"
        |> Str.replaceFirst "two" "2"
        |> Str.replaceFirst "three" "3"
        |> Str.replaceFirst "four" "4"
        |> Str.replaceFirst "five" "5"
        |> Str.replaceFirst "six" "6"
        |> Str.replaceFirst "seven" "7"
        |> Str.replaceFirst "eight" "8"
        |> Str.replaceFirst "nine" "9"

expect
    out = lineWithWords "eighthree"

    out == 83

expect 
    out = lineWithWords "two1nine"
    
    out == 29

multilineWithWords : Str -> U128
multilineWithWords = \str ->
    str
        |> Str.split "\n"
        |> List.map lineWithWords
        |> List.sum

expect 
    out = multilineWithWords "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen"
    
    out == 281

expect 
    out = "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen"

        |> Str.split "\n"
        |> List.map lineWithWords
    
    out == [29, 83, 13, 24, 42, 14, 76]