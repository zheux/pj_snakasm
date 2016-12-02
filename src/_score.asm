%include "video.mac"
%include "game.mac"
%include "_score.mac"

section .data
   score dd 0
   scoretxt db "SCORE"
   highscoretxt db "HIGHSCORE"

section .text
   global draw_score
   draw_score:
      paint_row scoretxt, SCOREPOSITION, 5, GAME.FGCOLOR, GAME.BGCOLOR
      paint_row highscoretxt, SCOREPOSITION - COLS * 2 * 4 - 2 * 2, 9, GAME.FGCOLOR, GAME.BGCOLOR
      ret
