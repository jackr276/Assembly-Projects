;Jack Robbins
;02/16/2022
;Lab04: Arithmetic 
;This program will ask the user for a series of integers to perform addition, subtraction, multiplication and division

;Import CPsub64 for the DumpMem and DumpRegs calls
%include "CPsub64.inc"

;Declare the starting point
global main

;Declare and initialize all messages and calculate their lengths
section .data

	;This is a general purpose blank line message to be used throughout the program
	BlankLine: db "",0,0ah
	;Length of the blankline
	lenBlankLine: equ($-BlankLine)
	
	;This message informs the user we'll be doing addition
	AddMessage: db "Let's do addition!",0,0ah
	;Find the length of the AddMessage
	lenAddMessage: equ($-AddMessage)
	
	;This message will inform the user we'll be doing subtraction
	SubMessage: db "Let's do subtraction!",0,0ah
	;Find the length of message
	lenSubMessage: equ($-SubMessage)
	
	;This message informs the user we'll be doing multiplication
	MulMessage: db "Let's do multiplication!",0,0ah
	;Find the length of the message
	lenMulMessage: equ($-MulMessage)
	
	;This message will inform the user we'll be doing division
	DivMessage: db "Let's do division!",0,0ah
	;Find the length of the message
	lenDivMessage: equ($-DivMessage)
	
	;This message will be used to prompt the user for the first operand
	FirstOperand: db "Enter the first multi-digit integer: ",0
	;Find the length of the message
	lenFirstOperand: equ($-FirstOperand)
	
	;This message will be used to prompt the user for the second operand
	SecondOperand: db "Enter the second multi-digit integer: ",0
	;Find the length of the message
	lenSecondOperand: equ($-SecondOperand)
	
	;This message will be used to display the remainder of a division operation
	remainder: db "The remainder is: ",0
	;Find the length of the message
	lenRemainder: equ($-remainder)
	
	;This message will be used to display the result of an operation
	result: db "The result is: ",0
	;Find the length of the message
	lenResult: equ($-result)
	
;Initialize all other variables
section .bss
	;Reserve 255 bytes for the first number
	firstNum: resb 255
	;Reserve 255 bytes for the second number
	secondNum: resb 255


