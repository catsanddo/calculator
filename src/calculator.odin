package calculator

import "core:fmt"
import "input"
import "tokens"
import st "syntax_tree"

main :: proc() {
    source := input.get_line()
    tokens := tokens.tokenize(source)
    tree := st.generate_tree(tokens)
    st.print_tree(tree)
}