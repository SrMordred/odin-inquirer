#+build windows
package inquirer

import w "core:sys/windows"
import "core:fmt"

console_handle: w.HANDLE = w.GetStdHandle(w.STD_INPUT_HANDLE)
events_len: w.DWORD 
input_buffer: [128]w.INPUT_RECORD

@(init)
_init :: proc () {
    terminal_input() // @NOTE: program starts with some input, so calling this here cleans it
}

_terminal_input :: proc () -> Key {

    if console_handle == w.INVALID_HANDLE_VALUE {
        return nil;
    }
    for {
        if (w.ReadConsoleInputW(console_handle, &input_buffer[0], 128, &events_len)) {
            for i:= 0; i < int(events_len); i+=1 {
                if (input_buffer[i].EventType == .KEY_EVENT) {
                    keyEvent: w.KEY_EVENT_RECORD = input_buffer[i].Event.KeyEvent;
                    if !keyEvent.bKeyDown do continue
                    switch keyEvent.uChar.AsciiChar {
                        case 33 ..=126: return Char(keyEvent.uChar.AsciiChar)
                        case KeyEnter: {
                            return Enter(KeyEnter)
                        }
                        case KeySpace: return Char(keyEvent.uChar.AsciiChar)
                        case KeyBackspace: return Backspace(KeyBackspace)
                    }

                    switch keyEvent.wVirtualKeyCode {
                        case KeyLeft: return Left(KeyLeft)
                        case KeyUp: return Up(KeyUp)
                        case KeyDown: return Down(KeyDown)
                        case KeyRight: return Right(KeyRight)
                    }
                }
            }
            return nil
        }
    }
    return nil
}
