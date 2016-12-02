%include "keyboard.mac"
%include "game.mac"
%include "_map.mac"
%include "video.mac"

section .data
   extern gamestate

   extern snake
   extern snake_length

section .text
   extern draw_map
   extern draw_score

   extern reset_snake
   extern draw_snake
   extern grow

   extern move_left
   extern move_right
   extern move_down
   extern move_up


   ;%1: snake_address   %2:snake_length_address
   %macro reset_snake_to_map 2
      push dword MAP.TOPLEFT + COLS * 2 * (MAP.ROWS / 2) + 2 * (MAP.COLS / 2)
      push %2
      push %1
      call reset_snake
      add esp, 12
   %endmacro


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
      call draw_score
      reset_snake_to_map snake, snake_length
      call draw_snake
      ret
