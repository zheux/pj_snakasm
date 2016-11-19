%include "video.mac"
%include "game.mac"
%include "_map.mac"


section .text
   global draw_map
   draw_map:
      push edi
      push ebx
      push ecx

      cld
      mov ax, 0 | FG.MAGENTA | BG.BLACK

      mov ecx, MAP.COLS
      mov edi, MAP.TOPLEFT
      rep stosw

      mov ecx, MAP.COLS
      mov edi, MAP.TOPLEFT + COLS * 2 * (MAP.ROWS - 1)
      rep stosw

      mov ecx, MAP.ROWS
      mov edi, MAP.TOPLEFT
      .drawcolsleft:
         stosw
         add edi, 160
         sub edi, 2
         loop .drawcolsleft

      mov ecx, MAP.ROWS
      mov edi, MAP.TOPLEFT + MAP.COLS * 2
      .drawcolsright:
         stosw
         add edi, 160
         sub edi, 2
         loop .drawcolsright

      pop ecx
      pop ebx
      pop edi
      xor eax, eax
      ret
