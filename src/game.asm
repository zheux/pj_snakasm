%include "video.mac"
%include "keyboard.mac"
%include "game.mac"


section .data
    gamestate db 1

section .text

extern clear
extern scan
extern calibrate

extern draw_mainmenu
extern menu_input_handler


global game
game:
   ; Initialize game

   FILL_SCREEN BG.BRIGHT

   ; Draw Main Menu
   call draw_mainmenu

   ; Calibrate the timing
   call calibrate

   ; Snakasm main loop
   game.loop:
      .input:
      call get_input

      ; Main loop.

      ; Here is where you will place your game logic.
      ; Develop procedures like paint_map and update_content,
      ; declare it extern and use here.

      jmp game.loop


draw.red:
   FILL_SCREEN BG.RED
   ret

draw.green:
   FILL_SCREEN BG.GREEN
   ret


get_input:
   call scan
   push ax
   ; The value of the input is in 'word [esp]'

   ; Handle input if on the mainmenu
   bind_state 1, menu_input_handler

   add esp, 2  ; free the stack
   ret
