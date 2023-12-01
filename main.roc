app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"



# Day 1

line : Str -> U8
line = \str ->
    chars = Str.graphemes str

    digits = List.keepOks chars Str.toU8

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


multiline : Str -> U8
multiline = \str ->
    142

expect
    out = multiline "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
    
    out == 142