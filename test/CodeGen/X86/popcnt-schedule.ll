; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+popcnt | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=slm         | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=goldmont    | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=sandybridge | FileCheck %s --check-prefix=CHECK --check-prefix=SANDY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=ivybridge   | FileCheck %s --check-prefix=CHECK --check-prefix=SANDY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell     | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=broadwell   | FileCheck %s --check-prefix=CHECK --check-prefix=BROADWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake     | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl         | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver2      | FileCheck %s --check-prefix=CHECK --check-prefix=BDVER2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=btver2      | FileCheck %s --check-prefix=CHECK --check-prefix=BTVER2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1      | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define i16 @test_ctpop_i16(i16 zeroext %a0, i16 *%a1) {
; GENERIC-LABEL: test_ctpop_i16:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    popcntw (%rsi), %cx # sched: [9:1.00]
; GENERIC-NEXT:    popcntw %di, %ax # sched: [3:1.00]
; GENERIC-NEXT:    orl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    # kill: def $ax killed $ax killed $eax
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; SLM-LABEL: test_ctpop_i16:
; SLM:       # %bb.0:
; SLM-NEXT:    popcntw (%rsi), %cx # sched: [6:1.00]
; SLM-NEXT:    popcntw %di, %ax # sched: [3:1.00]
; SLM-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; SLM-NEXT:    # kill: def $ax killed $ax killed $eax
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_ctpop_i16:
; SANDY:       # %bb.0:
; SANDY-NEXT:    popcntw (%rsi), %cx # sched: [9:1.00]
; SANDY-NEXT:    popcntw %di, %ax # sched: [3:1.00]
; SANDY-NEXT:    orl %ecx, %eax # sched: [1:0.33]
; SANDY-NEXT:    # kill: def $ax killed $ax killed $eax
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_ctpop_i16:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    popcntw (%rsi), %cx # sched: [8:1.00]
; HASWELL-NEXT:    popcntw %di, %ax # sched: [3:1.00]
; HASWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    # kill: def $ax killed $ax killed $eax
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_ctpop_i16:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    popcntw (%rsi), %cx # sched: [8:1.00]
; BROADWELL-NEXT:    popcntw %di, %ax # sched: [3:1.00]
; BROADWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; BROADWELL-NEXT:    # kill: def $ax killed $ax killed $eax
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_ctpop_i16:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    popcntw (%rsi), %cx # sched: [8:1.00]
; SKYLAKE-NEXT:    popcntw %di, %ax # sched: [3:1.00]
; SKYLAKE-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; SKYLAKE-NEXT:    # kill: def $ax killed $ax killed $eax
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BDVER2-LABEL: test_ctpop_i16:
; BDVER2:       # %bb.0:
; BDVER2-NEXT:    popcntw (%rsi), %cx # sched: [8:0.50]
; BDVER2-NEXT:    popcntw %di, %ax # sched: [4:0.50]
; BDVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BDVER2-NEXT:    # kill: def $ax killed $ax killed $eax
; BDVER2-NEXT:    retq # sched: [5:1.00]
;
; BTVER2-LABEL: test_ctpop_i16:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    popcntw (%rsi), %cx # sched: [4:1.00]
; BTVER2-NEXT:    popcntw %di, %ax # sched: [1:0.50]
; BTVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    # kill: def $ax killed $ax killed $eax
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_ctpop_i16:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    popcntw (%rsi), %cx # sched: [5:0.50]
; ZNVER1-NEXT:    popcntw %di, %ax # sched: [1:0.25]
; ZNVER1-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    # kill: def $ax killed $ax killed $eax
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i16, i16 *%a1
  %2 = tail call i16 @llvm.ctpop.i16( i16 %1 )
  %3 = tail call i16 @llvm.ctpop.i16( i16 %a0 )
  %4 = or i16 %2, %3
  ret i16 %4
}
declare i16 @llvm.ctpop.i16(i16)

