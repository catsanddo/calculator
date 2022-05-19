package calculator

import "core:fmt"
import "input"
import "tokens"
import st "syntax_tree"

main :: proc() {
    foo := input.get_line()
    tokens := tokens.tokenize(foo)
    for elem in tokens {
        fmt.println(elem)
    }
}