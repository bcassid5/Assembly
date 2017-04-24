TSCR1           EQU $46
TSCR2           EQU $4D
TIOS   			EQU $40
TCTL1           EQU $48
TCTL2           EQU $49
TFLG1           EQU $4E
TIE      		EQU $4C
TSCNT          	EQU $44
TC4             EQU $58
TC1             EQU $52
PORTB          	EQU $01
DDRB 			EQU $03
PORTM        	EQU $0250
DDRM          	EQU $0252
 
 
           ORG $1000
DutyCycle ds 2 
		   
             ORG $400
             LDAA #$90
             STAA TSCR1
             LDAA #$03
            
             LDAA #$10
             STAA TIOS
             LDAA #$01
             STAA TCTL1                     ; Perform basic  timer initialization to setup an output compare on PT4
             LDD #!250
			 STD DutyCycle                       ; Store a decimal value between 100 and 900 in the memory location referenced by, DutyCycle.
 			 
TOP      LDAA #$02
             STAA TCTL1
            
             LDD TSCNT                        ; Read current 16 bit value of TSCNT
             ADDD DutyCycle  
             STD TC4                             ; Add an offset to the current TSCNT equivalent to the ON time and store to TC4
                                                                    ; Initialize register TCTL1 to CLEAR bit 4 on a compare event
             BRCLR TFLG1,$10,*                  ; Spin until the TFLG1 register indicates a bit 4 compare event
             LDAA #$03
             STAA TCTL1                                ; Read current 16 bit value of TSCNT
            
             LDD #!750                                  ; Add an offset to the current TSCNT equivalent to the OFF time and store to TC4
             ADDD TC4                                  ; Initialize register TCTL1 to SET bit 4 on a compare event     
             STD TC4
            
             BRCLR TFLG1,$10,*                     ; Spin until the TFLG1 register indicates a bit 4 compare event
           BRA TOP