%include "keyboard.mac"
%include "game.mac"

section .data
   extern gamestate

section .text
   extern draw_map
   
   extern reset_snake
   extern draw_snake
   extern grow

   extern move_left
   extern move_right
   extern move_down
   extern move_up


   global game_input_handler
   game_input_handler:
      pop ebx

      bind KEY.LEFT, move_left
      bind KEY.RIGHT, move_right
      bind KEY.DOWN, move_down
      bind KEY.UP, move_up

      call draw_snake

      push ebx
      ret

   global start_new_singleplayer
   start_new_singleplayer:
      call draw_map
      call reset_snake
      call draw_snake
      ret
