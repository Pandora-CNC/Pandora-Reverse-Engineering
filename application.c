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

int CH451_GetKeyCode()
{
  int v0; // r1@4
  int v1; // r2@4
  int v2; // r5@6
  int v3; // r4@6
  int v4; // r2@24
  int v5; // r2@29
  int v6; // r2@34
  int v7; // r2@39
  int v8; // r2@44
  int v9; // r2@49
  signed int v11; // [sp+0h] [bp-4Ch]@25
  signed int v12; // [sp+4h] [bp-48h]@30
  signed int v13; // [sp+8h] [bp-44h]@35
  signed int v14; // [sp+Ch] [bp-40h]@40
  signed int v15; // [sp+10h] [bp-3Ch]@45
  signed int v16; // [sp+14h] [bp-38h]@50
  int v17 = 0; // [sp+18h] [bp-34h]@1
  int v18 = 0; // [sp+1Ch] [bp-30h]@1
  int v19 = 0; // [sp+20h] [bp-2Ch]@1
  int v20 = 0; // [sp+24h] [bp-28h]@1
  int i; // [sp+28h] [bp-24h]@1
  int j; // [sp+2Ch] [bp-20h]@5
  int v23 = 66; // [sp+30h] [bp-1Ch]@1
  int v24 = 0; // [sp+34h] [bp-18h]@1
  char v25[20]; // [sp+38h] [bp-14h]@6

  w55fa93_gpio_set(GPIO_GROUP_D, 2, 0);
  for ( i = 0; i <= 7; ++i )
  {
    w55fa93_gpio_set(GPIO_GROUP_D, 0, (v23 >> i) & 1);
    w55fa93_gpio_set(GPIO_GROUP_D, 1, 0);
    w55fa93_gpio_set(GPIO_GROUP_D, 1, 1);
  }
  w55fa93_gpio_set_input(GPIO_GROUP_D, 0);
  usleep(1u, v0, v1);
  for ( i = 0; i <= 3; ++i )
  {
    for ( j = 0; j <= 7; ++j )
    {
      w55fa93_gpio_set(GPIO_GROUP_D, 1, 0);
      v2 = i;
      v3 = *(_DWORD *)&v25[4 * i - 32];
      *(_DWORD *)&v25[4 * v2 - 32] = v3 | (w55fa93_gpio_get(GPIO_GROUP_D, 0) << (7 - j));
      w55fa93_gpio_set(GPIO_GROUP_D, 1, 1);
    }
  }
  w55fa93_gpio_set(GPIO_GROUP_D, 2, 1);
  w55fa93_gpio_set_output(GPIO_GROUP_D, 0);
  for ( i = 0; i <= 3; ++i ) {
    for ( j = 0; j <= 7; ++j ) {
      if ( ((*(_DWORD *)&v25[4 * i - 32] >> j) & 1) != ((keybuf_5624[i] >> j) & 1) ) {
        v24 = 8 * i + j;
        if ( (*(_DWORD *)&v25[4 * i - 32] >> j) & 1 )
        {
          v24 |= 0x80u;
          keybuf_5624[i] |= 1 << j;
        }
        else
        {
          v24 &= 0x7Fu;
          keybuf_5624[i] &= ~(1 << j);
        }
        break;
      }
    }
  }
  
  
  if (!v24) {
	// check if we have to perform model specific changes
    if (motionVer != 28695 || subMotionVer == 2) {
      if ( float2int(dword_164700) == extkey_5625 ) { // float2int == float2int
        if ( float2int(dword_164704) == dword_1215F8 )
        {
          if ( float2int(dword_164708) == dword_121614 )
          {
            if ( float2int(dword_16470C) != dword_121618 )
            {
              v9 = dword_121618 == 0;
              dword_121618 = dword_121618 == 0;
              if ( v9 )
                v16 = 122;
              else
                v16 = 250;
              v24 = v16;
            }
          }
          else
          {
            v8 = dword_121614 == 0;
            dword_121614 = dword_121614 == 0;
            if ( v8 )
              v15 = 121;
            else
              v15 = 249;
            v24 = v15;
          }
        }
        else
        {
          v7 = dword_1215F8 == 0;
          dword_1215F8 = dword_1215F8 == 0;
          if ( v7 )
            v14 = 114;
          else
            v14 = 242;
          v24 = v14;
        }
      }
      else
      {
        v6 = extkey_5625 == 0;
        extkey_5625 = extkey_5625 == 0;
        if ( v6 )
          v13 = 113;
        else
          v13 = 241;
        v24 = v13;
      }
    }
    else if ( w55fa93_gpio_get(3, 12) == extkey_5625 )
    {
      if ( w55fa93_gpio_get(3, 13) != dword_1215F8 )
      {
        v5 = dword_1215F8 == 0;
        dword_1215F8 = dword_1215F8 == 0;
        if ( v5 )
          v12 = 114;
        else
          v12 = 242;
        v24 = v12;
      }
    }
    else
    {
      v4 = extkey_5625 == 0;
      extkey_5625 = extkey_5625 == 0;
      if ( v4 )
        v11 = 113;
      else
        v11 = 241;
      v24 = v11;
    }
  }
  return v24;
}