define i32 @test_ctpop_i32(i32 %a0, i32 *%a1) {
; GENERIC-LABEL: test_ctpop_i32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    popcntl (%rsi), %ecx # sched: [9:1.00]
; GENERIC-NEXT:    popcntl %edi, %eax # sched: [3:1.00]
; GENERIC-NEXT:    orl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; SLM-LABEL: test_ctpop_i32:
; SLM:       # %bb.0:
; SLM-NEXT:    popcntl (%rsi), %ecx # sched: [6:1.00]
; SLM-NEXT:    popcntl %edi, %eax # sched: [3:1.00]
; SLM-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_ctpop_i32:
; SANDY:       # %bb.0:
; SANDY-NEXT:    popcntl (%rsi), %ecx # sched: [9:1.00]
; SANDY-NEXT:    popcntl %edi, %eax # sched: [3:1.00]
; SANDY-NEXT:    orl %ecx, %eax # sched: [1:0.33]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_ctpop_i32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    popcntl (%rsi), %ecx # sched: [8:1.00]
; HASWELL-NEXT:    popcntl %edi, %eax # sched: [3:1.00]
; HASWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_ctpop_i32:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    popcntl (%rsi), %ecx # sched: [8:1.00]
; BROADWELL-NEXT:    popcntl %edi, %eax # sched: [3:1.00]
; BROADWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_ctpop_i32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    popcntl (%rsi), %ecx # sched: [8:1.00]
; SKYLAKE-NEXT:    popcntl %edi, %eax # sched: [3:1.00]
; SKYLAKE-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BDVER2-LABEL: test_ctpop_i32:
; BDVER2:       # %bb.0:
; BDVER2-NEXT:    popcntl (%rsi), %ecx # sched: [8:0.50]
; BDVER2-NEXT:    popcntl %edi, %eax # sched: [4:0.50]
; BDVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BDVER2-NEXT:    retq # sched: [5:1.00]
;
; BTVER2-LABEL: test_ctpop_i32:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    popcntl (%rsi), %ecx # sched: [4:1.00]
; BTVER2-NEXT:    popcntl %edi, %eax # sched: [1:0.50]
; BTVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_ctpop_i32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    popcntl (%rsi), %ecx # sched: [5:0.50]
; ZNVER1-NEXT:    popcntl %edi, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i32, i32 *%a1
  %2 = tail call i32 @llvm.ctpop.i32( i32 %1 )
  %3 = tail call i32 @llvm.ctpop.i32( i32 %a0 )
  %4 = or i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.ctpop.i32(i32)

define i64 @test_ctpop_i64(i64 %a0, i64 *%a1) {
; GENERIC-LABEL: test_ctpop_i64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    popcntq (%rsi), %rcx # sched: [9:1.00]
; GENERIC-NEXT:    popcntq %rdi, %rax # sched: [3:1.00]
; GENERIC-NEXT:    orq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; SLM-LABEL: test_ctpop_i64:
; SLM:       # %bb.0:
; SLM-NEXT:    popcntq (%rsi), %rcx # sched: [6:1.00]
; SLM-NEXT:    popcntq %rdi, %rax # sched: [3:1.00]
; SLM-NEXT:    orq %rcx, %rax # sched: [1:0.50]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_ctpop_i64:
; SANDY:       # %bb.0:
; SANDY-NEXT:    popcntq (%rsi), %rcx # sched: [9:1.00]
; SANDY-NEXT:    popcntq %rdi, %rax # sched: [3:1.00]
; SANDY-NEXT:    orq %rcx, %rax # sched: [1:0.33]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_ctpop_i64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    popcntq (%rsi), %rcx # sched: [8:1.00]
; HASWELL-NEXT:    popcntq %rdi, %rax # sched: [3:1.00]
; HASWELL-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_ctpop_i64:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    popcntq (%rsi), %rcx # sched: [8:1.00]
; BROADWELL-NEXT:    popcntq %rdi, %rax # sched: [3:1.00]
; BROADWELL-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_ctpop_i64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    popcntq (%rsi), %rcx # sched: [8:1.00]
; SKYLAKE-NEXT:    popcntq %rdi, %rax # sched: [3:1.00]
; SKYLAKE-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BDVER2-LABEL: test_ctpop_i64:
; BDVER2:       # %bb.0:
; BDVER2-NEXT:    popcntq (%rsi), %rcx # sched: [8:0.50]
; BDVER2-NEXT:    popcntq %rdi, %rax # sched: [4:0.50]
; BDVER2-NEXT:    orq %rcx, %rax # sched: [1:0.50]
; BDVER2-NEXT:    retq # sched: [5:1.00]
;
; BTVER2-LABEL: test_ctpop_i64:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    popcntq (%rsi), %rcx # sched: [4:1.00]
; BTVER2-NEXT:    popcntq %rdi, %rax # sched: [1:0.50]
; BTVER2-NEXT:    orq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_ctpop_i64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    popcntq (%rsi), %rcx # sched: [5:0.50]
; ZNVER1-NEXT:    popcntq %rdi, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i64, i64 *%a1
  %2 = tail call i64 @llvm.ctpop.i64( i64 %1 )
  %3 = tail call i64 @llvm.ctpop.i64( i64 %a0 )
  %4 = or i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.ctpop.i64(i64)
