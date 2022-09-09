;Jack Robbins
;3/2/2022
;Lab 6 Functions
;This program modifies lab 5 to do the same arithmetic but will do so using a function

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
	;The message for displaying the answer
	answerMessage: db "The answer is: ",0
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
		
		;go to the get inputs section
		jmp get_inputs
	
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
		
		;After all inputs have been converted, jump to make the function call
		jmp call_function
		;Begin setting up the function

		
	;The call function section that handles the function call and cleanup afterwards
	call_function:	
		;First prepare the stack
		;Put the value for the operator in r14
		mov r14, [operator]
		;Push the value of the second operand first
		push r10
		;push the value of the first operand next
		push r8
		;finally push the value of the operator
		push r14
		;Stack has been prepared, is in order of operator, firstOperand, secondOperand, now jump to the function call
		;Call the function
		call perform_arithmetic_display_results
		;Clear out the stack afterwards
		;Put the operator in r14
		pop r14
		;put the first operand in r8
		pop r8
		;put the second operand in r10
		pop r10
		;Add 32 to rsp to clear out the stack
		add rsp, 32
		;Jump to the repeat decision section
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
		
		
		
		
		;Declaring and writing the perform_arithmetic_display_results function after the program exit
		perform_arithmetic_display_results:
			;Prologue(Steps to set up the function)
			;Save the location of the calling instructions
			push rbp
			;move the pointer to the top of the stack
			mov rbp, rsp
			;End prologue, function is now set up
			
			;Put the value for the operator in r15
			mov r15, [rbp+16]
			;Put the first operand in r8
			mov r8, [rbp+24]
			;Put the second operand in r10
			mov r10, [rbp+32]
			
			;If the value equals +, jump to the addition label
			cmp r15, "+"
			je perform_addition
		
			;If the value equals -, jump to the subtraction label
			cmp r15, "-"
			je perform_subtraction
	
			;If the value equals *, jump to the multiplication label
			cmp r15, 2ah
			je perform_multiplication
	
			;If the value equals /, jump to the division label
			cmp r15, 2fh
			je perform_division
			
			
			;The label where all the division is handled
			perform_addition:
					;add r8 and r10, result will be stored in r8
					;First save the value in r8 as it will be overwritten by the addition
					mov r14, r8
					add r8, r10
					;Jump to the section that displays results
					jmp display_results
					
			
			;The label where all the subtraction is handled
			perform_subtraction:
				;subtract r8 and r10, the result will be stored in r8
				;First save the value in r8 as it will be overwritten
				mov r14, r8
				sub r8, r10
				;Jump to the section that displays results
				jmp display_results
				
				
			;The label where all the multiplication is handled
			perform_multiplication:
				;integer multiply r8 and r10
				;need to put r8 in rax first
				mov rax, r8
				;Integer multiply by r10, result is in rax
				imul r10
				;Result is in rax, save it in r8
				mov r8, rax
				;Jump to the section that displays results
				jmp display_results
				
				
			;The label where all the division is handled
			perform_division:
				;integer divide r8 and r10
				;zero out rdx
				mov rdx, 0
				;Put the dividend in rax
				mov rax, r8
				;divide rax by the divisor in r10
				idiv r10
				;save the result in r8
				mov r8, rax
				;save the remainder in r14
				mov r14, rdx
				jmp display_results
	
	
			;The label that displays all results
			display_results:
					;get the operator again
					mov r15, [rbp+16]
					;Display the result of addition
					mov rdx, answerMessage
					call WriteString
					mov rax, r8
					call WriteInt
					;Determine if result is from division
					cmp r15, 2fh
					;Jump to display remainder if yes
					je display_remainder
					;Jump to finalize_print if no
					jne finalize_print
					
					
					;The label that displays the remainder
					display_remainder:
						;first write the remainder message
						mov rdx, remainderMessage
						call WriteString
						;Print the remainder
						mov rax, r14
						call WriteInt
						;Jump to finalize_print
						jmp finalize_print
					
					;Put the finishing touch on the printed statement and jump to end_fn
					finalize_print:
						call Crlf
						jmp end_fn
				
				
			;The section of the function that returns to the main program	
			end_fn:
				;Now return to program
				;Restore address of the caller
				pop rbp
				;Return the function
				ret