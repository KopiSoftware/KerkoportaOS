#include<stdio.h>

//定义常用颜色
#define COL8_000000 0
#define COL8_FF0000 1
#define COL8_00FF00 2
#define COL8_FFFF00 3
#define COL8_0000FF 4
#define COL8_FF00FF 5
#define COL8_00FFFF 6
#define COL8_FFFFFF 7
#define COL8_C6C6C6 8
#define COL8_840000 9
#define COL8_008400 10
#define COL8_848400 11
#define COL8_000084 12
#define COL8_840084 13
#define COL8_008484 14
#define COL8_848484 15


//asm函数声明部分
void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);
void init_Vcard(void);

//C语言函数声明部分
void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);
void draw_box(unsigned char *vram, int xsize, unsigned char c, int x0, int y0,int x1, int y1);
void fill_screen(unsigned char c);



//主函数部分
void HariMain(void)
{
	
	char *p;
	int i;

//	init_Vcard();
	init_palette();
	p = (char *) 0xa0000;

	for(i = 0; i < 16; i++ )
		draw_box(p, 320, i, 0, 0, 320, 200);


	for(;;)
		io_hlt();


}

void init_palette(void)
{
	static unsigned char table_rgb[16*3] = {
		0x00,0x00,0x00,		//黑色
		0xff,0x00,0x00,		//亮红
		0x00,0xff,0x00,		//亮绿
		0xff,0xff,0x00,		//亮黄
		0x00,0x00,0xff,		//亮蓝
		0xff,0x00,0xff,		//亮紫
		0x00,0xff,0xff,		//浅亮蓝
		0xff,0xff,0xff,		//白
		0xc6,0xc6,0xc6,		//亮灰
		0x84,0x00,0x00,		//暗红
		0x00,0x84,0x00,		//暗绿
		0x84,0x84,0x00,		//暗黄
		0x00,0x00,0x84,		//暗青
		0x84,0x00,0x84,		//暗紫
		0x00,0x84,0x84,		//浅暗蓝
		0x84,0x84,0x84		//暗灰
	};				//定义rgb颜色集

	set_palette(0, 15, table_rgb);
	return;
}


void set_palette(int start, int end, unsigned char * rgb)
{
	int i,eflags;

	eflags = io_load_eflags();
	io_cli();			//将中断设为0,禁止其他中断

	io_out8(0x03c8, start);

	for(i=start; i<=end; i++){
		io_out8(0x03c9, rgb[0]/4);
		io_out8(0x03c9, rgb[1]/4);
		io_out8(0x03c9, rgb[2]/4);
		rgb += 3;
	}

	io_store_eflags(eflags);	//恢复中断许可	
	return;	
}

//画出填充色框
void draw_box(unsigned char *vram, int xsize, unsigned char c, int x0, int y0,int x1, int y1)
{
	int x,y;
	for(y = y0; y <= y1; y++)
		for(x = x0; x <= x1;x++)
			vram[y * xsize + x] = c;
	return;
}

void fill_screen(unsigned char c)
{
	int i;
	char *p;

	p = (char*)0xa0000;
	for(i = 0; i<= 0xffff;i++)
		*(p + i) = 0;
}
