package syntax_tree

import "core:fmt"
import "../tokens"

Node_Type :: enum {
    ADD,
    SUB,
    MUL,
    DIV,
    NUM,
}

Tree_Node :: struct {
    node_type: Node_Type,
    left: ^Tree_Node,
    right: ^Tree_Node,
    value: f64,
}

generate_tree :: proc(token_list: []tokens.Token, allocator := context.allocator) -> (root: ^Tree_Node) {
    for token in token_list {
        node := new(Tree_Node, allocator)

        #partial switch token.token_type {
            case .ADD:
                node.node_type = .ADD
            case .SUB:
                node.node_type = .SUB
            case .MUL:
                node.node_type = .MUL
            case .DIV:
                node.node_type = .DIV
            case .NUM:
                node.node_type = .NUM
                node.value = token.value
            case:
                panic("HELP")
        }

        tree_add_node(&root, node)
    }

    return root
}

tree_add_node :: proc(root: ^^Tree_Node, node: ^Tree_Node) {
    if root^ == nil {
        root^ = node
        return
    }

    #partial switch node.node_type {
        case .NUM:
            if root^.node_type != .NUM {
                if root^.left == nil {
                    root^.left = node
                } else if root^.right == nil {
                    root^.right = node
                } else {
                    panic("Node is full!")
                }
            } else {
                panic("Can't put a number in a number!")
            }
        case:
            node.left = root^
            root^ = node
    }
}

print_tree :: proc(root: ^Tree_Node, depth := 0) {
    for i := 0; i < depth; i += 1 {
        fmt.print("  ")
    }
    fmt.println(root)
    if root.left != nil {
        print_tree(root.left, depth + 1)
    }
    if root.right != nil {
        print_tree(root.right, depth + 1)
    }
}