package input

import "core:os"
import "core:io"
import "core:strings"

get_line :: proc() -> (result: string) {
    reader := io.to_rune_reader(os.stream_from_handle(os.stdin))
    builder := strings.make_builder()

    for ch, _, err := io.read_rune(reader); ch != '\n'; ch, _, err = io.read_rune(reader) {
        strings.write_rune_builder(&builder, ch)
    }

    result = strings.to_string(builder)

    return result
}