%include "_map.mac"
%include "_snake.mac"
%include "game.mac"
%include "video.mac"

%define FBUFFER 0xB8000

section .data
   ; Snake direction: 1down 2up 3left 4right
   direction db 3
   snake times MAP.COLS * MAP.ROWS dd 0
   snake_length dd 0


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



global reset_snake
   reset_snake:
      mov [snake], dword SNAKE.STARTPOSITION_HEAD
      mov [snake + 4], dword SNAKE.STARTPOSITION_TAIL
      mov [snake + 8], dword SNAKE.STARTPOSITION_TAIL - 160
      mov [snake_length], dword 3
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

global move_left
   move_left:
      push ebx

      erase_tail

      mov ebx, [snake]
      sub ebx, 2
      push ebx
      call validmove

      cmp eax, 0
      je .ret

      call update_tail
      mov [snake], ebx

      .ret:
      add esp, 4
      pop ebx
      ret

global move_right
   move_right:
      push ebx

      erase_tail

      mov ebx, [snake]
      add ebx, 2
      push ebx
      call validmove

      cmp eax, 0
      je .ret

      call update_tail
      mov [snake], ebx

      .ret:
      add esp, 4
      pop ebx
      ret

global move_up
   move_up:
      push ebx

      erase_tail

      mov ebx, [snake]
      sub ebx, 160
      push ebx
      call validmove

      cmp eax, 0
      je .ret

      call update_tail
      mov [snake], ebx

      .ret:
      add esp, 4
      pop ebx
      ret

global move_down
   move_down:
      push ebx

      erase_tail

      mov ebx, [snake]
      add ebx, 160
      push ebx
      call validmove

      cmp eax, 0
      je .ret

      call update_tail
      mov [snake], ebx

      .ret:
      add esp, 4
      pop ebx
      ret

global grow
   grow:
      inc dword [snake_length]
      ret

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

      .draw:
         mov edi, [esi]
         add esi, 4
         mov ax, SNAKE | FG.GRAY | BG.GREEN
         mov [edi], ax
         loop .draw

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
