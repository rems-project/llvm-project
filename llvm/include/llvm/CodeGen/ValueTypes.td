//===- ValueTypes.td - ValueType definitions ---------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Value types - These values correspond to the register types defined in the
// MachineValueTypes.h file.  If you update anything here, you must update it
// there as well!
//
//===----------------------------------------------------------------------===//

class ValueType<int size, int value> {
  string Namespace = "MVT";
  int Size = size;
  int Value = value;
}

def OtherVT: ValueType<0  ,  1>;   // "Other" value
def i1     : ValueType<1  ,  2>;   // One bit boolean value
def i8     : ValueType<8  ,  3>;   // 8-bit integer value
def i16    : ValueType<16 ,  4>;   // 16-bit integer value
def i32    : ValueType<32 ,  5>;   // 32-bit integer value
def i64    : ValueType<64 ,  6>;   // 64-bit integer value
def i128   : ValueType<128,  7>;   // 128-bit integer value
def f16    : ValueType<16 ,  8>;   // 16-bit floating point value
def f32    : ValueType<32 ,  9>;   // 32-bit floating point value
def f64    : ValueType<64 , 10>;   // 64-bit floating point value
def f80    : ValueType<80 , 11>;   // 80-bit floating point value
def f128   : ValueType<128, 12>;   // 128-bit floating point value
def ppcf128: ValueType<128, 13>;   // PPC 128-bit floating point value

def iFATPTR64: ValueType<64, 14>;   // 256-bit fat pointer.
def iFATPTR128: ValueType<128, 15>;   // 256-bit fat pointer.
def iFATPTR256: ValueType<256, 16>;   // 256-bit fat pointer.
def iFATPTR512: ValueType<512, 17>;   // 256-bit fat pointer.
def iFATPTRAny: ValueType<0, 18>;   // 256-bit fat pointer.

def v1i1   : ValueType<1 ,  19>;   //   1 x i1 vector value
def v2i1   : ValueType<2 ,  20>;   //   2 x i1 vector value
def v4i1   : ValueType<4 ,  21>;   //   4 x i1 vector value
def v8i1   : ValueType<8 ,  22>;   //   8 x i1 vector value
def v16i1  : ValueType<16,  23>;   //  16 x i1 vector value
def v32i1  : ValueType<32 , 24>;   //  32 x i1 vector value
def v64i1  : ValueType<64 , 25>;   //  64 x i1 vector value
def v128i1 : ValueType<128, 26>;   // 128 x i1 vector value
def v256i1 : ValueType<256, 27>;   // 256 x i1 vector value
def v512i1 : ValueType<512, 28>;   // 512 x i1 vector value
def v1024i1: ValueType<1024,29>;   //1024 x i1 vector value

def v1i8   : ValueType<8,   30>;   //  1 x i8  vector value
def v2i8   : ValueType<16 , 31>;   //  2 x i8  vector value
def v4i8   : ValueType<32 , 32>;   //  4 x i8  vector value
def v8i8   : ValueType<64 , 33>;   //  8 x i8  vector value
def v16i8  : ValueType<128, 34>;   // 16 x i8  vector value
def v32i8  : ValueType<256, 35>;   // 32 x i8  vector value
def v64i8  : ValueType<512, 36>;   // 64 x i8  vector value
def v128i8 : ValueType<1024,37>;   //128 x i8  vector value
def v256i8 : ValueType<2048,38>;   //256 x i8  vector value

def v1i16  : ValueType<16 , 39>;   //  1 x i16 vector value
def v2i16  : ValueType<32 , 40>;   //  2 x i16 vector value
def v3i16  : ValueType<48 , 41>;   //  3 x i16 vector value
def v4i16  : ValueType<64 , 42>;   //  4 x i16 vector value
def v8i16  : ValueType<128, 43>;   //  8 x i16 vector value
def v16i16 : ValueType<256, 44>;   // 16 x i16 vector value
def v32i16 : ValueType<512, 45>;   // 32 x i16 vector value
def v64i16 : ValueType<1024,46>;   // 64 x i16 vector value
def v128i16: ValueType<2048,47>;   //128 x i16 vector value

