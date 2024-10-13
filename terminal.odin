package inquirer

import "core:strings"
import "core:fmt"
import "core:os"

// Terminal Only related code

// ASCII ESCAPE CODES

Black :: "\u001b[30m"
Red :: "\u001b[31m"
Green :: "\u001b[32m"
Yellow :: "\u001b[33m"
Blue :: "\u001b[34m"
Magenta :: "\u001b[35m"
Cyan :: "\u001b[36m"
White :: "\u001b[37m"

BGBlack :: "\u001b[40m"
BGRed :: "\u001b[41m"
BGGreen :: "\u001b[42m"
BGYellow :: "\u001b[43m"
BGBlue :: "\u001b[44m"
BGMagenta :: "\u001b[45m"
BGCyan :: "\u001b[46m"
BGWhite :: "\u001b[47m"

Clear:: "\u001b[2J"
ClearStart:: "\u001b[1J"
ClearEnd:: "\u001b[0J"

Bold :: "\u001b[1m"
Underline :: "\u001b[4m"
Blink :: "\u001b[5m"

ClearLineEnd :: "\u001b[0K"
ClearLineStart :: "\u001b[1K"
ClearLine :: "\u001b[2K"

SaveCursor :: "\u001b7"
LoadCursor :: "\u001b8"

HideCursor :: "\e[?25l"
ShowCursor :: "\e[?25h"
Reversed :: "\u001b[7m"

Reset :: "\u001b[0m"
Flush :: "\u001b"

// DYNAMIC ESCAPE CODES
CursorUp :: proc( n: int ) -> string {
    return fmt.tprintf( "\u001b[%iA", n )
}

CursorDown :: proc( n: int ) -> string {
    return fmt.tprintf( "\u001b[%iB", n )
}

CursorRight :: proc( n: int ) -> string {
    return fmt.tprintf( "\u001b[%iC", n )
}

CursorLeft :: proc( n: int ) -> string {
    return fmt.tprintf( "\u001b[%iD", n )
}

RGB :: proc( r,g,b: int ) -> string {
    return fmt.tprintf("\u001b[38;2;%i;%i;%im", r, g, b)
} 

BGRGB :: proc( r,g,b: int ) -> string {
    return fmt.tprintf("\u001b[48;2;%i;%i;%im", r, g, b)
} 

SetCursor :: proc( x,y :int ) -> string {
    return fmt.tprintf( "\u001b[%d;%dH",x,y )
}

SetCursorCol :: proc( x :int ) -> string {
    return fmt.tprintf( "\u001b[%d",x )
}

NextLine :: proc( n: int ) -> string {
    return fmt.tprintf("\u001b[%dE", n)
} 
PrevLine :: proc( n: int ) -> string {
    return fmt.tprintf("\u001b[%dF", n)
} 

// RUN COMMANDS
Exec :: proc( commands: ..string ) {
    for cmd in commands {
        os.write_string(os.stdout, cmd)
    }
}

// Helpers for handling input

KeyBackspace :: 8
KeyEnter :: 13
KeyUp :: 38
KeyDown :: 40
KeyLeft :: 37
KeyRight :: 39
KeySpace :: 32

Char :: u8
Backspace :: distinct u8
Left :: distinct u8
Up :: distinct u8
Right :: distinct u8
Down :: distinct u8
Enter :: distinct u8

Key :: union {
    Char,
    Backspace,
    Left,
    Up,
    Right,
    Down,
    Enter
}

input_editor_handler :: proc( input: ^strings.Builder, value: Key ) {
    #partial switch v in value {
        case Char: strings.write_byte(input, u8(v))
        case Backspace: strings.pop_byte(input)
    }
}

terminal_input :: proc () -> Key {
    return _terminal_input()
}
