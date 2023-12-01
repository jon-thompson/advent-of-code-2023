app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

main =
    Stdout.line "I'm a Roc application!"



# Day 1

line : Str -> U8
line = \str ->
    12

expect
    out = line "1abc2"
    
    out == 12