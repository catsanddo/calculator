package calculator

import "core:fmt"
import "core:os"
import "core:io"
import "core:strings"
import "core:strconv"

Token_Type :: enum {
    OPEN_PAREN,
    CLOSE_PAREN,
    ADD,
    SUB,
    MUL,
    DIV,
    POW,
    NUM,
}

Token :: struct {
    token_type: Token_Type,
    value: f64,
}

get_line :: proc() -> (result: string) {
    reader := io.to_rune_reader(os.stream_from_handle(os.stdin))
    builder := strings.make_builder()

    for ch, _, err := io.read_rune(reader); ch != '\n'; ch, _, err = io.read_rune(reader) {
        strings.write_rune_builder(&builder, ch)
    }

    result = strings.to_string(builder)

    return result
}

tokenize :: proc(source: string) -> []Token {
    tokens := make([dynamic]Token)
    reader: strings.Reader

    strings.reader_init(&reader, source)
    r: rune
    err: io.Error
    for {
        r, _, err = strings.reader_read_rune(&reader)
        if err == .EOF do break
        switch r {
            case '(':
                append_elem(&tokens, Token{.OPEN_PAREN, 0})
            case ')':
                append_elem(&tokens, Token{.CLOSE_PAREN, 0})
            case '+':
                append_elem(&tokens, Token{.ADD, 0})
            case '-':
                append_elem(&tokens, Token{.SUB, 0})
            case '*':
                append_elem(&tokens, Token{.MUL, 0})
            case '/':
                append_elem(&tokens, Token{.DIV, 0})
            case '.':
                fallthrough
            case '0'..'9':
                strings.reader_unread_rune(&reader)
                num := swallow_number(&reader)
                append_elem(&tokens, Token{.NUM, num})
            case ' ':
            case:
                error_msg := fmt.tprintf("Couldn't tokenize '%v' at %v", r, reader.i-1)
                panic(error_msg)
        }
    }

    return tokens[:]
}

swallow_number :: proc(reader: ^strings.Reader) -> (num: f64) {
    builder := strings.make_builder(context.temp_allocator)

    r: rune
    err: io.Error
    end := false
    for {
        if end do break
        r, _, err = strings.reader_read_rune(reader)
        if err == .EOF do break
        switch r {
            case '.':
                fallthrough
            case '0'..'9':
                strings.write_rune_builder(&builder, r)
            case:
                strings.reader_unread_rune(reader)
                end = true
        }
    }

    num = strconv.atof(strings.to_string(builder))

    return num
}

main :: proc() {
    foo := "(5  +6/7*4-  5(a))"
    tokens := tokenize(foo)
    for elem in tokens {
        fmt.println(elem)
    }
}