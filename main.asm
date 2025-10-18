.include "macros.asm"
.include "arrays.asm"

.text
.globl main

main:
    li a7, 4
    la a0, prompt_num
    ecall

    INPUT_NUMBER(t0)
    CHECK_INPUT_NUMBER(t1, t0)
    beq zero, t1, Invalid_input
    la t2, N
    sw t0, 0(t2)
    
    # Сохраняем длину массива в сохраняемом регистре перед вызовом макросов
    mv s1, t0              # s1 = длина массива (сохраняемый регистр)
    
	ALLOC_STACK_ARRAY(s2, s1)  # t0 = адрес массива из 10 элементов
	FILL_ARRAY(s2, s1)
	li a7, 4
    la a0, A_msg
    ecall
    PRINT_ARRAY(s2, s1)
    EXIT_PROGRAM

Invalid_input:
    li a7, 4
    la a0, invalid_input_message
    ecall
    EXIT_PROGRAM

.data
prompt_num:   .string "Введите длину массива: "
invalid_input_message: .string "Ошибка! Массив может иметь длину только от 1 до 10."
A_msg: "A: "
B_msg: "B: "
N: .word 0
