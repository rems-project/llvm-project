// RUN: %clang %s -O1 -target cheri-unknown-freebsd -o - -emit-llvm -S -std=c++11 | FileCheck %s --check-prefix=CAPS
// RUN: %clang %s -O1 -target aarch64-none-linux-gnu -march=morello -o - -emit-llvm -S -std=c++11 -fPIC | FileCheck %s --check-prefix=CAPS-AARCH64
// RUN: %clang %s -O1 -target aarch64-none-linux-gnu -o - -emit-llvm -S -std=c++11 -fPIC | FileCheck %s --check-prefix=PTRS-AARCH64

// Remove the static from all of the function prototypes so that this really exists.
#define static
#define inline
#include <cheri.h>

// PTRS-AARCH64: define noundef i64 @_Z16cheri_length_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i64 -1
// PTRS-AARCH64: define noundef i64 @_Z14cheri_base_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i64 -1
// PTRS-AARCH64: define noundef i64 @_Z16cheri_offset_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i64 -1
// PTRS-AARCH64: define noundef i8* @_Z16cheri_offset_setPvm(i8* noundef readnone returned %{{.*}}, i64  noundef %{{.*}})
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noundef i32 @_Z14cheri_type_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i32 0
// PTRS-AARCH64: define noundef i32 @_Z15cheri_perms_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i32 0
// PTRS-AARCH64: define noundef i8* @_Z15cheri_perms_andPvj(i8* noundef readnone returned %{{.*}}, i32 noundef %{{.*}})
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noundef i1 @_Z13cheri_tag_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i1 false
// PTRS-AARCH64: define noundef i1 @_Z16cheri_sealed_getPv(i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i1 false
// PTRS-AARCH64: define noundef i8* @_Z22cheri_offset_incrementPvl(i8* noundef readnone %{{.*}}, i64 noundef %{{.*}})
// PTRS-AARCH64: %{{.*}} = getelementptr inbounds i8, i8* %{{.*}}, i64 %{{.*}}
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noundef i8* @_Z15cheri_tag_clearPv(i8* noundef readnone returned %{{.*}})
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noundef i8* @_Z10cheri_sealPvPKv(i8* noundef readnone returned %{{.*}}, i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noundef i8* @_Z12cheri_unsealPvPKv(i8* noundef readnone returned %{{.*}}, i8* nocapture noundef readnone %{{.*}})
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noundef i8* @_Z16cheri_bounds_setPvm(i8* noundef readnone returned %{{.*}}, i64 noundef %{{.*}})
// PTRS-AARCH64: ret i8* %{{.*}}
// PTRS-AARCH64: define noalias noundef i8* @_Z21cheri_global_data_getv()
// PTRS-AARCH64: ret i8* null
// PTRS-AARCH64: define noalias noundef i8* @_Z25cheri_program_counter_getv()
// PTRS-AARCH64: ret i8* null

// CAPS: define noundef i64 @_Z16cheri_length_getU12__capabilityPv(i8 addrspace(200)* noundef readnone
// CAPS: call i64 @llvm.cheri.cap.length.get.i64(i8 addrspace(200)*
// CAPS: define noundef i64 @_Z14cheri_base_getU12__capabilityPv(i8 addrspace(200)* noundef readnone
// CAPS: call i64 @llvm.cheri.cap.base.get.i64(i8 addrspace(200)*
// CAPS: define noundef i64 @_Z16cheri_offset_getU12__capabilityPv(i8 addrspace(200)* noundef readnone
// CAPS: call i64 @llvm.cheri.cap.offset.get.i64(i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z16cheri_offset_setU12__capabilityPvm(i8 addrspace(200)* noundef readnone{{.*}}, i64 noundef zeroext{{.*}}
// CAPS: call i8 addrspace(200)* @llvm.cheri.cap.offset.set.i64(i8 addrspace(200)*{{.*}}, i64{{.*}})
// CAPS: define noundef signext i32 @_Z14cheri_type_getU12__capabilityPv(i8 addrspace(200)*
// CAPS: call i64 @llvm.cheri.cap.type.get.i64(i8 addrspace(200)*
// CAPS: define noundef zeroext i16 @_Z15cheri_perms_getU12__capabilityPv(i8 addrspace(200)*
// CAPS: call i64 @llvm.cheri.cap.perms.get.i64(i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z15cheri_perms_andU12__capabilityPvt(i8 addrspace(200)* noundef readnone{{.*}}, i16 noundef zeroext
// CAPS: call i8 addrspace(200)* @llvm.cheri.cap.perms.and.i64(i8 addrspace(200)*{{.*}}, i64
// CAPS: define noundef zeroext i1 @_Z13cheri_tag_getU12__capabilityPv(i8 addrspace(200)* noundef readnone
// CAPS: call i1 @llvm.cheri.cap.tag.get(i8 addrspace(200)*
// CAPS: define noundef zeroext i1 @_Z16cheri_sealed_getU12__capabilityPv(i8 addrspace(200)* noundef readnone
// CAPS: call i1 @llvm.cheri.cap.sealed.get(i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z22cheri_offset_incrementU12__capabilityPvl(i8 addrspace(200)* noundef readnone{{.*}}, i64 noundef signext
// CAPS: getelementptr i8, i8 addrspace(200)* {{.*}}, i64
// CAPS: define noundef i8 addrspace(200)* @_Z15cheri_tag_clearU12__capabilityPv(i8 addrspace(200)* noundef readnone
// CAPS: call i8 addrspace(200)* @llvm.cheri.cap.tag.clear(i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z10cheri_sealU12__capabilityPvU12__capabilityPKv(i8 addrspace(200)* noundef readnone{{.*}}, i8 addrspace(200)* noundef readnone
// CAPS: call i8 addrspace(200)* @llvm.cheri.cap.seal(i8 addrspace(200)*{{.*}}, i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z12cheri_unsealU12__capabilityPvU12__capabilityPKv(i8 addrspace(200)* noundef readnone{{.*}}, i8 addrspace(200)* noundef readnone
// CAPS: call i8 addrspace(200)* @llvm.cheri.cap.unseal(i8 addrspace(200)*{{.*}}, i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z16cheri_bounds_setU12__capabilityPvm(i8 addrspace(200)* noundef readnone{{.*}}, i64 noundef zeroext{{.*}}
// CAPS: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)*{{.*}}, i64
// CAPS: define void @_Z17cheri_perms_checkU12__capabilityPKvt(i8 addrspace(200)*{{.*}}, i16 noundef zeroext
// CAPS: call void @llvm.cheri.cap.perms.check.i64(i8 addrspace(200)*{{.*}}, i64
// CAPS: define void @_Z16cheri_type_checkU12__capabilityPKvS0_(i8 addrspace(200)*{{.*}}, i8 addrspace(200)*
// CAPS: call void @llvm.cheri.cap.type.check(i8 addrspace(200)*{{.*}}, i8 addrspace(200)*
// CAPS: define noundef i8 addrspace(200)* @_Z21cheri_global_data_getv()
// CAPS: call i8 addrspace(200)* @llvm.cheri.ddc.get()
// CAPS: define noundef i8 addrspace(200)* @_Z25cheri_program_counter_getv()
// CAPS: call i8 addrspace(200)* @llvm.cheri.pcc.get()

// CAPS-AARCH64: define noundef i64 @_Z16cheri_length_getU12__capabilityPv(i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i64 @llvm.cheri.cap.length.get.i64(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i64 @_Z14cheri_base_getU12__capabilityPv(i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i64 @llvm.cheri.cap.base.get.i64(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i64 @_Z16cheri_offset_getU12__capabilityPv(i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i64 @llvm.cheri.cap.offset.get.i64(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z16cheri_offset_setU12__capabilityPvm(i8 addrspace(200)* noundef readnone %{{.*}}, i64 noundef %{{.*}})
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.cap.offset.set.i64(i8 addrspace(200)* %{{.*}}, i64 %{{.*}})
// CAPS-AARCH64: define noundef i32 @_Z14cheri_type_getU12__capabilityPv(i8 addrspace(200)* noundef %{{.*}})
// CAPS-AARCH64: call i64 @llvm.cheri.cap.type.get.i64(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i32 @_Z15cheri_perms_getU12__capabilityPv(i8 addrspace(200)* noundef %{{.*}})
// CAPS-AARCH64: call i64 @llvm.cheri.cap.perms.get.i64(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z15cheri_perms_andU12__capabilityPvj(i8 addrspace(200)* noundef readnone %{{.*}}, i32 noundef %{{.*}})
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.cap.perms.and.i64(i8 addrspace(200)* %{{.*}}, i64
// CAPS-AARCH64: define noundef i1 @_Z13cheri_tag_getU12__capabilityPv(i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i1 @llvm.cheri.cap.tag.get(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i1 @_Z16cheri_sealed_getU12__capabilityPv(i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i1 @llvm.cheri.cap.sealed.get(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z22cheri_offset_incrementU12__capabilityPvl(i8 addrspace(200)* noundef readnone %{{.*}}, i64 noundef %{{.*}})
// CAPS-AARCH64:  getelementptr i8, i8 addrspace(200)* {{.*}}, i64
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z15cheri_tag_clearU12__capabilityPv(i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.cap.tag.clear(i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z10cheri_sealU12__capabilityPvU12__capabilityPKv(i8 addrspace(200)* noundef readnone %{{.*}}, i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.cap.seal(i8 addrspace(200)* %{{.*}}, i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z12cheri_unsealU12__capabilityPvU12__capabilityPKv(i8 addrspace(200)* noundef readnone %{{.*}}, i8 addrspace(200)* noundef readnone %{{.*}})
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.cap.unseal(i8 addrspace(200)* %{{.*}}, i8 addrspace(200)* %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z16cheri_bounds_setU12__capabilityPvm(i8 addrspace(200)* noundef readnone %{{.*}}, i64 noundef %{{.*}})
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %{{.*}}, i64  %{{.*}})
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z21cheri_global_data_getv()
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.ddc.get()
// CAPS-AARCH64: define noundef i8 addrspace(200)* @_Z25cheri_program_counter_getv()
// CAPS-AARCH64: call i8 addrspace(200)* @llvm.cheri.pcc.get()
