; Jack Robbins
; 3/22/2022
; Lab 7 - Strings: This program will ask the user for 2 strings and then compare the two strings and display the result to the user.

; Need to include these two for macros
%include "Macros_CPsub64.inc"
%include "CPsub64.inc"

;Declare the starting point
global main


;declare and initialize all messages, no need to calculate lenghts
section .data
;A simple welcome message 
welcomeMessage: db "Let's compare some strings!",0,0ah
;This message tells the user the program is displaying their inputs
displayMessage: db "Here's what you've entered:",0,0ah
;This message will tell the user to enter the first string
firstStringMessage: db "Enter the first string: ",0
;This message will tell the user to enter the second string
secondStringMessage: db "Enter the second string: ",0
;This will display if the strings are totally different
differentStrings: db "The strings you've entered are different.",0,0ah
;This will display if the strings are identical
sameStrings: db "The strings you've entered are identical.",0,0ah
;This will display if the strings are the same to a point
sameUntil: db "The strings you've entered are the same up to index ",0
;This will ask the user if they'd like to repeat
repeatMessage: db "Would you like to compare more strings?[Y/N]: ",0


;Declare the variables used for storing user input
section .bss
;The variable for storing the first sentence
S1: resb 255
;The variable for storing the second sentence
S2: resb 255
;The variable for storing the repeat
repeatInput: resb 255


;The section with all the instructions
section .text

;Start here
main:

	;Print out the welcome message
	mov rdx, welcomeMessage
	call WriteString
	;Print a blank line for formatting
	call Crlf

	;The label where all input handling happens
	getInputs:

		;Prompt the user for the first string
		mov rdx, firstStringMessage
		call WriteString
		;Get the user input from the console
		;Put variable in rdx
		mov rdx, S1
		;Put size in rcx
		mov rcx, 255
		call ReadString

		;Prompt the user for the second string
		mov rdx, secondStringMessage
		call WriteString
		;Get the user input from the console
		;Put variable in rdx
		mov rdx, S2
		;Put size in rcx
		mov rcx, 255
		call ReadString

		;Jump to the displayInputs segment
		jmp displayInputs

	;This section will display the user's inputs
	displayInputs:

		;print a blank line first
		call Crlf

		;Display the displayMessage
		mov rdx, displayMessage
		call WriteString
		call Crlf

		;Display the user's first string
		mov rdx, S1
		call WriteString
		call Crlf

		;Display the user's second string
		mov rdx, S2
		call WriteString
		call Crlf
		
		;Print a blank line for formatting
		call Crlf
		
		;Jump to the compare string lengths segment
		jmp compareLengths


	;The segment that compares the string lengths
	compareLengths:

		;set rcx to be -1 to indicate different lengths
		mov rcx, -1

		;Get lengths of strings - if strings are different lenghts, they're automatically not equal
		;Calculate the length of the first string
		mov rdx, S1
		call StrLength
		;Save the length
		mov r14, rax

		;Calculate the length of the second string
		mov rdx, S2
		call StrLength
		;Save the length
		mov r10, rax

		;Compare r10 and r14
		cmp r10, r14
		;Jump if not equal to notEqual
		jne notEqual
		;Jump to compareByChar if equal
		je compareByChar


	compareByChar:
		
		;set up the comparison
		;Put the first string in rsi(source)
		mov rsi, S1
		;Put the second string in rdi(destination)
		mov rdi, S2
		;Put the length in rcx - we have the length in r10 and r14 from the previous label
		mov rcx, r14
		
		;tell the program to read left-to-right
		cld
		
		;repeat while equal the by character comparison
		repe cmpsb
		
		;Let's figure out what happened - if rcx is 0, the strings are equal, if not, then they're equalUntil
		cmp rcx,0
		je equal
		jne equalUntil


	;The segment that prints if they're not equal
	notEqual:
	
		;Print out the not equal message
		mov rdx, differentStrings
		call WriteString
		call Crlf
		;Jump to the repeat section
		jmp repeatProgram


	;The segment that prints if they're equal
	equal:
	
		;Print out the equal message
		mov rdx, sameStrings
		call WriteString
		call Crlf
		;Jump to the repeat section
		jmp repeatProgram


	;The segment that prints if they're equal to a point
	equalUntil:
		;Print out the sameUntil message
		mov rdx, sameUntil
		call WriteString
		;Calculate the index by subtracting rcx from the length in r10
		sub r10,rcx
		;Now print out the index
		mov rax, r10
		call WriteDec
		;Print a blank line for formatting
		call Crlf

	;The segment that asks the user if they want to compare more strings
	repeatProgram:
		;Print a blank line for formatting
		call Crlf
		
		;Print out the repeat message
		mov rdx, repeatMessage
		call WriteString
		
		;Get the user input
		mov rdx, repeatInput
		mov rcx, 255
		call ReadString
		
		call Crlf
		;Compare the user input with y and Y to determine if a repeat has been requested
		;Move user input into dl for this comparison
		mov dl, [repeatInput]
		;compare with y
		cmp dl, "y"
		;jump if equal to the get inputs
		je getInputs
		;compare with Y
		cmp dl, "Y"
		;jump if equal to getInputs
		je getInputs
		;Go to ProgramExit if not equal
		jne programExit
		
	;The label that terminates the program		
	programExit:
		Exit
		