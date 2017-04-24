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
 
           ORG              $1000
DutyCycle               ds 2
           ORG              $400
           LDS #$4000
 
           LDAA #%11000000
           STAA ATDCTL2
           JSR Delay1MS
		   
		   LDAA #$90
           STAA TSCR1
           LDAA #$03
           STAA TSCR2  
           LDAA #$02
           STAA TIOS
           LDAA #$E5
           STAA ATDCTL4   
		   LDAA #$FF
           STAA DDRA    ; Initialize port A for output   
           
LOOP:       		  LDAA #%11100000                       ; Initiate sample by writing to the ATDCTL5 register. See the note below. (FROM PART 2)
                      STAA ATDCTL5
                      BRCLR ADTSTAT0,%10000000,*            ; Spin on ADTSTAT0 bit 7 to detect conversion complete (FROM PART 2)
                      
                      
                      LDAA ADT1DR1L                         ; Read eight bit A/D data from ATD1DR1L (FROM PART 2)
                      LDAB #4
                      MUL
                      STD DutyCycle
                      LDD TSCNT                             ;load duty cycle into tscnt
                      ADDD DutyCycle                                              
                      STD TC1
                      LDAA #$0C
                      STAA TCTL2
                      BRCLR TFLG1,$02,*                     ;SPIN UNTIL TFLG1 DETECTS
                      
                      LDD TSCNT
                      ADDD #!1024                           ;CHANGED TO 1024 FROM 1000 AS PER LAB INSTRUCTIONS
                      SUBD DutyCycle                        ;subtract dutycyle from D
                      STD TC1                               ;store into TC1
                      LDAA #$08
                      STAA TCTL2
                      BRCLR TFLG1,$02,*                     ;SPIN UNTIL TFLG1 DETECTS
                      BRA LOOP
          
Delay1MS    LDAA #$90      						;FROM LAB2ASSIGNMENT3 (AND THEN FROM LAB3ASSIGNMENT2)
            STAA TSCR1
            LDAA #$03
			STAA TSCR2
            LDAA #$10
            STAA TIOS
            LDAA #$01
            STAA TCTL1    				; Perform basic  timer initialization to setup an output compare on PT4
                                 
            LDD #$0
            STD TSCNT      			;added here
                                 
            LDD TSCNT
            ADDD #!1000
            STD TC4
            BRCLR TFLG1,$10,*
            RTS