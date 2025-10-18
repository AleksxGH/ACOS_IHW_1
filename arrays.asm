#Макрос для выделения памяти под массив на стеке
.macro ALLOC_STACK_ARRAY(%addr, %length)
    slli t6, %length, 2    # t6 = N * 4
    sub sp, sp, t6         # выделяем память на стеке
    mv %addr, sp           # возвращаем адрес массива
.end_macro

#Макрос для заполнения массива данными из консоли
.macro FILL_ARRAY(%addr, %length)
    li t0, 0               # i = 0, счетчик

FillLoop: 
    bge t0, %length, FillEnd  # если i >= length, выйти

    # Выводим приглашение к вводу
    li a7, 4
    la a0, array_input_message
    ecall

    # Ввод числа
    li a7, 5
    ecall                  # число в a0

    # Сохраняем число в массив
    slli t1, t0, 2         # смещение = i*4
    add t2, %addr, t1      # адрес arr[i] = %addr + i*4
    sw a0, 0(t2)           # arr[i] = a0

    addi t0, t0, 1         # i++
    j FillLoop

FillEnd:
.end_macro

#Макрос для печати элементов массива в консоль
.macro PRINT_ARRAY(%addr, %length)
    li t0, 0                # i = 0, счетчик

PrintLoop:
    bge t0, %length, PrintEnd   # если i >= length, выйти

    # Загружаем число из массива
    slli t1, t0, 2          # смещение = i*4
    add t2, %addr, t1       # адрес arr[i] = %addr + i*4
    lw a0, 0(t2)            # загружаем число в a0

    # Выводим число
    li a7, 1                # код системного вызова "print integer"
    ecall

    # Выводим пробел
    li a0, 32               # ASCII код пробела
    li a7, 11               # код системного вызова "print char"
    ecall

    addi t0, t0, 1          # i++
    j PrintLoop

PrintEnd:
    # Перевод строки после вывода массива
    li a0, 10               # ASCII код новой строки
    li a7, 11
    ecall
.end_macro

#Макрос для формирования массива B из массива A
.macro CREATE_B_FROM_A(%addr_A, %length, %addr_B)
    li t0, 0                  # i = 0
    lw t1, 0(%addr_A)         # минимальное значение = A[0]
    li t2, 0                  # min_index = 0

FindMinLoop:
    bge t0, %length, FindMinEnd
    slli t3, t0, 2            # смещение i*4
    add t5, %addr_A, t3        # адрес A[i]
    lw t4, 0(t5)               # t4 = A[i]

    blt t4, t1, UpdateMin
    j NextIter

UpdateMin:
    mv t1, t4                  # минимальное значение
    mv t2, t0                  # min_index

NextIter:
    addi t0, t0, 1
    j FindMinLoop

FindMinEnd:
    slli t3, %length, 2        # N*4
    sub sp, sp, t3
    mv %addr_B, sp             # адрес массива B

    li t0, 0
CopyLoop:
    bge t0, %length, CopyEnd

    slli t3, t0, 2
    add t5, %addr_A, t3
    lw t4, 0(t5)               # t4 = A[i]

    add t5, %addr_B, t3
    sw t4, 0(t5)               # B[i] = A[i]

    addi t0, t0, 1
    j CopyLoop
CopyEnd:

    lw t4, 0(%addr_B)          # t4 = B[0]
    slli t3, t2, 2
    add t5, %addr_B, t3
    lw t1, 0(t5)               # t1 = B[min_index]

    sw t1, 0(%addr_B)          # B[0] = B[min_index]
    sw t4, 0(t5)               # B[min_index] = B[0]
.end_macro

.data
array_input_message: .string "Введите элемент: "