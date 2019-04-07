;asmfuncs

;启用FAT32位模式
[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]

[FILE "naskfunc.nas"]	;源文件名信息

;全局函数声明
	GLOBAL	_io_hlt, _io_cli, _io_sti, io_stihlt
	GLOBAL	_io_in8, _io_in16, _io_in32
	GLOBAL	_io_out8, _io_out16, _io_out32
	GLOBAL	_io_load_eflags, _io_store_eflags
	GLOBAL	_write_mem8,_init_Vcard

;函数列表
[SECTION .text]		;目标文件中包含文件再写入
	

			;相当于C语言的函数：
_io_hlt:	;void	io_hlt(void);
	HLT
	RET

_io_cli:	;void io_cli(void);
	CLI
	RET

_io_sti:	;void io_sti(void);
	STI
	RET

_io_stihlt:	;void io_stihlt(void);
	STI
	HLT
	RET

_io_in8:	;int io_in8(int port);
	MOV	EDX,[ESP+4]	;port
	MOV	EAX,0
	IN		AL,DX
	RET

_io_in16:	;int io_in16(int port);;
	MOV	EDX,[ESP+4]	;port
	MOV	EAX,0
	IN		AX,DX
	RET

_io_in32:	;int io_in32(int port);;
	MOV	EDX,[ESP+4]	;port
	IN		EAX,DX
	RET

_io_out8:	;int io_out8(int port,int data);
	MOV	EDX,[ESP+4]
	MOV	AL,[ESP+8]
	OUT	DX,AL
	RET

_io_out16:	;int io_out16(int port,int data);
	MOV	EDX,[ESP+4]
	MOV	EAX,[ESP+8]
	OUT	DX,AX
	RET

_io_out32:	;int io_out32(int port,int data);
	MOV	EDX,[ESP+4]
	MOV	EAX,[ESP+8]
	OUT	DX,EAX
	RET

_io_load_eflags:	;int io_eflags(void);
	PUSHFD		;push eflags
	POP	EAX
	RET

_io_store_eflags:	;void	io_store_eflags(int eflags);
	MOV	EAX,[ESP+4]
	PUSH	EAX
	POPFD		;pop eflags
	RET

;C语言向指定内存写入一字节数据
_write_mem8:	;void	write_mem8(int addr,int data)
	MOV	ECX,[ESP+4]	;[ESP+4]存放的是地址
	MOV	AL,[ESP+8]
	MOV	[ECX],AL
	RET

_init_Vcard:	;void	init_Vcard(void);
	MOV		AL,0x13			; VGAグラフィックス、320x200x8bitカラー
	MOV		AH,0x00
	INT		0x10
	RET









