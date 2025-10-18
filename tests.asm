.include "macros.asm"
.include "arrays.asm"

.text

tests:
    #Тест 1: минимальный элемент в середине
    la t0, test1
    li t1, 5                  # длина массива
    PRINT_ARRAY(t0, t1)       # выводим исходный массив

    CREATE_B_FROM_A(t0, t1, t5)
    PRINT_ARRAY(t5, t1)       # выводим массив B после перестановки

    #Тест 2: минимальный элемент первый
    la t0, test2
    li t1, 5
    PRINT_ARRAY(t0, t1)

    CREATE_B_FROM_A(t0, t1, t5)
    PRINT_ARRAY(t5, t1)

    #Тест 3: минимальный элемент последний 
    la t0, test3
    li t1, 6
    PRINT_ARRAY(t0, t1)

    CREATE_B_FROM_A(t0, t1, t5)
    PRINT_ARRAY(t5, t1)

    #Завершение программы
    li a7, 10
    ecall

.data

# Тестовые массивы
test1: .word 5, 3, 1, 4, 2      # минимальный элемент 1 в середине
test2: .word 0, 3, 4, 5, 6      # минимальный элемент 0 в начале
test3: .word 7, 8, 9, 10, 11, 1 # минимальный элемент 1 в конце