;Perform all the operations	
section .text
	
	;Declare the starting point
	main: 
		;First print a blank line for formatting
		mov rax, 1
		mov rdi, 1
		mov rsi, BlankLine
		mov rdx, lenBlankLine
		syscall
		
		;First perform the addition
		;Print the message to inform the user we'll be doing addition
		mov rax, 1
		mov rdi, 1
		mov rsi, AddMessage
		mov rdx, lenAddMessage
		syscall
		
		;Prompt the user for the first number
		mov rax, 1
		mov rdi, 1
		mov rsi, FirstOperand
		mov rdx, lenFirstOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, firstNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;Call DumpMem to see if it worked
		mov rsi, firstNum	;the location of what to dump
		mov rcx, 49			;the number of bytes you want to dump
		mov rbx, 4			;the size of each byte
		call DumpMem
		
		;convert the string numeric value to an integer
		mov rdx, firstNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r8, rax 
		
		;Prompt the user for the second number
		mov rax, 1
		mov rdi, 1
		mov rsi, SecondOperand
		mov rdx, lenSecondOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, secondNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, secondNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r10, rax 
		
		;Now perform the addition
		add r8, r10		;add r8 and r10, the result will be kept in r8
		
		;Call DumpRegs to view register content
		call DumpRegs
		
		;Print a message to declare what the result is
		mov rax, 1
		mov rdi, 1
		mov rsi, result
		mov rdx, lenResult
		syscall
		
		;Print the result with writeInt
		mov rax, r8
		call WriteInt
		
		
		;Now perform the subtraction
		;First print a blank line for formatting
		mov rax, 1
		mov rdi, 1
		mov rsi, BlankLine
		mov rdx, lenBlankLine
		syscall
		
		;Print the message to inform the user we'll be doing subtraction
		mov rax, 1
		mov rdi, 1
		mov rsi, SubMessage
		mov rdx, lenSubMessage
		syscall
		
		;Prompt the user for the first number
		mov rax, 1
		mov rdi, 1
		mov rsi, FirstOperand
		mov rdx, lenFirstOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, firstNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, firstNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r8, rax 
		
		;Prompt the user for the second number
		mov rax, 1
		mov rdi, 1
		mov rsi, SecondOperand
		mov rdx, lenSecondOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, secondNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, secondNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r10, rax 
		
		;Now perform the subtraction
		sub r8, r10		;subtract r8 and r10 and store the result in r8
	
		;Print a message to declare what the result is
		mov rax, 1
		mov rdi, 1
		mov rsi, result
		mov rdx, lenResult
		syscall
		
		;Print the result with writeInt
		mov rax, r8
		call WriteInt
		
		
		;Now perform the multiplication
		;First print a blank line for formatting
		mov rax, 1
		mov rdi, 1
		mov rsi, BlankLine
		mov rdx, lenBlankLine
		syscall
		
		;Print the message to inform the user we'll be doing multiplication
		mov rax, 1
		mov rdi, 1
		mov rsi, MulMessage
		mov rdx, lenMulMessage
		syscall
		
		;Prompt the user for the first number
		mov rax, 1
		mov rdi, 1
		mov rsi, FirstOperand
		mov rdx, lenFirstOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, firstNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, firstNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r8, rax 
		
		;Prompt the user for the second number
		mov rax, 1
		mov rdi, 1
		mov rsi, SecondOperand
		mov rdx, lenSecondOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, secondNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, secondNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r10, rax 
		
		;Perform the multiplication
		;This requires an operand to be in rax
		mov rax, r8		;put r8 into rax
		imul r10		;integer multiply r8 by r10, result is in rax
		mov r15, rax	;store the result
		
		;Print a message to declare what the result is
		mov rax, 1
		mov rdi, 1
		mov rsi, result
		mov rdx, lenResult
		syscall
		
		;Print the result
		mov rax, r15	;move the result back into rax
		Call WriteInt
		
		
		
		;Now perform the division
		;First print a blank line for formatting
		mov rax, 1
		mov rdi, 1
		mov rsi, BlankLine
		mov rdx, lenBlankLine
		syscall
		
		;Print the message to inform the user we'll be doing division
		mov rax, 1
		mov rdi, 1
		mov rsi, DivMessage
		mov rdx, lenDivMessage
		syscall
		
		;Prompt the user for the first number
		mov rax, 1
		mov rdi, 1
		mov rsi, FirstOperand
		mov rdx, lenFirstOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, firstNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, firstNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r8, rax 
		
		;Prompt the user for the second number
		mov rax, 1
		mov rdi, 1
		mov rsi, SecondOperand
		mov rdx, lenSecondOperand
		syscall
		
		;Get the user input from the console
		mov rdx, 255		;put the size in rdx
		mov rcx, secondNum	;put the variable in rcx
		mov rbx, 0
		mov rax, 3
		int 80h				;call interupt 80h to get user input
		
		;convert the string numeric value to an integer
		mov rdx, secondNum	;put the location of the value to be converted in rdx
		mov rcx, 255		;put the size in rcx
		call ParseInteger64	;call ParseInteger64, output is in rax
		
		;Save the value in a place where it won't be overwritten
		mov r10, rax 
		
		;Perform the division
		mov rdx, 0		;zero out rdx
		mov rax, r8		;put the dividend in rax
		idiv r10		;r10 is the divisor, result is in rax
		
		;store the result for where it won't get overwritten
		mov r15, rax
		;store the remainder where it won't get overwritten
		mov r14, rdx
		
		;See if the operation worked
		call DumpRegs
		
		;Print a message to declare what the result is
		mov rax, 1
		mov rdi, 1
		mov rsi, result
		mov rdx, lenResult
		syscall
		
		;print the result
		mov rax, r15
		call WriteInt
		
		;print a blank line for formatting
		mov rax, 1
		mov rdi, 1
		mov rsi, BlankLine
		mov rdx, lenBlankLine
		syscall
		
		;Print a message to declare what the remainder is
		mov rax, 1
		mov rdi, 1
		mov rsi, remainder
		mov rdx, lenRemainder
		syscall
		
		;Print the remainder
		mov rax, r14
		call WriteInt
		
		;print a blank line for formatting
		mov rax, 1
		mov rdi, 1
		mov rsi, BlankLine
		mov rdx, lenBlankLine
		syscall
		
		
		;Exit from the program
		mov rax, 60
		xor rdi, rdi
		syscall