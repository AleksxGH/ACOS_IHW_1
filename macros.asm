.macro INPUT_NUMBER (%reg)
    li a7, 5              # syscall для чтения числа
    ecall
    mv %reg, a0           # сохраняем введённое число в регистр
.end_macro


.macro CHECK_INPUT_NUMBER (%result_reg, %number_reg)
    li t3, 1              # минимальное значение
    li t4, 10             # максимальное значение

    blt %number_reg, t3, invalid_input
    bgt %number_reg, t4, invalid_input

    li %result_reg, 1     # корректно
    j end_check

invalid_input:
    li %result_reg, 0     # некорректно

end_check:
.end_macro


.macro EXIT_PROGRAM
	li a7, 10   # 10 — код системного вызова "exit"
	ecall       # вызываем системный вызов
.end_macro
