#pragma once
typedef int i32;
typedef unsigned int u32;
typedef unsigned char u8;
_Static_assert(sizeof(i32) == 4, "");
_Static_assert(sizeof(u32) == 4, "");
_Static_assert(sizeof(u8) == 1, "");

#define sysv __attribute__((sysv_abi))
