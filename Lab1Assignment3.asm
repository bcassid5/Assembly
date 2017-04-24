PORTA	EQU 0
DDRA	EQU 2
delayValue	EQU	2000; Choose number of ms to delay

	org $400
	lds #$4000
	ldaa #$FF
	staa DDRA

loop:	ldaa #$FF
	STAA PORTA
	LDX #delayValue	
	PSHX
	JSR Delay
	LEAS 2,SP
	CLR PORTA
	LDX #delayValue	
	PSHX
	JSR Delay
	LEAS 2,SP
	bra loop		; call only once.


Delay1MS:  	LDX #!20	; Implement you code here
start:		DEX
			BNE start	
			rts	; returns from sub-routin
				
Delay:		LDY #delayValue	; Load 16 bit register with desired parameter
push:		PSHY 	; Push 16 bit register onto the stack
			JSR Delay1MS	; Jump to subroutine delay
			LEAS 2,SP	; Increment SP twice to clean up.
			DEY
			BNE push 

			rts		; Implement a variable delay using a stack parameter