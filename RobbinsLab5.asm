;Jack Robbins
;02/23/2022
;Lab 5: Intermediate Lab
;This program will adapt lab 4 to use jumps and allow the user to input an operator. The user can also repeat the program if they'd like.

;Need to include these two statements for the macros and functions
%include "CPsub64.inc"
%include "Macros_CPsub64.inc"

;declare the starting point
global main 	

;Declare and initialize all messages we want to use
;No need to calculate lengths as the program will use WriteString
section .data
	;print a simple welcome message
	WelcomeMessage: db "Let's do some arithmetic!",0,0ah
	;print a message to prompt the user for the first operand
	getFirstOperand: db "Enter the first operand: ",0
	;print a message to prompt the user for the second operand
	getSecondOperand: db "Enter the second operand: ",0
	;print a message to prompt the user for an operator
	getOperator: db "Enter the desired operator(+ or - or * or /): ",0
	;print a repeat message
	repeatMessage: db "Would you like to do another operation? (Y/N): ",0
	
	;general purpose messages for printing equations and results
	;A simple message with a space
	spaceMessage: db " ",0	
	;A message with an equals sign
	equalSign: db " = ",0
	;A message declaring a remainder
	remainderMessage: db " Remainder: ",0
	
	
;Declare all variables that will be used later	
section .bss
	;The user-inputted first operand
	firstOperand: resb 255
	;The user-inputted second operand
	secondOperand: resb 255
	;The user-inputted operator
	operator: resb 255
	;The user-input for repetition
	userRepeat: resb 255
	
	
;Perform all instructions	
section .text
	main:	;Start here
	
		;Put what we want to print in rdx, then call WriteString
		mov rdx, WelcomeMessage
		call WriteString
	
		;Print a blank line
		call Crlf
	
	;The label that handles all of the user input
	get_inputs:
	
		;Prompt the user for the operator
		mov rdx, getOperator
		call WriteString
		;Get user input from console
		mov rdx, operator
		mov rcx, 255
		call ReadString
	
		;Prompt the user for the first operand
		mov rdx, getFirstOperand
		call WriteString
		;Get user input from console
		mov rdx, firstOperand
		mov rcx, 255
		call ReadString
	
		;Prompt the user for the second operand
		mov rdx, getSecondOperand
		call WriteString
		;Get user input from console
		mov rdx, secondOperand
		mov rcx, 255
		call ReadString
	
		;After all user input has been entered, jump to the conversion label
		jmp convert_inputs
	
	
	;The label where all of the inputs are converted for use
	convert_inputs:
	
		;Convert the first number to an integer
		mov rdx, firstOperand
		mov rcx, 255
		call ParseInteger64
		;Save the value so it won't get overwritten
		mov r8, rax
	
		;convert the second number to an integer
		mov rdx, secondOperand
		mov rcx, 255
		call ParseInteger64
		;Save the value so it won't get overwritten
		mov r10, rax
	
		;Now determine which operation the user would like to do
		;for * and / use ASCII table, * is 2ah and / is 2fh
		;Put the value of operator in dl
		mov dl, [operator]
	
		;If the value equals +, jump to the addition label
		cmp dl, "+"
		je perform_addition
		
		;If the value equals -, jump to the subtraction label
		cmp dl, "-"
		je perform_subtraction
	
		;If the value equals *, jump to the multiplication label
		cmp dl, 2ah
		je perform_multiplication
	
		;If the value equals /, jump to the division label
		cmp dl, 2fh
		je perform_division
	
	
	;The label where all addition is handled
	perform_addition:
		;add r8 and r10, result will be stored in r8
		;First save the value in r8 as it will be overwritten by the addition
		mov r14, r8
		add r8, r10
		;Jump to display results when done
		jmp display_results_add_sub
	
	
	;The label where all the subtraction is handled
	perform_subtraction:
		;subtract r8 and r10, the result will be stored in r8
		;First save the value in r8 as it will be overwritten
		mov r14, r8
		sub r8, r10
		;Jump to display results when done
		jmp display_results_add_sub
	
	
	;The label where all the multiplication is handled
	perform_multiplication:
		;integer multiply r8 and r10
		;need to put r8 in rax first
		mov rax, r8
		;Integer multiply by r10, result is in rax
		imul r10
		;Result is in rax, save it in r14
		mov r14, rax
		;Jump to display results when done
		jmp display_results_mul
	
	
	;The label where all the division is handled
	perform_division:
		;integer divide r8 and r10
		;zero out rdx
		mov rdx, 0
		;Put the dividend in rax
		mov rax, r8
		;divide rax by the divisor in r10
		idiv r10
		;save the result in r15
		mov r15, rax
		;save the remainder in r14
		mov r14, rdx
		;Jump to display results when done
		jmp display_results_div
		
	
	;The label that will display the equation and the result for addition and subtraction
	display_results_add_sub:
		;first print the first operand
		mov rax, r14
		call WriteInt
		;Print a space for formatting
		mov rdx, spaceMessage
		call WriteString
		;Print the operator
		mov rdx, operator
		call WriteString
		;Print a space for formatting
		mov rdx, spaceMessage
		call WriteString
		;Print the second operand
		mov rax, r10
		call WriteInt
		;Print the equals sign
		mov rdx, equalSign
		call WriteString
		;Finally print the answer
		mov rax, r8
		call WriteInt
		;Print a blank line for formatting
		call Crlf
		;Jump to the repeat decision label
		jmp repeat_decision
		
		
	;The label that will display the equation and result for multiplication
	display_results_mul:
		;Print the first operand
		mov rax, r8
		call WriteInt
		;Print a space for formatting
		mov rdx, spaceMessage
		call WriteString
		;Print the operator
		mov rdx, operator
		call WriteString
		;Print a space for formatting
		mov rdx, spaceMessage
		call WriteString
		;Print the second operand
		mov rax, r10
		call WriteInt
		;Print the equals sign
		mov rdx, equalSign
		call WriteString
		;Finally print the result
		mov rax, r14
		call WriteInt
		;Print a blank line for formatting
		call Crlf
		;Jump to the repeat decision label
		jmp repeat_decision
	
	    
	;The label that will display the equation and result for division
	display_results_div:
		;Print the first operand
		mov rax, r8
		call WriteInt
		;Print a space for formatting
		mov rdx, spaceMessage
		call WriteString
		;Print the operator
		mov rdx, operator
		call WriteString
		;Print a space for formatting
		mov rdx, spaceMessage
		call WriteString
		;Print the second operand
		mov rax, r10
		call WriteInt
		;Print the equals sign
		mov rdx, equalSign
		call WriteString
		;Print the result
		mov rax, r15
		call WriteInt
		;Print the remainder message
		mov rdx, remainderMessage
		call WriteString
		;Print the remainder
		mov rax, r14
		call WriteInt
		;Print a blank line for formatting
		call Crlf
		;Jump to the repeat decision label
		jmp repeat_decision
	
	
	
	;The label that handles the repeating of the program
	repeat_decision:
		;Ask the user if they would like to repeat
		mov rdx, repeatMessage
		call WriteString
		;Get user input after they have answered
		mov rdx, userRepeat
		mov rcx, 255
		call ReadString
	
		;Move the value of userRepeat into dl for use in comparison
		mov dl, [userRepeat]
		;Compare dl with Y and y, jump to the get_inputs label if they're equal
		cmp dl, "Y"
		je get_inputs
		cmp dl, "y"
		je get_inputs
	
	
	;Exit the program
	Exit
	
	
	
	
	
	