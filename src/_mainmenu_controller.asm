
%define FBUFFER 0xB8000

section .text

;the value of the input is in word [esp + 2]
   global menu_input_handler
   menu_input_handler:
      mov [FBUFFER], byte 'a'
      ret
