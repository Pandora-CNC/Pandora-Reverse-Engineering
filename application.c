#include <mach/w55fa93_gpio.h>

#define GPIO_GROUP_A 0
#define GPIO_GROUP_B 1
#define GPIO_GROUP_C 2
#define GPIO_GROUP_D 3
#define GPIO_GROUP_E 4

_DWORD gpio_reg_dir_2[7] = { 0, 16, 32, 48, 64, 0, 0 }; // idb
_DWORD gpio_reg_out_2[7] = { 8, 24, 40, 56, 72, 0, 0 }; // idb
_DWORD gpio_reg_in_2[7] = { 12, 28, 44, 60, 76, 0, 0 }; // idb
int extkey_5625 = 1; // local to this; not set anywhere else
int dword_1215F8 = 1; // weak
int dword_121614 = 1; // weak
int dword_121618 = 1; // weak

// In the region of the uservartable:
// These are certainly floats
float dword_164700; // weak
float dword_164704; // weak
float dword_164708; // weak
float dword_16470C; // weak

// GPIO usage:

// Keypad
// Group D, bit 0 is used for data in and data out; DIO
// Group D, bit 1 is used for latching the data; latches on rising edge; CLK
// Group D, bit 2 is some form of chip enable; active low; STB
	
#define KP_DIO 0
#define KP_CLK 1
#define KP_STB 2

#define KP_READKEYREGISTER 0x42

// I2C
// Group D, bit 14 is used for SCL
// Group D, bit 15 is used for SDA

#define I2C_SCL 14
#define I2C_SDA 15


void main(...)
{
	...
	// Read the hw-version information from the FPGA
	motionVer = RD_DATA(1);
	subMotionVer = RD_DATA(26);
	subMotionVer1 = RD_DATA(29);
	
	...
	int v354 = RD_DATA(19);
	if (motionVer != 28695 || subMotionVer == 2) {
      dword_164700 = (float)((v354 >> 3) & 1); // get the 4th bit
      dword_164704 = (float)((v354 >> 4) & 1); // get the 5th bit
    }
	
	if ((motionVer != 2057 || subMotionVer != 4) && subMotionVer != 6) {
      dword_164708 = 1.0f;
      v331 = userVarTable;
      dword_16470C = 1.0f;
    } else {
      dword_164708 = int2float((v354 >> 6) & 1);
      v331 = (_DWORD *)int2float((v354 >> 7) & 1);
      dword_16470C = (int)v331;
    }
}

signed int GUI_KEYBOARD_DRIVER_Init()
{
	char v1; // [sp+4h] [bp-10h]@1	

	// Initialize the keypad pins
	// DIO, OUTPUT, HIGH
	w55fa93_gpio_set_output(GPIO_GROUP_D, KP_DIO);
	w55fa93_gpio_set(GPIO_GROUP_D, KP_DIO, 1);
	// CLK, OUTPUT, HIGH
	w55fa93_gpio_set_output(GPIO_GROUP_D, KP_CLK);
	w55fa93_gpio_set(GPIO_GROUP_D, KP_CLK, 1);
	// STB, OUTPUT, HIGH
	w55fa93_gpio_set_output(GPIO_GROUP_D, KP_STB);
	w55fa93_gpio_set(GPIO_GROUP_D, KP_STB, 1);
  
	// Unknown pins are initialized
	w55fa93_gpio_set_input(GPIO_GROUP_D, 12);
	w55fa93_gpio_set_input(GPIO_GROUP_D, 13);

	// Create new scanning thread
	return pthread_create(&v1, 0, (int)ThreadReamKeyboard, 0);
}

int CH451_GetKeyCode()
{
	int i; // [sp+28h] [bp-24h]@1
	int j; // [sp+2Ch] [bp-20h]@5
	int retKeyCode = 0; // v24, [sp+34h] [bp-18h]@1
	char buf[20]; // v25, [sp+38h] [bp-14h]@6 // This is the buffer that we use to shift data in and out

	// this shifts out the value KP_READKEYREGISTER (byte)66 (0x42; 0b01000010) through DIO
	
	w55fa93_gpio_set(GPIO_GROUP_D, KP_STB, 0);
	for(i = 0; i <= 7; i++) {
		// shift out one bit at the time LSB to MSB
		w55fa93_gpio_set(GPIO_GROUP_D, KP_DIO, (KP_READKEYREGISTER >> i) & 1);
		w55fa93_gpio_set(GPIO_GROUP_D, KP_CLK, 0);
		w55fa93_gpio_set(GPIO_GROUP_D, KP_CLK, 1);
	}

	w55fa93_gpio_set_input(GPIO_GROUP_D, KP_DIO);
	usleep(1u); // sleep 1us

	for(i = 0; i <= 3; i++) {
		// More data shifting
		for(j = 0; j <= 7; j++) {
			w55fa93_gpio_set(GPIO_GROUP_D, KP_CLK, 0);
			buf[4 * i - 32] |= w55fa93_gpio_get(GPIO_GROUP_D, 0) << (7 - j);
			w55fa93_gpio_set(GPIO_GROUP_D, KP_CLK, 1);
		}
	}

	w55fa93_gpio_set(GPIO_GROUP_D, KP_STB, 1);
	w55fa93_gpio_set_output(GPIO_GROUP_D, KP_DIO);
	for(i = 0; i <= 3; i++) {
		// even more data shifting
		for(j = 0; j <= 7; j++) {
		  if(((buf[4 * i - 32] >> j) & 1) != ((keybuf_5624[i] >> j) & 1) ) {
			retKeyCode = 8 * i + j;
			if((buf[4 * i - 32] >> j) & 1 ) {
				retKeyCode |= 0x80u;
				keybuf_5624[i] |= 1 << j;
			} else {
				retKeyCode &= 0x7Fu;
				keybuf_5624[i] &= ~(1 << j);
			}
			break;
		  }
		}
	}

	if (!retKeyCode) {
		// check if we have to perform model specific changes
		if (motionVer != 28695 || subMotionVer == 2) {
			if ((int)dword_164700 == extkey_5625) {
				if ((int)dword_164704 == dword_1215F8) {
					if ((int)dword_164708 == dword_121614) {
						if ((int)dword_16470C != dword_121618) {
							if(dword_121618 = dword_121618 == 0)
								retKeyCode = 122;
							else
								retKeyCode = 250;
						}
				  } else {
					if(dword_121614 = dword_121614 == 0)
					  retKeyCode = 121;
					else
					  retKeyCode = 249;
				  }
				} else {
				  if(dword_1215F8 = dword_1215F8 == 0)
					retKeyCode = 114;
				  else
					retKeyCode = 242;
				}
			  } else {
				if (extkey_5625 = extkey_5625 == 0)
				  retKeyCode = 113;
				else
				  retKeyCode = 241;
			  }
		} else if (w55fa93_gpio_get(3, 12) == extkey_5625) {
			if(w55fa93_gpio_get(3, 13) != dword_1215F8) {
				if(dword_1215F8 = dword_1215F8 == 0)
				  retKeyCode = 114;
				else
				  retKeyCode = 242;
			  }
		} else {
			if (extkey_5625 = extkey_5625 == 0)
				retKeyCode = 113;
			else
				retKeyCode = 241;
		}
	}
	return retKeyCode;
}
