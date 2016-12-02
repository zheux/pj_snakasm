section .text

   ;random(d min, d max)   Returns a random number in range [min, max)
   global random
   random:
      rdtsc
      shl edx, 7
      add edx, 3
      ror edx, 7
      xor eax, edx
      mov edx, eax
      rol edx, 7
      xor eax, edx

      xor edx, edx
      mov ecx, [esp + 8]
      div ecx
      mov eax, edx
      cmp eax, [esp + 4]
      jge .next
      add eax, [esp + 8]
      sub eax, [esp + 4]
      .next:
      ret
