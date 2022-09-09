; Jack Robbins
; 04/04/2022
; Lab 9: In-Line
; This program will acquire the user command line arguments when run and display the number of arguments and each arguments

;Include these two statements for macros
%include "Macros_CPsub64.inc"
%include "CPsub64.inc"


;Macros 
;=================================================================================================
;Declare macros for use

;The writeMesg macro uses the puts function
;Takes in the message as an argument(%1)
%macro writeMesg 1
;Save rdi first
push rdi
;Put the argument in rdi
mov rdi, %1
;Display the argument
call puts
;Restore rdi
pop rdi
%endmacro


;The displayInput macro displays user input
;Takes in a the amount to add to rsi(%1)
%macro displayInput 1
;Save rdi and rsi
push rdi
push rsi
;Align stack boundary
sub rsp, 8
;Add the parameter to rsi to get to the desired stack location
add rsi, %1
;Put the value in rsi into rdi
mov rdi, [rsi]
;Display the value
call puts
;Align stack boundary
add rsp, 8
;Restore both values
pop rsi
pop rdi
%endmacro

;=====================================================================================================


;Declare the starting point
global main
;Bring in the puts C function for use
extern puts


;Declare all the messages
section .data
	;A simple completion message that shows when the program is over
	endMessage: db "The program has completed",0,0ah
	;A message informing the user no arguments have been enterred
	noArgMessage: db "No arguments have been entered",0,0ah


;All program instructions
section .text
;Start here
main:
	;rdi holds the number of arguments entered in, but for the purpose of this program the "./RobbinsLab9" doesn't count
	;So, decrement RDI to begin with
	dec rdi
	
	;Next compare the newly decremented rdi to 0. If it equals 0, jump to the noArgs label, and if it doesnt jump to Args
	cmp rdi, 0
	je noArgs
	jne Args
	

	;This label will only be reached if no arguments are entered into the terminal
	noArgs:
		;Use the macro to write the noArgMessage
		writeMesg noArgMessage

		;Display the endMessage
		writeMesg endMessage
				
		;Exit all C functions
		ret
		
		;Cleanly exit the program
		Exit
		
		
	;This label will be reached if there are arguments entered into the terminal	
	Args:
		;Now display rdi
		mov rax, rdi
		call WriteDec
		call Crlf
		
		;Store rdi into r15 for use in the loop
		mov r15, rdi
		
		;r14 will be passed to the displayInput macro as the amount to add to rsi
		;Since we're skipping the "./RobbinsLab9", this can be set to 8 at the start to jump over that value in the stack
		;Put 8 in r14
		mov r14, 8
		
		;The simple loop that will be used for displaying all of the inputs
		argLoop:
			;First call the displayInput macro, passing in r14 as the amount to add to rsi
			displayInput r14
			;Now add 8 to r14 for the next time the loop goes
			add r14, 8
			;Decrement r15 to keep track of how many arguments are left to display
			dec r15
			;Compare r15 with 0. If it is not equal to 0, there are still more arguments to be processed, so jump to the argLoop label again
			cmp r15, 0
			jne argLoop

		;After the loop is done all that's left is to display the end message and clean up	
		;Display the endMessage
		writeMesg endMessage
		
		;Exit all C functions
		ret
		
		;Exit the program
		Exit
		
		
		
		