//===--- capability_cast.h - C++ capability utils ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef __CAPABILITY_CAST_H
#define __CAPABILITY_CAST_H

#if defined(__cplusplus)
#ifdef __aarch64__
#if __has_feature(capabilities)
#ifndef __CHERI_PURE_CAPABILITY__

// For testing purpose, do not fail if this header is not yet available, but
// provided instead reasonable mockups so that this file can be tested.
#if __has_include(<type_traits>)
#include <type_traits>
#else
// Provide a few types / templates in order to test our own header as some of
// the headers we use are not shiiped with bare clang (like type_traits).
#include <stddef.h>

#ifndef _SIZE_T
typedef __typeof__(sizeof(int)) size_t;
#endif

namespace std {
template <class T, T v>
struct integral_constant {
  static const T value = v;
  typedef T value_type;
  typedef integral_constant<T, v> type;
  operator T() { return v; }
};

typedef integral_constant<bool, true> true_type;
typedef integral_constant<bool, false> false_type;
template <class _Tp> struct is_const            : public false_type {};
template <class _Tp> struct is_const<_Tp const> : public true_type {};
}

#endif

// Maybe a useful traits, in the manner of the others from type_traits.
template <class _Tp> struct is_capability : public std::false_type {};
template <class _Tp>
struct is_capability<_Tp * __capability> : public std::true_type {};

template <class _Tret, class _Tp>
static inline __attribute__((__always_inline__, __nodebug__))
_Tret *__capability
capability_cast(void *__capability GlobalCap, _Tp *Ptr,
                size_t size = sizeof(_Tret)) {
  using RetTy = _Tret *__capability;

  RetTy Cap =
      (RetTy)__builtin_cheri_cap_from_pointer(GlobalCap, (size_t)Ptr);

  if (std::is_const<_Tret>::value)
    Cap = (RetTy)__builtin_cheri_perms_and(Cap, ~(__CHERI_CAP_PERMISSION_PERMIT_STORE__));

  Cap = (RetTy)__builtin_cheri_bounds_set(Cap, size);

 return Cap;
}

template <class _Tret, class _Tp>
static inline __attribute__((__always_inline__, __nodebug__))
_Tret *__capability
capability_cast(_Tp *Ptr) {
  return capability_cast<_Tret, _Tp>(__builtin_cheri_global_data_get(), Ptr,
                                     sizeof(_Tret));
}

template <class _Tret, class _Tp>
static inline __attribute__((__always_inline__, __nodebug__))
_Tret *__capability
capability_cast(_Tp *Ptr, size_t size) {
  return capability_cast<_Tret, _Tp>(__builtin_cheri_global_data_get(), Ptr,
                                     size);
}

template <class _Tret, class _Tp>
static inline __attribute__((__always_inline__, __nodebug__)) _Tret *
capability_cast(void *__capability GlobalCap, _Tp *__capability Cap) {
  using RetTy = _Tret *;

  return (RetTy)__builtin_cheri_cap_to_pointer(GlobalCap, Cap);
}

template <class _Tret, class _Tp>
static inline __attribute__((__always_inline__, __nodebug__)) _Tret *
capability_cast(_Tp *__capability Cap) {
  return capability_cast<_Tret, _Tp>(((void *__capability)0), Cap);
}

#endif // __CHERI_PURE_CAPABILITY__
#endif // __has_feature(capabilities)
#endif // __aarch64__
#endif // defined(__cplusplus)

#endif // __CAPABILITY_CAST_H
