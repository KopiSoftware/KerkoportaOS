;Kerkoporta-ipl

CYLS	EQU	10

	ORG	0x7c00	;程序装载地址

	JMP	entry
	DB	0x90
	DB	"KERKOPTA"	;启动区名称
	DW	512		;单位扇区大小
	DB	1		;簇大小，必须为1个扇区

	DW	1		;FAT起始位置
	DB	2		;FAT的个数，必须为2
	DW	224		;根目录的大小
	DW	2880		;磁盘的大小，必须是2880扇区
	DB	0xf0		;磁盘的种类，必须是0xf0
	DW	9		;FAT的长度

	DW 	18		;1个磁道有几个扇区，必须是18
	DW	2		;磁头数，肯定是2
	DD	0		;不使用分区，则为0
	DD	2880		;重写一次磁盘大小
	DB	0,0,0x29	;固定写法
	DD	0xffffffff	;卷标号码
	DB	"KERKOPTA OS"	;磁盘名称11字节
	DB	"FAT12   "	;磁盘格式名称8字节
	RESB	18		;保留18个字节
	


;ipl功能部分

entry:
	MOV	AX,0
	MOV	SS,AX
	MOV	SP,0x7c00
	MOV	DS,AX		;AX初始化为0,再用AX初始化其他寄存器
	
;引导读取磁盘

	MOV	AX,0x0820
	MOV	ES,AX
	MOV	CH,0
	MOV	DH,0
	MOV	CL,2		;柱面0,磁头0,扇区2

readloop:
	MOV	SI,0

retry:
	MOV	AH,0x02
	MOV	AL,1		;1个扇区
	MOV	BX,0
	MOV	DL,0		;A驱动器
	INT	0x13		;调用磁盘bios，AH=0x02读盘，AL要处理的对象
	JNC	next		;没有出错就跳转到next，出错就重复5次
	ADD	SI,1		;自增
	CMP	SI,5		;检查循环次数
	JAE	read_failed	;5次读取失败跳转至错误信息显示处理
	
	MOV	AH,0x00
	MOV	DL,0x00		;重置寄存器
	INT	0x13
	JMP	retry

next:
	MOV	AX,ES
	ADD	AX,0x0020
	MOV	ES,AX		;将0x0020存储至ES，将内存地址后移至0x200
	ADD	CL,1
	CMP	CL,18		;重复读入18个扇区
	JBE	readloop
	
	MOV	CL,1
	ADD	DH,1		;变换磁头再次读取
	CMP	DH,2		
	JB	readloop
	
	MOV	DH,0		;返回磁头正面
	ADD	CH,1		;柱面自增
	CMP	CH,CYLS		;常数CYLS是10
	JB	readloop	;重复读入10个柱面
	JMP	read_success
	
read_failed:
	MOV	SI,rd_error_msg
	JMP	putloop
	JMP	fin

read_success:
	MOV	SI,rd_suces_msg
	JMP	putloop	
	JMP	fin

rd_error_msg:
	DB	0x0a,0x0a
	DB	"read disk error"
	DB	0x0a		;空格
	DB	0
	
rd_suces_msg:
	DB	0x0a,0x0a
	DB	"read disk success"
	DB	0x0a
	DB	0

putloop:
	MOV	AL,[SI]
	ADD	SI,1
	CMP	AL,0
	JE	fin
	MOV	AH,0x0e		;显示一个字符
	MOV	BX,15		;指定字符颜色
	INT	0x10
	JMP	putloop
	
	
fin:
	HLT
	JMP	fin
	
	RESB	0x7dfe-$	;将剩余内容填充为0
	DB	0x55,0xaa	;程序结束标志
