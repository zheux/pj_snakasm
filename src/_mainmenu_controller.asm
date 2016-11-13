%include "game.mac"
%include "keyboard.mac"

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

section .text
   global draw_mainmenu
   draw_mainmenu:
      ;Draw mainmenu elements to fbuffer
      ret

; The value of the input is in word [esp + 6]
   global menu_input_handler
   menu_input_handler:
      pop eax   ; save the call address
      pop bx    ; save the game state var

      bind KEY.ENTER, keypress_enter
      bind KEY.UP, keypress_up
      bind KEY.DOWN, keypress_down

      push bx
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
