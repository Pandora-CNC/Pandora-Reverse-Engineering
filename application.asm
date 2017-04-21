; =============== S U B	R O U T	I N E =======================================

; Attributes: bp-based frame

CH451_GetKeyCode			; CODE XREF: ThreadReamKeyboard+1B0p

var_4C		= -0x4C
var_48		= -0x48
var_44		= -0x44
var_40		= -0x40
var_3C		= -0x3C
var_38		= -0x38
var_34		= -0x34
var_30		= -0x30
var_2C		= -0x2C
var_28		= -0x28
var_24		= -0x24
var_20		= -0x20
var_1C		= -0x1C
var_18		= -0x18
var_14		= -0x14

		MOV		R12, SP
		STMFD		SP!, {R4,R5,R11,R12,LR,PC}
		SUB		R11, R12, #4
		SUB		SP, SP,	#0x38
		MOV		R3, #0x42
		STR		R3, [R11,#var_1C]
		MOV		R3, #0
		STR		R3, [R11,#var_18]
		MOV		R3, #0
		STR		R3, [R11,#var_28]
		LDR		R3, [R11,#var_28]
		STR		R3, [R11,#var_2C]
		LDR		R3, [R11,#var_2C]
		STR		R3, [R11,#var_30]
		LDR		R3, [R11,#var_30]
		STR		R3, [R11,#var_34]
		MOV		R0, #3
		MOV		R1, #2
		MOV		R2, #0
		BL		w55fa93_gpio_set
		MOV		R3, #0
		STR		R3, [R11,#var_24]
		B		loc_72C4C
; ---------------------------------------------------------------------------

loc_72C00				; CODE XREF: CH451_GetKeyCode+B0j
		LDR		R2, [R11,#var_1C]
		LDR		R3, [R11,#var_24]
		MOV		R3, R2,ASR R3
		AND		R3, R3,	#1
		MOV		R0, #3
		MOV		R1, #0
		MOV		R2, R3
		BL		w55fa93_gpio_set
		MOV		R0, #3
		MOV		R1, #1
		MOV		R2, #0
		BL		w55fa93_gpio_set
		MOV		R0, #3
		MOV		R1, #1
		MOV		R2, #1
		BL		w55fa93_gpio_set
		LDR		R3, [R11,#var_24]
		ADD		R3, R3,	#1
		STR		R3, [R11,#var_24]

loc_72C4C				; CODE XREF: CH451_GetKeyCode+58j
		LDR		R3, [R11,#var_24]
		CMP		R3, #7
		BLE		loc_72C00
		MOV		R0, #3
		MOV		R1, #0
		BL		w55fa93_gpio_set_input
		MOV		R0, #1
		BL		usleep
		MOV		R3, #0
		STR		R3, [R11,#var_24]
		B		loc_72D20
; ---------------------------------------------------------------------------

loc_72C78				; CODE XREF: CH451_GetKeyCode+184j
		MOV		R3, #0
		STR		R3, [R11,#var_20]
		B		loc_72D08
; ---------------------------------------------------------------------------

loc_72C84				; CODE XREF: CH451_GetKeyCode+16Cj
		MOV		R0, #3
		MOV		R1, #1
		MOV		R2, #0
		BL		w55fa93_gpio_set
		LDR		R5, [R11,#var_24]
		LDR		R3, [R11,#var_24] ; R3 = R11 + #var_24
		MOV		R2, #0xFFFFFFE0   ; R2 = -32
		MOV		R3, R3,LSL#2      ; R3 *= 4
		SUB		R0, R11, #-var_14 ; R0 = R11 - #-var_14
		ADD		R3, R3,	R0	; R3 = R3 + R0
		ADD		R3, R3,	R2	; R3 = R3 + R2
		LDR		R4, [R3]	; R4 = *R3  =>  R4 = *( (R11 + #var_24)*4 + (R11 - #-var_14) - 32)
		MOV		R0, #3		; R0 = 3
		MOV		R1, #0		; R1 = 0
		BL		w55fa93_gpio_get
		MOV		R2, R0
		LDR		R3, [R11,#var_20]
		RSB		R3, R3,	#7
		MOV		R3, R2,LSL R3
		ORR		R1, R4,	R3
		MOV		R2, #0xFFFFFFE0   ;R2 = -32
		MOV		R3, R5,LSL#2
		SUB		R0, R11, #-var_14
		ADD		R3, R3,	R0
		ADD		R3, R3,	R2
		STR		R1, [R3]
		MOV		R0, #3
		MOV		R1, #1
		MOV		R2, #1
		BL		w55fa93_gpio_set
		LDR		R3, [R11,#var_20]
		ADD		R3, R3,	#1
		STR		R3, [R11,#var_20]

loc_72D08				; CODE XREF: CH451_GetKeyCode+DCj
		LDR		R3, [R11,#var_20]
		CMP		R3, #7
		BLE		loc_72C84
		LDR		R3, [R11,#var_24]
		ADD		R3, R3,	#1
		STR		R3, [R11,#var_24]

loc_72D20				; CODE XREF: CH451_GetKeyCode+D0j
		LDR		R3, [R11,#var_24]
		CMP		R3, #3
		BLE		loc_72C78
		MOV		R0, #3
		MOV		R1, #2
		MOV		R2, #1
		BL		w55fa93_gpio_set
		MOV		R0, #3
		MOV		R1, #0
		BL		w55fa93_gpio_set_output
		MOV		R3, #0
		STR		R3, [R11,#var_24]
		B		loc_72E88
; ---------------------------------------------------------------------------

loc_72D54				; CODE XREF: CH451_GetKeyCode+2ECj
		MOV		R3, #0
		STR		R3, [R11,#var_20]
		B		loc_72E70
; ---------------------------------------------------------------------------

loc_72D60				; CODE XREF: CH451_GetKeyCode+2D4j
		LDR		R3, [R11,#var_24]
		MOV		R2, #0xFFFFFFE0
		MOV		R3, R3,LSL#2
		SUB		R1, R11, #-var_14
		ADD		R3, R3,	R1
		ADD		R3, R3,	R2
		LDR		R2, [R3]
		LDR		R3, [R11,#var_20]
		MOV		R3, R2,ASR R3
		AND		R1, R3,	#1
		LDR		R2, [R11,#var_24]
		LDR		R3, =keybuf.5624
		LDR		R2, [R3,R2,LSL#2]
		LDR		R3, [R11,#var_20]
		MOV		R3, R2,ASR R3
		AND		R3, R3,	#1
		CMP		R1, R3
		BEQ		loc_72E64
		LDR		R3, [R11,#var_24]
		MOV		R2, R3,LSL#3
		LDR		R3, [R11,#var_20]
		ADD		R3, R2,	R3
		STR		R3, [R11,#var_18]
		LDR		R3, [R11,#var_24]
		MOV		R2, #0xFFFFFFE0
		MOV		R3, R3,LSL#2
		SUB		R0, R11, #-var_14
		ADD		R3, R3,	R0
		ADD		R3, R3,	R2
		LDR		R2, [R3]
		LDR		R3, [R11,#var_20]
		MOV		R3, R2,ASR R3
		AND		R3, R3,	#1
		AND		R3, R3,	#0xFF
		CMP		R3, #0
		BEQ		loc_72E28
		LDR		R3, [R11,#var_18]
		ORR		R3, R3,	#0x80
		STR		R3, [R11,#var_18]
		LDR		R0, [R11,#var_24]
		LDR		R2, [R11,#var_24]
		LDR		R3, =keybuf.5624
		LDR		R1, [R3,R2,LSL#2]
		MOV		R2, #1
		LDR		R3, [R11,#var_20]
		MOV		R3, R2,LSL R3
		ORR		R2, R1,	R3
		LDR		R3, =keybuf.5624
		STR		R2, [R3,R0,LSL#2]
		B		loc_72E7C
; ---------------------------------------------------------------------------

loc_72E28				; CODE XREF: CH451_GetKeyCode+248j
		LDR		R3, [R11,#var_18]
		AND		R3, R3,	#0x7F
		STR		R3, [R11,#var_18]
		LDR		R0, [R11,#var_24]
		LDR		R2, [R11,#var_24]
		LDR		R3, =keybuf.5624
		LDR		R1, [R3,R2,LSL#2]
		MOV		R2, #1
		LDR		R3, [R11,#var_20]
		MOV		R3, R2,LSL R3
		MVN		R3, R3
		AND		R2, R1,	R3
		LDR		R3, =keybuf.5624
		STR		R2, [R3,R0,LSL#2]
		B		loc_72E7C
; ---------------------------------------------------------------------------

loc_72E64				; CODE XREF: CH451_GetKeyCode+200j
		LDR		R3, [R11,#var_20]
		ADD		R3, R3,	#1
		STR		R3, [R11,#var_20]

loc_72E70				; CODE XREF: CH451_GetKeyCode+1B8j
		LDR		R3, [R11,#var_20]
		CMP		R3, #7
		BLE		loc_72D60

loc_72E7C				; CODE XREF: CH451_GetKeyCode+280j
					; CH451_GetKeyCode+2BCj
		LDR		R3, [R11,#var_24]
		ADD		R3, R3,	#1
		STR		R3, [R11,#var_24]

loc_72E88				; CODE XREF: CH451_GetKeyCode+1ACj
		LDR		R3, [R11,#var_24]
		CMP		R3, #3
		BLE		loc_72D54
		LDR		R3, [R11,#var_18]
		CMP		R3, #0
		BNE		loc_73158
		LDR		R3, =motionVer
		LDR		R2, [R3]
		LDR		R3, =0x7017
		CMP		R2, R3
		BNE		loc_72F9C
		LDR		R3, =subMotionVer
		LDR		R3, [R3]
		CMP		R3, #2
		BEQ		loc_72F9C
		MOV		R0, #3
		MOV		R1, #0xC
		BL		w55fa93_gpio_get
		MOV		R3, R0
		LDR		R2, =extkey.5625
		LDR		R2, [R2]
		CMP		R3, R2
		BEQ		loc_72F30
		LDR		R3, =extkey.5625
		LDR		R3, [R3]
		CMP		R3, #0
		MOVNE		R2, #0
		MOVEQ		R2, #1
		LDR		R3, =extkey.5625
		STR		R2, [R3]
		LDR		R3, =extkey.5625
		LDR		R3, [R3]
		CMP		R3, #0
		BNE		loc_72F1C
		MOV		R1, #0xF1
		STR		R1, [R11,#var_4C]
		B		loc_72F24
; ---------------------------------------------------------------------------

loc_72F1C				; CODE XREF: CH451_GetKeyCode+368j
		MOV		R3, #0x71
		STR		R3, [R11,#var_4C]

loc_72F24				; CODE XREF: CH451_GetKeyCode+374j
		LDR		R0, [R11,#var_4C]
		STR		R0, [R11,#var_18]
		B		loc_73158
; ---------------------------------------------------------------------------

loc_72F30				; CODE XREF: CH451_GetKeyCode+33Cj
		MOV		R0, #3
		MOV		R1, #0xD
		BL		w55fa93_gpio_get
		MOV		R3, R0
		LDR		R2, =extkey.5625
		LDR		R2, [R2,#(dword_1215F8 - 0x1215F4)]
		CMP		R3, R2
		BEQ		loc_73158
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_1215F8 - 0x1215F4)]
		CMP		R3, #0
		MOVNE		R2, #0
		MOVEQ		R2, #1
		LDR		R3, =extkey.5625
		STR		R2, [R3,#(dword_1215F8 - 0x1215F4)]
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_1215F8 - 0x1215F4)]
		CMP		R3, #0
		BNE		loc_72F88
		MOV		R1, #0xF2
		STR		R1, [R11,#var_48]
		B		loc_72F90
; ---------------------------------------------------------------------------

loc_72F88				; CODE XREF: CH451_GetKeyCode+3D4j
		MOV		R3, #0x72
		STR		R3, [R11,#var_48]

loc_72F90				; CODE XREF: CH451_GetKeyCode+3E0j
		LDR		R0, [R11,#var_48]
		STR		R0, [R11,#var_18]
		B		loc_73158
; ---------------------------------------------------------------------------

loc_72F9C				; CODE XREF: CH451_GetKeyCode+30Cj
					; CH451_GetKeyCode+31Cj
		LDR		R3, =userVarTable
		LDR		R3, [R3,#(dword_164700 - 0x163770)]
		MOV		R0, R3
		BL		__fixsfsi
		MOV		R2, R0
		LDR		R3, =extkey.5625
		LDR		R3, [R3]
		CMP		R2, R3
		BEQ		loc_7300C
		LDR		R3, =extkey.5625
		LDR		R3, [R3]
		CMP		R3, #0
		MOVNE		R2, #0
		MOVEQ		R2, #1
		LDR		R3, =extkey.5625
		STR		R2, [R3]
		LDR		R3, =extkey.5625
		LDR		R3, [R3]
		CMP		R3, #0
		BNE		loc_72FF8
		MOV		R1, #0xF1
		STR		R1, [R11,#var_44]
		B		loc_73000
; ---------------------------------------------------------------------------

loc_72FF8				; CODE XREF: CH451_GetKeyCode+444j
		MOV		R3, #0x71
		STR		R3, [R11,#var_44]

loc_73000				; CODE XREF: CH451_GetKeyCode+450j
		LDR		R0, [R11,#var_44]
		STR		R0, [R11,#var_18]
		B		loc_73158
; ---------------------------------------------------------------------------

loc_7300C				; CODE XREF: CH451_GetKeyCode+418j
		LDR		R3, =userVarTable
		LDR		R3, [R3,#(dword_164704 - 0x163770)]
		MOV		R0, R3
		BL		__fixsfsi
		MOV		R2, R0
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_1215F8 - 0x1215F4)]
		CMP		R2, R3
		BEQ		loc_7307C
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_1215F8 - 0x1215F4)]
		CMP		R3, #0
		MOVNE		R2, #0
		MOVEQ		R2, #1
		LDR		R3, =extkey.5625
		STR		R2, [R3,#(dword_1215F8 - 0x1215F4)]
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_1215F8 - 0x1215F4)]
		CMP		R3, #0
		BNE		loc_73068
		MOV		R1, #0xF2
		STR		R1, [R11,#var_40]
		B		loc_73070
; ---------------------------------------------------------------------------

loc_73068				; CODE XREF: CH451_GetKeyCode+4B4j
		MOV		R3, #0x72
		STR		R3, [R11,#var_40]

loc_73070				; CODE XREF: CH451_GetKeyCode+4C0j
		LDR		R0, [R11,#var_40]
		STR		R0, [R11,#var_18]
		B		loc_73158
; ---------------------------------------------------------------------------

loc_7307C				; CODE XREF: CH451_GetKeyCode+488j
		LDR		R3, =userVarTable
		LDR		R3, [R3,#(dword_164708 - 0x163770)]
		MOV		R0, R3
		BL		__fixsfsi
		MOV		R2, R0
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_121614 - 0x1215F4)]
		CMP		R2, R3
		BEQ		loc_730EC
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_121614 - 0x1215F4)]
		CMP		R3, #0
		MOVNE		R2, #0
		MOVEQ		R2, #1
		LDR		R3, =extkey.5625
		STR		R2, [R3,#(dword_121614 - 0x1215F4)]
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_121614 - 0x1215F4)]
		CMP		R3, #0
		BNE		loc_730D8
		MOV		R1, #0xF9
		STR		R1, [R11,#var_3C]
		B		loc_730E0
; ---------------------------------------------------------------------------

loc_730D8				; CODE XREF: CH451_GetKeyCode+524j
		MOV		R3, #0x79
		STR		R3, [R11,#var_3C]

loc_730E0				; CODE XREF: CH451_GetKeyCode+530j
		LDR		R0, [R11,#var_3C]
		STR		R0, [R11,#var_18]
		B		loc_73158
; ---------------------------------------------------------------------------

loc_730EC				; CODE XREF: CH451_GetKeyCode+4F8j
		LDR		R3, =userVarTable
		LDR		R3, [R3,#(dword_16470C - 0x163770)]
		MOV		R0, R3
		BL		__fixsfsi
		MOV		R2, R0
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_121618 - 0x1215F4)]
		CMP		R2, R3
		BEQ		loc_73158
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_121618 - 0x1215F4)]
		CMP		R3, #0
		MOVNE		R2, #0
		MOVEQ		R2, #1
		LDR		R3, =extkey.5625
		STR		R2, [R3,#(dword_121618 - 0x1215F4)]
		LDR		R3, =extkey.5625
		LDR		R3, [R3,#(dword_121618 - 0x1215F4)]
		CMP		R3, #0
		BNE		loc_73148
		MOV		R1, #0xFA
		STR		R1, [R11,#var_38]
		B		loc_73150
; ---------------------------------------------------------------------------

loc_73148				; CODE XREF: CH451_GetKeyCode+594j
		MOV		R3, #0x7A
		STR		R3, [R11,#var_38]

loc_73150				; CODE XREF: CH451_GetKeyCode+5A0j
		LDR		R0, [R11,#var_38]
		STR		R0, [R11,#var_18]

loc_73158				; CODE XREF: CH451_GetKeyCode+2F8j
					; CH451_GetKeyCode+388j ...
		LDR		R3, [R11,#var_18]
		MOV		R0, R3
		SUB		SP, R11, #0x14
		LDMFD		SP, {R4,R5,R11,SP,PC}
; End of function CH451_GetKeyCode

; ---------------------------------------------------------------------------
off_73168	DCD keybuf.5624		; DATA XREF: CH451_GetKeyCode+1E8r
					; CH451_GetKeyCode+260r ...
off_7316C	DCD motionVer		; DATA XREF: CH451_GetKeyCode+2FCr
dword_73170	DCD 0x7017		; DATA XREF: CH451_GetKeyCode+304r
off_73174	DCD subMotionVer	; DATA XREF: CH451_GetKeyCode+310r
off_73178	DCD extkey.5625		; DATA XREF: CH451_GetKeyCode+330r
					; CH451_GetKeyCode+340r ...
off_7317C	DCD userVarTable	; DATA XREF: CH451_GetKeyCode:loc_72F9Cr
					; CH451_GetKeyCode:loc_7300Cr ...
