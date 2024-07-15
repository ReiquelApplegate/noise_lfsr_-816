.ifndef S_LFSR
S_LFSR = 1

.segment "ZEROPAGE"
xor_result_in_bit_14:   .res 2
lfsr:                   .res 2
xor_table:              .res 4

.segment "CODE"

.proc noise_lfsr_emu
seta16

; setup XOR result table
LDA #0
STA xor_table
STA xor_table+3
LDA #1
STA xor_table+1
STA xor_table+2

; init seed is $4000 - can't use zero because it will get stuck
LDA #$4000
STA lfsr

loop:
LDA #$0003 ; mask for bottom 2 bits
AND lfsr   ; bottom 2 bits of lfsr are now in accum
TAX
LDA xor_table, X    ; accum now contains XOR result
ROR                 ; XOR result now in carry flag
ROR                 ; XOR result now in bit 15 of accum
AND #$8000          ; accum now contains just XOR result in bit 15
LSR                 ; accum now contains just XOR result in bit 14
STA xor_result_in_bit_14

LDA lfsr
LSR                 ; "rotate"
ORA xor_result_in_bit_14    ; we now have the new output
STA lfsr

BRA loop

.endproc

.endif