def v1i32    : ValueType<32 , 48>;   //  1 x i32 vector value
def v2i32    : ValueType<64 , 49>;   //  2 x i32 vector value
def v3i32    : ValueType<96 , 50>;   //  3 x i32 vector value
def v4i32    : ValueType<128, 51>;   //  4 x i32 vector value
def v5i32    : ValueType<160, 52>;   //  5 x i32 vector value
def v8i32    : ValueType<256, 53>;   //  8 x i32 vector value
def v16i32   : ValueType<512, 54>;   // 16 x i32 vector value
def v32i32   : ValueType<1024,55>;   // 32 x i32 vector value
def v64i32   : ValueType<2048,56>;   // 64 x i32 vector value
def v128i32  : ValueType<4096,57>;   // 128 x i32 vector value
def v256i32  : ValueType<8182,58>;   // 256 x i32 vector value
def v512i32  : ValueType<16384,59>;  // 512 x i32 vector value
def v1024i32 : ValueType<32768,60>;  // 1024 x i32 vector value
def v2048i32 : ValueType<65536,61>;  // 2048 x i32 vector value

def v1i64  : ValueType<64 , 62>;   //  1 x i64 vector value
def v2i64  : ValueType<128, 63>;   //  2 x i64 vector value
def v4i64  : ValueType<256, 64>;   //  4 x i64 vector value
def v8i64  : ValueType<512, 65>;   //  8 x i64 vector value
def v16i64 : ValueType<1024,66>;   // 16 x i64 vector value
def v32i64 : ValueType<2048,67>;   // 32 x i64 vector value

def v1i128 : ValueType<128, 68>;   //  1 x i128 vector value

def v2f16    : ValueType<32 , 69>;    //    2 x f16 vector value
def v3f16    : ValueType<48 , 70>;    //    3 x f16 vector value
def v4f16    : ValueType<64 , 71>;    //    4 x f16 vector value
def v8f16    : ValueType<128, 72>;    //    8 x f16 vector value
def v16f16   : ValueType<256, 73>;    //    8 x f16 vector value
def v32f16   : ValueType<512, 74>;    //    8 x f16 vector value
def v1f32    : ValueType<32 , 75>;    //    1 x f32 vector value
def v2f32    : ValueType<64 , 76>;    //    2 x f32 vector value
def v3f32    : ValueType<96 , 77>;    //    3 x f32 vector value
def v4f32    : ValueType<128, 78>;    //    4 x f32 vector value
def v5f32    : ValueType<160, 79>;    //    5 x f32 vector value
def v8f32    : ValueType<256, 80>;    //    8 x f32 vector value
def v16f32   : ValueType<512,  81>;   //   16 x f32 vector value
def v32f32   : ValueType<1024, 82>;   //   32 x f32 vector value
def v64f32   : ValueType<2048, 83>;   //   64 x f32 vector value
def v128f32  : ValueType<4096, 84>;   //  128 x f32 vector value
def v256f32  : ValueType<8182, 85>;   //  256 x f32 vector value
def v512f32  : ValueType<16384, 86>;  //  512 x f32 vector value
def v1024f32 : ValueType<32768, 87>;  // 1024 x f32 vector value
def v2048f32 : ValueType<65536, 88>;  // 2048 x f32 vector value
def v1f64    : ValueType<64, 89>;     //    1 x f64 vector value
def v2f64    : ValueType<128, 90>;    //    2 x f64 vector value
def v4f64    : ValueType<256, 91>;    //    4 x f64 vector value
def v8f64    : ValueType<512, 92>;    //    8 x f64 vector value

def v1iFATPTR128 : ValueType<128 , 93>;

def nxv1i1  : ValueType<1,   94>;  // n x  1 x i1  vector value
def nxv2i1  : ValueType<2,   95>;  // n x  2 x i1  vector value
def nxv4i1  : ValueType<4,   96>;  // n x  4 x i1  vector value
def nxv8i1  : ValueType<8,   97>;  // n x  8 x i1  vector value
def nxv16i1 : ValueType<16,  98>;  // n x 16 x i1  vector value
def nxv32i1 : ValueType<32,  99>;  // n x 32 x i1  vector value

def nxv1i8  : ValueType<8,   100>;  // n x  1 x i8  vector value
def nxv2i8  : ValueType<16,  101>;  // n x  2 x i8  vector value
def nxv4i8  : ValueType<32,  102>;  // n x  4 x i8  vector value
def nxv8i8  : ValueType<64,  103>;  // n x  8 x i8  vector value
def nxv16i8 : ValueType<128, 104>;  // n x 16 x i8  vector value
def nxv32i8 : ValueType<256, 105>;  // n x 32 x i8  vector value

