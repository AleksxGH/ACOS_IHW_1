.macro ALLOC_STACK_ARRAY(%addr, %length)
    slli t6, %length, 2    # t6 = N * 4
    sub sp, sp, t6         # выделяем память на стеке
    mv %addr, sp           # возвращаем адрес массива
.end_macro


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


.data
array_input_message: .string "Введите элемент: "