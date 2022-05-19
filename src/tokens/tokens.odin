package tokens

import "core:io"
import "core:strings"
import "core:strconv"
import "core:fmt"

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

tokenize :: proc(source: string, allocator := context.allocator) -> []Token {
    tokens := make([dynamic]Token, allocator)
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