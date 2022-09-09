;Jack Robbins
;02/09/2022
;Lab Assignment 3

%include "CPsub64.inc" ;Always include at start


global main		;Declare the starting point

;Create and initialize all variables
section .data
	MainMessage: db "Today I have conquered my first Assembly program",0ah,"I can now do anything!",0,0ah	;the main string 
	lenMessage: equ($-MainMessage)		;Calculate the length of the message
	blankLine: db "",0,0ah				;The blank line message
	lenBlank: equ($-blankLine)			;Calculate the length of the blank line
	
;create the instructions
section .text

	;Start here
	main:
		;Print the first blank line
		mov rax, 1
		mov rdi, 1
		mov rsi, blankLine
		mov rdx, lenBlank
		syscall
		
		;Print the message
		mov rax, 1
		mov rdi, 1
		mov rsi, MainMessage
		mov rdx, lenMessage 
		syscall
		
		;Print the last blank line
		mov rax, 1
		mov rdi, 1
		mov rsi, blankLine
		mov rdx, lenBlank
		syscall
		
		;Exit from the program
		mov rax, 60
		xor rdi, rdi
		syscall
		
		
		
		
	