def nxv1i16 : ValueType<16,  106>; // n x  1 x i16 vector value
def nxv2i16 : ValueType<32,  107>; // n x  2 x i16 vector value
def nxv4i16 : ValueType<64,  108>; // n x  4 x i16 vector value
def nxv8i16 : ValueType<128, 109>; // n x  8 x i16 vector value
def nxv16i16: ValueType<256, 110>; // n x 16 x i16 vector value
def nxv32i16: ValueType<512, 111>; // n x 32 x i16 vector value

def nxv1i32 : ValueType<32,  112>; // n x  1 x i32 vector value
def nxv2i32 : ValueType<64,  113>; // n x  2 x i32 vector value
def nxv4i32 : ValueType<128, 114>; // n x  4 x i32 vector value
def nxv8i32 : ValueType<256, 115>; // n x  8 x i32 vector value
def nxv16i32: ValueType<512, 116>; // n x 16 x i32 vector value
def nxv32i32: ValueType<1024,117>; // n x 32 x i32 vector value

def nxv1i64 : ValueType<64,  118>; // n x  1 x i64 vector value
def nxv2i64 : ValueType<128, 119>; // n x  2 x i64 vector value
def nxv4i64 : ValueType<256, 120>; // n x  4 x i64 vector value
def nxv8i64 : ValueType<512, 121>; // n x  8 x i64 vector value
def nxv16i64: ValueType<1024,122>; // n x 16 x i64 vector value
def nxv32i64: ValueType<2048,123>; // n x 32 x i64 vector value

def nxv2f16  : ValueType<32 , 124>; // n x  2 x f16 vector value
def nxv4f16  : ValueType<64 , 125>; // n x  4 x f16 vector value
def nxv8f16  : ValueType<128, 126>; // n x  8 x f16 vector value
def nxv1f32  : ValueType<32 , 127>; // n x  1 x f32 vector value
def nxv2f32  : ValueType<64 , 128>; // n x  2 x f32 vector value
def nxv4f32  : ValueType<128, 129>; // n x  4 x f32 vector value
def nxv8f32  : ValueType<256, 130>; // n x  8 x f32 vector value
def nxv16f32 : ValueType<512, 131>; // n x 16 x f32 vector value
def nxv1f64  : ValueType<64,  132>; // n x  1 x f64 vector value
def nxv2f64  : ValueType<128, 133>; // n x  2 x f64 vector value
def nxv4f64  : ValueType<256, 134>; // n x  4 x f64 vector value
def nxv8f64  : ValueType<512, 135>; // n x  8 x f64 vector value

def x86mmx : ValueType<64 , 136>;   // X86 MMX value
def FlagVT : ValueType<0  , 137>;   // Pre-RA sched glue
def isVoid : ValueType<0  , 138>;   // Produces no value
def untyped: ValueType<8  , 139>;   // Produces an untyped value
def exnref: ValueType<0, 140>;      // WebAssembly's exnref type
def token  : ValueType<0  , 248>;   // TokenTy
def MetadataVT: ValueType<0, 249>;  // Metadata

// Pseudo valuetype mapped to the current pointer size to any address space.
// Should only be used in TableGen.
def iPTRAny   : ValueType<0, 250>;

// Pseudo valuetype to represent "vector of any size"
def vAny   : ValueType<0  , 251>;

// Pseudo valuetype to represent "float of any format"
def fAny   : ValueType<0  , 252>;

// Pseudo valuetype to represent "integer of any bit width"
def iAny   : ValueType<0  , 253>;

// Pseudo valuetype mapped to the current pointer size.
def iPTR   : ValueType<0  , 254>;

// Pseudo valuetype to represent "any type of any size".
def Any    : ValueType<0  , 255>;

/// This class is for targets that want to use pointer types in patterns
/// with the GlobalISelEmitter.  Targets must define their own pointer
/// derived from this class.  The scalar argument should be an
/// integer type with the same bit size as the ponter.
/// e.g. def p0 : PtrValueType <i64, 0>;

class PtrValueType <ValueType scalar, int addrspace> :
    ValueType<scalar.Size, scalar.Value> {
  int AddrSpace = addrspace;
}
