
;A program to compute the sum, difference, 
;and absolute difference of two signed 
;32-bit numbers.

;------Assembler Directives----------------
        THUMB						; uses Thumb instructions
		; Data Variables
		AREA    DATA, ALIGN=2 		; places objects in data memory (RAM)
		EXPORT  SUM	[DATA,SIZE=4]	; export public varialbe "SUM" for use elsewhere
		EXPORT  DIFF [DATA,SIZE=4]	; export public varialbe "DIFF" for use elsewhere
		EXPORT  ABS [DATA,SIZE=4]	; export public varialbe "ABS" for use elsewhere
		EXPORT LARGER [DATA, SIZE=4]; export public variable "LARGER" for use elsewhere
LARGER  SPACE   4					; allocates 4 uninitialized bytes in RAM for LARGER
SUM     SPACE	4   				; allocates 4 uninitialized bytes in RAM for SUM
DIFF	SPACE	4					; allocates 4 uninitialized bytes in RAM for DIFF
ABS		SPACE	4					; allocates 4 uninitialized bytes in RAM for ABS

		; Code
		AREA    |.text|, CODE, READONLY, ALIGN=2	; code in flash ROM
		EXPORT  Start				; export public function "start" for use elsewhere
NUM1   	DCD   	-1					; 32-bit constant data NUM1 = -1
NUM2	DCD		2					; 32-bit constant data NUM2 = 2
;-------End of Assembler Directives----------


GET_SUM								; subroutine GET_SUM
		ADD R0, R1, R2				; R0=R1+R2
		LDR R3, =SUM				; R3=&SUM, R3 points to SUM
		STR R0, [R3]				; store the sum of NUM1 and NUM2 to SUM
		BX	LR						; subroutine return
GET_DIFF							; subroutine GET_DIFF
		SUBS R0, R1, R2				; R0=R1-R2
		LDR R3, =DIFF				; R3=&DIFF, R3 points to DIFF
		STR R0, [R3]				; store the different of NUM1 and NUM2 to DIFF
		BMI	GET_ABS					; check condition code, if N=1 (i.e. the difference is negative), 
									; branch to GET_ABS to calculate the absolute difference
STR_ABS								; label STR_ABS, store the absolute difference
		LDR R3, =ABS				; R3=&ABS, R3 points to ABS
		STR R0, [R3]				; store the absolute difference to ABS
		BX	LR						; subroutine return
GET_ABS								; label GET_ABS, calculate the absolute difference if the difference is negative
		RSB	R0, R0, #0				; R0=0-R0;
		B	STR_ABS					; branch to STR_ABS to store the result

GET_LARGER							;label GET_LARGER, compares NUM1 and NUM2
		LDR R3, =LARGER				
		BGT STR_FIR  				; moves to branch STR_FIR if NUM1 is greater
		BLT STR_SEC					; moves to branch STR_SEC if NUM2 is greater
		BEQ STR_EQ					; branch to branch STR-EQ if NUM1 and NUM2 is same
		BX LR						; subroutine branch exit
	
STR_FIR
		STR R1, [R3]				;store the value of R1 and R3
		BX LR						

STR_SEC
		STR R2, [R3]				;store the value of R2 in R3
		BX LR						;subroutine branch exit

STR_EQ
		STR R1, [R3]				;store the value R1 in R3
		BX LR						;subroutine branch exit

Start	LDR R1, NUM1				; R1=NUM1
		LDR R2,	NUM2				; R2=NUM2
		BL  GET_LARGER
		BL	GET_SUM
		BL	GET_DIFF
		BL  GET_LARGER
		
		ALIGN                       ; make sure the end of this section is aligned
		END                         ; end of file