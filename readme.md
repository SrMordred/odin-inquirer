# Odin HTTP

A Terminal Inquirer for Odin inspired by Inquirers of other languages like Rust or javascript.

## Show And Tell
```odin

package example

import "core:fmt"
import "core:unicode/utf8"
import inquirer "../../odin-inquirer"

odin :: `              ;                              
       :      ED.                            
      t#,     E#Wi             L.            
     ;##W.    E###G.       t   EW:        ,ft
    :#L:WE    E#fD#W;      Ej  E##;       t#E
   .KG  ,#D   E#t t##L     E#, E###t      t#E
   EE    ;#f  E#t  .E#K,   E#t E#fE#f     t#E
  f#.     t#i E#t    j##f  E#t E#t D#G    t#E
  :#G     GK  E#t    :E#K: E#t E#t  f#E.  t#E
   ;#L   LW.  E#t   t##L   E#t E#t   t#K: t#E
    t#f f#:   E#t .D#W;    E#t E#t    ;#W,t#E
     f#D#;    E#tiW#G.     E#t E#t     :K#D#E
      G#t     E#K##i       E#t E#t      .E##E
       t      E##D.        E#t ..         G#E
              E#t          ,;.             fE
              L:                            ,`

main :: proc () {

    using inquirer

    Exec(Clear, SetCursor(0,0))

    pass := password(
        text = "Password: ",
    )

    name := question(
        text = "Whats your name: ",
    )

    brazil := confirm(
        text = "You live in Brazil ?",
    )

    fruit := select( 
        text = "Whats your favorite fruit? (single answer) ",
        options = {
            "Banana",
            "Apple",
            "Strawberry",
            "Grapes",
            "Lemon",
            "Tangerine",
            "Watermelon",
            "Orange",
            "Pear",
            "Avocado",
            "Pineapple",
        }
    )

    fruits := multiselect( 
        text = "Whats your favorite fruit? (multiple answers) ",
        options = {
            "Banana",
            "Apple",
            "Strawberry",
            "Grapes",
            "Lemon",
            "Tangerine",
            "Watermelon",
            "Orange",
            "Pear",
            "Avocado",
            "Pineapple",
        }
    )

    fmt.println()
    fmt.println("password = ", pass)
    fmt.println("name = ", name)
    fmt.println("Live in Brazil = ", brazil)
    fmt.println("fruit = ", fruit)
    fmt.println("fruits = ", fruits)
    fmt.println()

    for char, index in odin {
        r := index / 5 % 255
        b := (index / 5  ) % 255 + 100
        Exec( BGRGB(r,0,0), RGB(0,0,b), utf8.runes_to_string([]rune{char})  )
    }

    Exec(Reset)
}    
```

https://github.com/user-attachments/assets/8835fcdb-7db7-470b-bf0c-f65beb1d25d4






