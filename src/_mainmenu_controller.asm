%include "game.mac"
%include "keyboard.mac"
%include "video.mac"

%ifndef FBUFFER
   %define FBUFFER 0xB8000
%endif

; Position for drawing the options's names
%define FIRSTBUFFER FBUFFER + 2 * (80 * 17 + 35)
%define SECONDBUFFER FIRSTBUFFER + 160
%define THIRDBUFFER SECONDBUFFER + 160

section .data
   ; Indicates selected option: 1 for Singleplayer, 2 for Multiplayer, 3 for About  (Default is 1)
   cursor db 1

   ; Snakasm ascii art
   logor1 db "                  _                      "
   logor2 db "                 | |                     "
   logor3 db "  ___ ____  _____| |  _ _____  ___ ____  "
   logor4 db " /___)  _ \(____ | |_/ |____ |/___)    \ "
   logor5 db "|___ | | | / ___ |  _ (/ ___ |___ | | | |"
   logor6 db "(___/|_| |_\_____|_| \_)_____(___/|_|_|_|"

   ; Options names
   single db "Singleplayer"
   multi db "Multiplayer"
   about db "About"


section .text
   global draw_mainmenu
   draw_mainmenu:
      ;Draw mainmenu elements to fbuffer

      ; Draw snakasm ascii art
      paint_row logor1, FBUFFER + COLS * 2 * 7 + 40 + 160 * 0, 41
      paint_row logor2, FBUFFER + COLS * 2 * 7 + 40 + 160 * 1, 41
      paint_row logor3, FBUFFER + COLS * 2 * 7 + 40 + 160 * 2, 41
      paint_row logor4, FBUFFER + COLS * 2 * 7 + 40 + 160 * 3, 41
      paint_row logor5, FBUFFER + COLS * 2 * 7 + 40 + 160 * 4, 41
      paint_row logor6, FBUFFER + COLS * 2 * 7 + 40 + 160 * 5, 41
      ret

   global menu_input_handler
   menu_input_handler:
      pop eax   ; save the call address and puts input on word [esp]

      bind KEY.ENTER, keypress_enter
      bind KEY.UP, keypress_up
      bind KEY.DOWN, keypress_down

      push eax  ; return stack to previous state
      ret

; Key Press Events:
   ; Handles enter button
   keypress_enter:
      ; Move to the menu selected
      ret

   ; Handles up button
   keypress_up:
      ret

   ; Handles down button
   keypress_down:
      ret
