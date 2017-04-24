TSCR1           EQU $46
TSCR2           EQU $4D
TIOS   EQU $40
TCTL1           EQU $48
TCTL2           EQU $49
TFLG1           EQU $4E
TIE      EQU $4C
TSCNT          EQU $44
TC4               EQU $58
TC1               EQU $52
PORTB          EQU $01
DDRB EQU $03
PORTM        EQU $0250
DDRM          EQU $0252
 
           ORG $400
           LDAA #$90
           STAA TSCR1                      ; Perform basic timer initialization to setup an output compare on PT4
           LDAA #$03
          
           STAA TSCR2
           LDAA #$10
           STAA TIOS
           LDAA #$01
           STAA TCTL1                                   ; Initialize register TCTL1 to toggle bit 4 on each compare event
 
TOP    LDD TSCNT                        ; Read current 16 bit value of TSCNT
           ADDD #$8       
           STD TC4                                         ; Add an offset to the current TSCNT equivalent to a 1ms delay and store to TC4
           BRCLR TFLG1,$10,*          ; Spin until the TFLG1 register indicates a bit 4 compare event
           BRA TOP