TSCR1    EQU $46
TSCR2    EQU $4D
TIOS   	 EQU $40
TCTL1    EQU $48
TCTL2    EQU $49
TFLG1 	 EQU $4E
TIE      EQU $4C
TSCNT    EQU $44
TC4      EQU $58
TC1      EQU $52
PORTB    EQU $01
DDRB 	 EQU $03
PORTM    EQU $0250
DDRM     EQU $0252
 
           ORG $1000
DutyCycle ds 2 ; Use the “ds” processor directive to define two (2) bytes of storage which can be referenced…
Vary ds 1
          
             ORG $400
             LDAA #$90
             STAA TSCR1
             LDAA #$03
             STAA TSCR2
             LDAA #$10
             STAA TIOS
            
             LDD #0
             STD DutyCycle
            
INCREASE    LDD TSCNT
                                 ADDD DutyCycle
                                 STD TC4
                                 LDAA #$02
                                 STAA TCTL1
                                 BRCLR TFLG1,$10,*
                                 LDD TSCNT
                                 ADDD #!1000
                                 SUBD DutyCycle
                                 STD TC4
                                 LDAA #$03
                                 STAA TCTL1
                                 BRCLR TFLG1,$10,*
                                 LDAA Vary
                                 BEQ DECREASE
                                 LDX DutyCycle
                                 INX
 
                                 STX DutyCycle
                                 CPX #!500
                                 BLT INCREASE       ; loop if duty cycle not 900
                                 CLR Vary
                                 BRA INCREASE       ; loop to increase
 
 
DECREASE   LDX DutyCycle
                                 DEX
                                 STX DutyCycle
                                 CPX #!100
                                 BGE INCREASE
                                 LDAA 1
                                 STAA Vary
                                 BRA INCREASE