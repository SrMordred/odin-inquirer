package inquirer

import "core:fmt"
import "core:strings"

Question :: struct {
    text: string
}

Password :: struct {
    text: string
}

Confirm :: struct {
    text: string
}

Select :: struct {
    text: string,
    options: []string,
    option_index: uint
}

MultiSelect :: struct {
    text: string,
    options: []string,
    multiselect: []bool,
    option_index: uint
}

LightseaGreen := RGB( 32,178,170 )
Gray := RGB(128,128,128)

make_question :: proc ( text : string ) -> Question {
    return Question {
        text = text
    }
}

question :: proc ( text : string, allocator := context.allocator ) -> string {
    self := make_question( text )
    return exec(self, allocator)
}

exec_question :: proc( self: Question, allocator := context.allocator ) -> string {
    Exec( Green ,"? ", Gray , self.text, LightseaGreen, SaveCursor )
    response_string := strings.builder_make(allocator)
    for {
        c := terminal_input()
        input_editor_handler(&response_string, c)
        #partial switch value in c {
            case Enter: 
                Exec("\n", ShowCursor, Reset)
                response := strings.to_string(response_string)
                return response
        }
        response := strings.to_string(response_string)
        Exec( LoadCursor , response , ClearLineEnd )
    }
}


make_confirm :: proc ( text : string ) -> Confirm {
    return Confirm {
        text = text
    }
}

confirm :: proc ( text : string, allocator := context.allocator ) -> bool {
    self := make_confirm( text )
    return exec(self, allocator)
}

exec_confirm :: proc( self: Confirm, allocator := context.allocator ) -> bool {

    Exec( Green ,"? ", Gray , self.text, " (y/n) " , LightseaGreen, SaveCursor )
    response_string := strings.builder_make(allocator)

    for {
        c := terminal_input()
        input_editor_handler(&response_string, c)
        #partial switch value in c {
            case Enter: 
                response := strings.to_string(response_string)
                response_lower := strings.to_lower(response, allocator)
                defer delete(response_lower, allocator)

                if index, _ := strings.index_multi( response_lower, {"yes", "y"} ); index != -1 {
                    Exec("\n", ShowCursor, Reset)
                    return true
                }
                if index, _ := strings.index_multi( response_lower, {"no", "n"} ); index != -1 {
                    Exec("\n", ShowCursor, Reset)
                    return false
                }
        }
        response := strings.to_string(response_string)
        Exec( LoadCursor , response , ClearLineEnd )
    }
}


make_password :: proc ( text : string ) -> Password {
    return Password {
        text = text
    }
}

password :: proc ( text : string, allocator := context.allocator ) -> string {
    self := make_password( text )
    return exec(self, allocator)
}

exec_password :: proc( self: Password, allocator := context.allocator ) -> string {

    response_string := strings.builder_make( allocator )

    Exec( Green ,"? ", Gray , self.text, LightseaGreen, Flush )
    for {
        c := terminal_input()
        input_editor_handler(&response_string, c)
        #partial switch value in c {
            case Enter:
                Exec("\n", ShowCursor, Reset)
                response := strings.to_string(response_string)
                return response
        }
    }
    response := strings.to_string(response_string)
    return response
}


make_select :: proc ( text : string, options:[]string ) -> Select {
    return Select {
        text = text,
        options = options,
    }
}

select :: proc ( text : string, options:[]string, allocator := context.allocator ) -> string {
    self := make_select( text, options )
    return exec(self, allocator)
}

exec_select :: proc( self: Select, allocator := context.allocator ) -> string {
    self := self
    Exec( HideCursor, Green ,"? ", Gray , self.text, LightseaGreen, "\n" )
    for{
        for option, index in self.options {
            if uint(index) == self.option_index {
                Exec(LightseaGreen,"> ", Gray, option, "\n" )
            } else {
                Exec("  ", Gray, option, "\n" )
            }
        }
        Exec(ClearEnd)
        c := terminal_input()
        #partial switch value in c {
            case Up: 
                self.option_index = ( len( self.options ) + (self.option_index - 1)) % len( self.options ) 
            case Down: 
                self.option_index = (self.option_index + 1) % len( self.options ) 
            case Enter: 
                Exec("\n", ShowCursor, Reset)
                return self.options[self.option_index]
        }
        Exec( CursorUp( len(self.options) ) )
    }
}


make_multiselect :: proc ( text : string, options:[]string, allocator := context.allocator ) -> MultiSelect {
    return MultiSelect {
        text = text,
        options = options,
        multiselect = make([]bool, len(options))
    }
}

multiselect :: proc ( text : string, options:[]string, allocator := context.allocator ) -> []string {
    self := make_multiselect( text, options )
    return exec(self, allocator)
}

exec_multiselect :: proc( self: MultiSelect, allocator := context.allocator ) -> []string {
    self := self
    selected_len := 0
    Exec( HideCursor, Green ,"? ", Gray , self.text, LightseaGreen, "\n" )
    loop2: for{
        for option, index in self.options {
            if uint(index) == self.option_index {
                Exec(LightseaGreen,"> ")
            } else {
                Exec(LightseaGreen,"  ")
            }
            
            selected := "x" if self.multiselect[index] else " "
            Exec(Green, "[", selected , "] ", Gray, " ", option, "\n")
        }
        Exec(ClearEnd)
        c := terminal_input()

        #partial switch value in c {
            case Up: 
                self.option_index = ( len( self.options ) + (self.option_index - 1)) % len( self.options ) 
            case Down: 
                self.option_index = (self.option_index + 1) % len( self.options ) 
            case Enter: 
                Exec(ShowCursor, Reset)

                results := make([]string, selected_len, allocator)
                counter := 0
                for selected, index in self.multiselect {
                    if selected {
                        results[counter] = self.options[index]
                        counter+=1 
                    }
                }
                return results

            case Char: 
                if value == KeySpace {
                    if !self.multiselect[self.option_index] {
                        self.multiselect[self.option_index] = true    
                        selected_len+=1
                    } else {
                        self.multiselect[self.option_index] = false    
                        selected_len-=1
                    }
                }
        }
        Exec( CursorUp( len(self.options) ) )
    }
}

exec :: proc {
    exec_question,
    exec_confirm,
    exec_password,
    exec_select,
    exec_multiselect,
}