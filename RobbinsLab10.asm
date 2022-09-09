; Jack Robbins
; 04/12/2022
; Lab 10 - Inline Calculator
; This program will capture arguments enterred into the console and perform the appropriate calculation


;Need to include these two for macros
%include "CPsub64.inc"
%include "Macros_CPsub64.inc"

;Declare the starting point
global main


;Declare all macros for use
;Macros
;======================================================================================================

;The writeMesg macro uses the WriteString macro
;Takes in the message as an argument(%1)
%macro writeMesg 1
push rdx
mov rdx, %1
call WriteString
pop rdx
%endmacro

;The getInput macro reads the inputs out of the stack
;Takes in the location to store the value (%1) and the amount to add to rsi(%2)
%macro getInput 2
;Save rdi and rsi
push rdi
push rsi
;Align the stack boundary
sub rsp, 8
;Add the specified amount to rsi
add rsi, %2
;Retrieve the value from the stack and put it in the variables
mov %1, [rsi]
;Realign the stack boundary
add rsp, 8
;Restore rdi and rsi
pop rsi
pop rdi
%endmacro

;This macro will convert inputs to an into
;Takes the source(%1) and the destination(%2)
%macro toInt 2
;Put the value to be converted into rdx
mov rdx, %1
;Put the size in rcx, this will always be 255
mov rcx, 255
;Call parseInteger64
call ParseInteger64
;Save the value in the designated spot
mov %2, rax
%endmacro

;This macro will display the results for addition, multiplication and subtraction
;Takes in the result of an operation(%1)
%macro displayResult 1
;First write the resultMessage
writeMesg resultMessage
;Put the result in rax
mov rax, %1
;Use writeInt to write the answer signed
call WriteInt
;Print a new line
call Crlf
%endmacro

;This macro will display the results of division only
;Takes in the quotient(%1) and the remainder(%2)
%macro displayResultDiv 2
;First write the result message
writeMesg resultMessage
;Put the quotient in rax
mov rax, %1
;Write out the quotient
call WriteInt
;Print the remainderMessage
writeMesg remainderMessage
;Put the remainder in rax
mov rax, %2
;Print the remainder and a new line
call WriteInt
call Crlf
%endmacro

;=======================================================================================================


;Declare all messages for use
section .data
	;A simple completion message that shows when the program is over
	endMessage: db "The program has completed.",0,0ah
	;A message telling the user the incorrect arguments have been entered
	incorrectArgMessage: db "You have entered either an insufficient number of arguments or an incorrect argument.",0,0ah
	;A message telling the user what they entered
	resultMessage: db "The result of what you entered is: ",0
	;A message for use only in division to state the remainderMessage
	remainderMessage: db " Remainder: ",0,0ah


; All program instructions	
section .text
	;Start here
	main:
		;rdi holds the number of arguments enterred, but for the purpose of this program the first argument "./RobbinsLab10" doesn't count
		;So, decrement rdi
		dec rdi
		;If the program was called correctly, rdi should now equal 3
		;Compare rdi to 3, jump to processArgs if it does equal 3, and jump to incorrectArgs if it doesn'telling
		cmp rdi, 3
		je processArgs
		jne incorrectArgs
		
		
		;The label that handles all the argument processing if a correct number of arguments is entered
		processArgs:
			;If this label is reached, we know there are only three arguments to get, so no loop is needed
			;The arguments are entered in the following order: num1, operator, num2
			;So get them in that order
			;Add 8 to the stack to skip over the "./RobbinsLab10"
			getInput r8, 8
			;Use the toInt macro to convert this value to an int
			toInt r8, r8
			
			;Use the get input macro to get the operator
			getInput r15, 16

			;Use the getInput macro to get the final number
			getInput r14, 24
			;Use the toInt macro to convert this value to an int
			toInt r14, r14
			
			;Store the operator in dl for comparison uses
			mov dl, [r15]

			;Now determine which operator the user entered
			;Compare with +, if identical, jump to addition
			cmp dl, "+"
			je addLabel
			;Compare with -, if identical, jump to subtraction
			cmp dl, "-"
			je subLabel
			;Compare with *, if identical, jump to multiplication
			cmp dl, 2ah
			je mulLabel
			;Compare with division, if identical, jump to division
			cmp dl, 2fh
			je divLabel
			;If the value in dl doesn't math addition at this point, that means the operator entered was wrong, so jump to incorrectArgs
			jne incorrectArgs

			;This label handles all of the addition
			addLabel:
				;Add r8 and r14, result is in r8
				add r8, r14
				;Pass the value to the displayResult macro
				displayResult r8
						
				;Exit the program once done
				jmp programExit
				
			;This label handles all of the subtraction	
			subLabel:
				;Subtract r8 and r14, result is in r8
				sub r8, r14
				;Use the display result macro
				displayResult r8
				
				;Exit the program once done
				jmp programExit
				
			;This label handles all of the multiplication	
			mulLabel:
				;Put r8 in rax
				mov rax, r8
				;Integer multiply rax by r14, result is in rax
				imul r14
				;Use the displayResult macro
				displayResult rax
				
				;Exit the program once done
				jmp programExit
	
			;This label handles all of the division
			divLabel:
				;Zero out rdx
				mov rdx, 0
				;Put r8 in rax
				mov rax, r8
				;Integer divide rax by r14, quotient is in rax, remainder is in rdx
				idiv r14
				;Use the displayResultDiv macro
				displayResultDiv rax, rdx
				
				;Exit the program once done
				jmp programExit
		
		
		;This label will be reached if insufficient or incorrect arguments are entered
		incorrectArgs:
		
			;Use the writeMesg macro to inform the user their arguments are incorrect or insufficient
			writeMesg incorrectArgMessage
			;Call crlf for a new line
			call Crlf

			;Jump to the program exit label
			jmp programExit
			
			
		;The label that simply exits the program	
		programExit:
					
			;Tell the user the program has completed
			writeMesg endMessage
			;Call Crlf for a new line
			call Crlf
			
			;Exit the program
			Exit
		