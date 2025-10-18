.include "macros.asm"
.include "arrays.asm"

.text
.globl main

main:
	# Вывод сообщения о вводе длины массива
    li a7, 4
    la a0, prompt_num
    ecall

    INPUT_NUMBER(t0) 					#Ввод числа
    CHECK_INPUT_NUMBER(t1, t0)			#Проверка введенного числа на корректность 0<N<11
    beq zero, t1, Invalid_input 			
    la t2, N
    sw t0, 0(t2)
    mv s1, t0              			# s1 = длина массива (сохраняемый регистр)
    
    #Выделяем память под массив A из N элементов на стеке и заполняем его значениями от пользователя
	ALLOC_STACK_ARRAY(s2, s1)  		# t0 = адрес массива из 10 элементов
	FILL_ARRAY(s2, s1)
	
	#Выводим элементы массива А
	li a7, 4
    la a0, A_msg
    ecall
    PRINT_ARRAY(s2, s1)
    
    #Формируем массив B из массива A путем перестановки первого и наименьшего элементов
    CREATE_B_FROM_A(s2, s1, s3)
    
    #Выводим элементы массива B
    li a7, 4
    la a0, B_msg
    ecall
    PRINT_ARRAY(s3, s1)
    
    #Выход из программы
    EXIT_PROGRAM

Invalid_input:
	#Если введена некорректная длина массива, то выводим сообщение об ошибке
    li a7, 4
    la a0, invalid_input_message
    ecall
    #Выход из программы
    EXIT_PROGRAM

.data
prompt_num:   .string "Введите длину массива: "
invalid_input_message: .string "Ошибка! Массив может иметь длину только от 1 до 10."
A_msg: "A: "
B_msg: "B: "
N: .word 0
