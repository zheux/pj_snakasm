%include "game.mac"
%include "keyboard.mac"
%include "video.mac"

%ifndef FBUFFER
   %define FBUFFER 0xB8000
%endif

; Position for drawing the options's names
%define FIRSTBUFFER FBUFFER + 2 * (80 * 17 + 33)
%define SECONDBUFFER FIRSTBUFFER + 160
%define THIRDBUFFER SECONDBUFFER + 160
%define CURSOR 26 ;'->'

section .data
   ; Indicates selected option: 1 for Singleplayer, 2 for Multiplayer, 3 for About  (Default is 1)
   selected dd 1

   ; Snakasm ascii art
   logor1 db "                  _                      "
   logor2 db "                 | |                     "
   logor3 db "  ___ ____  _____| |  _ _____  ___ ____  "
   logor4 db " /___)  _ \(____ | |_/ |____ |/___)    \ "
   logor5 db "|___ | | | / ___ |  _ (/ ___ |___ | | | |"
   logor6 db "(___/|_| |_\_____|_| \_)_____(___/|_|_|_|"

   ; Options names
   single db "Single Player"
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

      ; Draw options
      paint_row single, 4 + FIRSTBUFFER, 13
      paint_row multi , 4 + SECONDBUFFER + 2, 11
      paint_row about , 4 + THIRDBUFFER + 8, 5

      ; Draw cursor to first option
      mov [FIRSTBUFFER], byte CURSOR
      ret

   global menu_input_handler
   menu_input_handler:
      pop ebx   ; save the call address and put the input keycode on word [esp]

      bind KEY.ENTER, keypress_enter
      bind KEY.UP, keypress_up
      bind KEY.DOWN, keypress_down

      push ebx  ; return stack to previous state
      ret

; Key Press Events:
   ; Handles enter button
   keypress_enter:
      ; Move to the menu selected
      ret

   ; Handles up button
   keypress_up:
      dec dword [selected]
      call check_selected
      call draw_cursor
      ret

   ; Handles down button
   keypress_down:
      inc dword [selected]
      call check_selected
      call draw_cursor
      ret

   check_selected:
      cmp dword [selected], 4
      je selected_overflow

      cmp dword [selected], 0
      je selected_carry

      jmp endcs
      selected_overflow:
         mov [selected], byte 1
         ret
      selected_carry:
         mov [selected], byte 3
         ret
      endcs:
      ret

   draw_cursor:
      ;Clear the cursor
      mov [FIRSTBUFFER], byte 0
      mov [SECONDBUFFER], byte 0
      mov [THIRDBUFFER], byte 0

      cmp byte [selected], 1
      je first_selected
      cmp byte [selected], 2
      je second_selected
      cmp byte [selected], 3
      je third_selected

      first_selected:
         mov [FIRSTBUFFER], byte CURSOR
         jmp end_drawcursor
      second_selected:
         mov [SECONDBUFFER], byte CURSOR
         jmp end_drawcursor
      third_selected:
         mov [THIRDBUFFER], byte CURSOR
         jmp end_drawcursor

      end_drawcursor:
      ret
