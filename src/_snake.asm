%include "_map.mac"
%include "_snake.mac"
%include "game.mac"
%include "video.mac"

%define FBUFFER 0xB8000

section .data
   ; Snake direction: 1down 2up 3left 4right
   direction db 3

   global snake
   global snake_length
   snake times MAP.COLS * MAP.ROWS dd 0
   snake_length dd 1


section .text
   extern to_ij


   %macro erase_tail 0
      push ebx
      push eax

      mov ebx, [snake_length]
      shl ebx, 2
      sub ebx, 4
      add ebx, snake
      mov eax, [ebx]
      mov bx, 0 | BG.BRIGHT
      mov [eax], bx

      pop eax
      pop ebx
   %endmacro

   ;%1: address of snake to move    %2: direction  -2-left 2-right 160-down   -160-up
   %macro move_snake 2
      mov ebx, [%1]
      add ebx, %2
      push ebx
      call validmove
      add esp, 4

      cmp eax, 0
      je %%next

      call update_tail
      mov [%1], ebx
      %%next:
   %endmacro


;reset_snake(d snake_address, d snake_length_address, d address_in_fbuffer) just put a 3-length snake top
;to bottom starting at "address_in_fbuffer"
global reset_snake
   reset_snake:
      init_func

      cld

      mov eax, [ebp + 16]
      mov edi, [ebp + 8]
      stosd

      ;reset the snake body (snake length = ecx + 1)
      mov ecx, 2
      .reset_body:
         add eax, 160
         stosd
         loop .reset_body

      ;move to snake_length_address the new length
      mov eax, 3
      mov edi, [ebp + 12]
      stosd

      end_func
      ret


   ; validmove(int fbufferposition)  return whether the position is in the map (true 1 or false 0)

global validmove
   validmove:
      init_func

      xor eax, eax
      push dword [ebp + 8]
      sub dword [esp], FBUFFER
      call to_ij
      add esp, 4

      cmp ah, MAP.BOUND_UP
      jl .false
      cmp ah, MAP.BOUND_DOWN
      jg .false

      cmp al, MAP.BOUND_LEFT
      jl .false
      cmp al, MAP.BOUND_RIGHT
      jg .false

      mov eax, 1
      jmp .ret

      .false:
      xor eax, eax

      .ret:
      end_func
      ret


;Snake Movement
global move_left
   move_left:
      push ebx
      erase_tail
      move_snake snake, -2
      pop ebx
      ret

global move_right
   move_right:
      push ebx
      erase_tail
      move_snake snake, 2
      pop ebx
      ret

global move_up
   move_up:
      push ebx
      erase_tail
      move_snake snake, -160
      pop ebx
      ret

global move_down
   move_down:
      push ebx
      erase_tail
      move_snake snake, 160
      pop ebx
      ret

;Snake Length
global grow
   grow:
      inc dword [snake_length]
      ret


;This goes in video.asm
global draw_snake
   draw_snake:
      init_func
      push edi
      push esi

      mov ecx, [snake_length]
      dec ecx
      mov esi, snake

      ;Draw head with different colors
      mov edi, [esi]
      add esi, 4
      mov ax, SNAKE | FG.MAGENTA | BG.BLUE
      mov [edi], ax

      .drawbody:
         mov edi, [esi]
         add esi, 4
         mov ax, SNAKE | FG.GRAY | BG.GREEN
         mov [edi], ax
         loop .drawbody

      pop esi
      pop edi
      end_func
      ret

   update_tail:
      init_func
      push edi
      push esi
      push ebx
      push ecx

      mov ecx, [snake_length]
      dec ecx

      mov edi, snake

      mov ebx, [snake_length]
      shl ebx, 2
      sub ebx, 4
      add edi, ebx

      mov esi, edi
      sub esi, 4

      std
      rep movsd

      pop ecx
      pop ebx
      pop esi
      pop edi
      end_func
      ret
