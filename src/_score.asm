%include "video.mac"

%define SCOREPOS 0xB8000 + COLS * 2 * 5 + 2 * 5
%define HIGHSCOREPOS SCOREPOS + COLS * 2 * 3 - 2 * 2

section .data
   current_score dd 100000
   score_list times 10 dd 100
   next_p dd 0

   score_lbl db "SCORE", 0
   highscore_lbl db "HIGHSCORE", 0

   void db "          ", 0

   extern output

section .text
   global reset_score
   reset_score:
      mov [current_score], dword 0
      ret

   global draw_scoreboard
   draw_scoreboard:
      paint_row score_lbl, SCOREPOS, 5, GAME.BGCOLOR, GAME.FGCOLOR
      paint_row highscore_lbl, HIGHSCOREPOS, 11, GAME.BGCOLOR, GAME.FGCOLOR
      draw_dec dword [score_list], HIGHSCOREPOS + COLS * 2 * 1, 6
      call update_score
      ret

   global earn_score
   earn_score:
      push ebp
      mov ebp, esp

      mov eax, [ebp + 8]
      add [current_score], eax

      mov esp, ebp
      pop ebp
      ret

   global update_score
   update_score:
      draw_dec dword [current_score], SCOREPOS + COLS * 2 * 1, 6
      ret

   ;add current score as highscore
   global add_highscore
   add_highscore:

      ret
