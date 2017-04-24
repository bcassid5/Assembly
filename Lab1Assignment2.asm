DDRT	equ $0242
PORTT	EQU $0240

		org $400
		lds #$4000
		ldaa #$10
		staa DDRT		; Make bit 4 of PORT T an output

loop:	bset PORTT,$10	; Turn on bit 4
		jsr Delay1MS	; 1ms delay
		bclr PORTT,$10	; Turn off bit 4
		jsr Delay1MS	; 1ms delay.  
		bra loop	; Branch forever


Delay1MS:  	LDX #!500	; Implement you code here
start:		DEX
			BNE start	
			rts	; returns from sub-routine