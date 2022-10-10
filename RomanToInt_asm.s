.data
str1:   .string "III"
str2:   .string "LVIII"
str3:   .string "MCMXCIV"
space:  .byte 32
.text
main:
        la      a0, str1
        call    romanToInt
        call    printAns
        
        la      a0, str2
        call    romanToInt
        call    printAns
        
        la      a0, str3
        call    romanToInt
        call    printAns
        
        ret
romanToInt:
        addi    sp,sp,-448
        sw      s0,444(sp)      # store the value of saver register
        addi    s0,sp,448
        sw      a0,-436(s0)     #addr of s
        li      a5,1
        sw      a5,-132(s0)     #value['I']
        li      a5,5
        sw      a5,-80(s0)      #value['V']
        li      a5,10
        sw      a5,-72(s0)      #value['X']
        li      a5,50
        sw      a5,-120(s0)     #value['L']
        li      a5,100
        sw      a5,-156(s0)     #value['C']
        li      a5,500
        sw      a5,-152(s0)     #value['D'] #152 + 4*68(decimal value of 'D') = 424
        li      a5,1000
        sw      a5,-116(s0)     #value['M']
        sw      zero,-424(s0)   #value['\0'] = value[0] = 0
        sw      zero,-20(s0)    # sum = 0
        sw      zero,-24(s0)    # i = 0
        j       LOOP_END_CONDITION     #s[i] != '\0'
FOR_LOOP:
        lw      a5,-24(s0)      #a5 = i
        lw      a4,-436(s0)     #a4 = s
        add     a5,a4,a5        #a5 = &s[i]
        lbu     a5,0(a5)        #a5 = s[i]
        slli    a5,a5,2         #a5 = s[i]*4

        addi    a5,a5,-16       ##
        add     a5,a5,s0        #
        lw      a4,-408(a5)     ##a4 = value[0 + s[i]] = *(-424(s0) + s[i]*4)
        lw      a6,-24(s0)      #a6 = i
        addi    a6,a6,1         #a6 = i + 1
        lw      a3,-436(s0)     #a3 = &s
        add     a6,a3,a6        #a6 = &s[i + 1]
        lbu     a6,0(a6)        #a6 = s[i + 1]
        slli    a6,a6,2         #a6 = s[i + 1]*2
        addi    a6,a6,-16       ##
        add     a6,a6,s0        #
        lw      a6,-408(a6)     ##a6 = value[0 + s[i + 1]]
        bge     a4,a6,ELSE     # value[s[i]] >= value[s[i+1]]
        lw      a5,-20(s0)      #a5 = sum
        sub     a5,a5,a4
        sw      a5,-20(s0)
        j       INCRE_I
ELSE:
        lw      a5,-20(s0)      #a5 = sum
        add     a5,a4,a5        #a4 = value[s[i]], a5 = sum + value[s[i]]
        sw      a5,-20(s0)      #sum = a5
INCRE_I:
        lw      a5,-24(s0)      #a5 = i
        addi    a5,a5,1         #a5 = i + 1
        sw      a5,-24(s0)      #i = i + 1
LOOP_END_CONDITION:
        lw      a5,-24(s0)      #a5 = i
        lw      a4,-436(s0)     #a4 = &s
        add     a5,a4,a5        #a5 = &s[i]
        lbu     a5,0(a5)        #a5 = s[i]
        bne     a5,zero, FOR_LOOP #if(s[i]!='\0') goto for_loop
        lw      a5,-20(s0)      #a5 = sum
        mv      a0,a5           #a0 = sum
        lw      s0,444(sp)      #s0 restore
        addi    sp,sp,448       #sp restore
        jr      ra
printAns:
        addi    a7, x0, 1
        ecall
        la a0, space
        lbu a0, 0(a0)                # load the ascii value of ' ' in address of space
        addi a7, zero, 11
        ecall
        ret





