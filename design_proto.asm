;**** Timer ****
TSCR1 EQU $46
TSCR2 EQU $4D
TIOS  EQU $40
TCTL1 EQU $48
TCTL2 EQU $49
TFLG1 EQU $4E
TIE   EQU $4C
TSCNT EQU $44
TC4      EQU $58
TC1      EQU $52
;***************
 
;*** PORTS ****
DDRA  EQU $02
PORTA EQU $00
PORTB EQU $01
DDRB  EQU $03
PORTM EQU $0250
DDRM  EQU $0252
DDRT	equ $0242
PORTT	EQU $0240
;**************
 
;*** ADC Unit ***
ATDCTL2      EQU $122
ATDCTL4 EQU $124
ATDCTL5      EQU $125
ADTSTAT0 EQU $126
ATD1DR1H EQU $132
ADT1DR1L EQU $133
;****************
 
; Include .hc12 directive, in case you need MUL
.hc12
 
           ORG $1000
DutyCycle ds 2
 
           ORG $400
           LDS #$4000
           LDAA #$C0
           STAA ATDCTL2   ; Initialize A/D
           
           JSR Delay1MS
           
           LDAA #$E5
           STAA ATDCTL4
           LDAA #$FF
           STAA DDRA    ; Initialize port A for output
		   LDAA #$10
		   STAA DDRT
           
           
           
LOOP            LDAA #%10000000                 ; Initiate sample by writing to the ATDCTL5 register, bit0=0 for potentimeter
                STAA ATDCTL5
                BRCLR ADTSTAT0,%10000000,*                    ; Spin on ADTSTAT0 bit 7 to detect conversion complete
           
                LDAA ADT1DR1L   
				;LDAA $FF                             ; Read eight bit A/D data from ATD1DR1L
                ;STAA PORTA
				LDAB #%10000001								  ; Initiate sample by writing to the ATDCTL5 register, bit0=1 for thermometer
				STAB ATDCTL5
				BRCLR ADTSTAT0,%10000000,*
				
				LDAB ADT1DR1L
				
				CBA
				BLO LOWER
				
				STAB PORTA                                    ; Display raw A/D data on the LED bank
                BRA LOOP
				
LOWER			LDAB #$FF
				STAB PORTA
				;BSET PORTT,$10
				LDX #!500
ON				JSR Delay1MS
				DEX
				BNE ON
				LDAB #$00
				STAB PORTA
				;BCLR PORTT,$10
				LDX #!500
OFF				JSR Delay1MS
				DEX
				BNE OFF
				BRA LOOP
;delay:			LDX #!1000
;str:			DEX
	;			BNE str
		;		RTS
           
Delay1MS    					 LDAA #$90      
                                 STAA TSCR1
                                 LDAA #$03
								 STAA TSCR2
                                 LDAA #$10
                                 STAA TIOS
                                 LDAA #$01
                                 STAA TCTL1    ; Perform basic  timer initialization to setup an output compare on PT4
                                 LDD #$0
                                 STD TSCNT      ;added here
                                 LDD TSCNT
                                 ADDD #!1024
                                 STD TC4
                                 BRCLR TFLG1,$10,*
                                 RTS