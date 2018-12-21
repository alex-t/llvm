; RUN: llc -march=hexagon < %s | FileCheck %s

target triple = "hexagon"

; CHECK-LABEL: f0
; CHECK: r0 = rol(r0,#7)
define i32 @f0(i32 %a0) #0 {
b0:
  %v0 = shl i32 %a0, 7
  %v1 = lshr i32 %a0, 25
  %v2 = or i32 %v0, %v1
  ret i32 %v2
}

; CHECK-LABEL: f1
; No variable-shift rotates. Check for the default expansion code.
; This is a rotate left by %a1(r1).
; CHECK: r[[R10:[0-9]+]] = sub(#32,r1)
; CHECK: r[[R11:[0-9]+]] = and(r1,#31)
; CHECK: r[[R12:[0-9]+]] = and(r[[R10]],#31)
; CHECK: r[[R13:[0-9]+]] = asl(r0,r[[R11]])
; CHECK: r[[R13]] |= lsr(r0,r[[R12]])
define i32 @f1(i32 %a0, i32 %a1) #0 {
b0:
  %v0 = shl i32 %a0, %a1
  %v1 = sub i32 32, %a1
  %v2 = lshr i32 %a0, %v1
  %v3 = or i32 %v2, %v0
  ret i32 %v3
}

; CHECK-LABEL: f2
; CHECK: r0 = rol(r0,#25)
define i32 @f2(i32 %a0) #0 {
b0:
  %v0 = lshr i32 %a0, 7
  %v1 = shl i32 %a0, 25
  %v2 = or i32 %v0, %v1
  ret i32 %v2
}

; CHECK-LABEL: f3
; No variable-shift rotates. Check for the default expansion code.
; This is a rotate right by %a1(r1) that became a rotate left by 32-%a1.
; CHECK: r[[R30:[0-9]+]] = sub(#32,r1)
; CHECK: r[[R31:[0-9]+]] = and(r1,#31)
; CHECK: r[[R32:[0-9]+]] = and(r[[R30]],#31)
; CHECK: r[[R33:[0-9]+]] = asl(r0,r[[R32]])
; CHECK: r[[R33]] |= lsr(r0,r[[R31]])
define i32 @f3(i32 %a0, i32 %a1) #0 {
b0:
  %v0 = lshr i32 %a0, %a1
  %v1 = sub i32 32, %a1
  %v2 = shl i32 %a0, %v1
  %v3 = or i32 %v2, %v0
  ret i32 %v3
}

; CHECK-LABEL: f4
; CHECK: r1:0 = rol(r1:0,#7)
define i64 @f4(i64 %a0) #0 {
b0:
  %v0 = shl i64 %a0, 7
  %v1 = lshr i64 %a0, 57
  %v2 = or i64 %v0, %v1
  ret i64 %v2
}

; CHECK-LABEL: f5
; No variable-shift rotates. Check for the default expansion code.
; This is a rotate left by %a1(r2).
; CHECK: r[[R50:[0-9]+]] = sub(#64,r2)
; CHECK: r[[R51:[0-9]+]] = and(r2,#63)
; CHECK: r[[R52:[0-9]+]] = and(r[[R50]],#63)
; CHECK: r[[R53:[0-9]+]]:[[R54:[0-9]+]] = asl(r1:0,r[[R51]])
; CHECK: r[[R53]]:[[R54]] |= lsr(r1:0,r[[R52]])
define i64 @f5(i64 %a0, i32 %a1) #0 {
b0:
  %v0 = zext i32 %a1 to i64
  %v1 = shl i64 %a0, %v0
  %v2 = sub i32 64, %a1
  %v3 = zext i32 %v2 to i64
  %v4 = lshr i64 %a0, %v3
  %v5 = or i64 %v4, %v1
  ret i64 %v5
}

; CHECK-LABEL: f6
; CHECK: r1:0 = rol(r1:0,#57)
define i64 @f6(i64 %a0) #0 {
b0:
  %v0 = lshr i64 %a0, 7
  %v1 = shl i64 %a0, 57
  %v2 = or i64 %v0, %v1
  ret i64 %v2
}

; CHECK-LABEL: f7
; No variable-shift rotates. Check for the default expansion code.
; This is a rotate right by %a1(r2) that became a rotate left by 64-%a1.
; CHECK: r[[R70:[0-9]+]] = sub(#64,r2)
; CHECK: r[[R71:[0-9]+]] = and(r2,#63)
; CHECK: r[[R72:[0-9]+]] = and(r[[R70]],#63)
; CHECK: r[[R73:[0-9]+]]:[[R75:[0-9]+]] = asl(r1:0,r[[R72]])
; CHECK: r[[R73]]:[[R75]] |= lsr(r1:0,r[[R71]])
define i64 @f7(i64 %a0, i32 %a1) #0 {
b0:
  %v0 = zext i32 %a1 to i64
  %v1 = lshr i64 %a0, %v0
  %v2 = sub i32 64, %a1
  %v3 = zext i32 %v2 to i64
  %v4 = shl i64 %a0, %v3
  %v5 = or i64 %v4, %v1
  ret i64 %v5
}

; CHECK-LABEL: f8
; CHECK: r0 += rol(r1,#7)
define i32 @f8(i32 %a0, i32 %a1) #0 {
b0:
  %v0 = shl i32 %a1, 7
  %v1 = lshr i32 %a1, 25
  %v2 = or i32 %v0, %v1
  %v3 = add i32 %v2, %a0
  ret i32 %v3
}

; CHECK-LABEL: f9
; CHECK: r0 -= rol(r1,#7)
define i32 @f9(i32 %a0, i32 %a1) #0 {
b0:
  %v0 = shl i32 %a1, 7
  %v1 = lshr i32 %a1, 25
  %v2 = or i32 %v0, %v1
  %v3 = sub i32 %a0, %v2
  ret i32 %v3
}

; CHECK-LABEL: f10
; CHECK: r0 &= rol(r1,#7)
define i32 @f10(i32 %a0, i32 %a1) #0 {
b0:
  %v0 = shl i32 %a1, 7
  %v1 = lshr i32 %a1, 25
  %v2 = or i32 %v0, %v1
  %v3 = and i32 %v2, %a0
  ret i32 %v3
}

; CHECK-LABEL: f12
; CHECK: r0 ^= rol(r1,#7)
define i32 @f12(i32 %a0, i32 %a1) #0 {
b0:
  %v0 = shl i32 %a1, 7
  %v1 = lshr i32 %a1, 25
  %v2 = or i32 %v0, %v1
  %v3 = xor i32 %v2, %a0
  ret i32 %v3
}

; CHECK-LABEL: f13
; CHECK: r1:0 += rol(r3:2,#7)
define i64 @f13(i64 %a0, i64 %a1) #0 {
b0:
  %v0 = shl i64 %a1, 7
  %v1 = lshr i64 %a1, 57
  %v2 = or i64 %v0, %v1
  %v3 = add i64 %v2, %a0
  ret i64 %v3
}

; CHECK-LABEL: f14
; CHECK: r1:0 -= rol(r3:2,#7)
define i64 @f14(i64 %a0, i64 %a1) #0 {
b0:
  %v0 = shl i64 %a1, 7
  %v1 = lshr i64 %a1, 57
  %v2 = or i64 %v0, %v1
  %v3 = sub i64 %a0, %v2
  ret i64 %v3
}

; CHECK-LABEL: f15
; CHECK: r1:0 &= rol(r3:2,#7)
define i64 @f15(i64 %a0, i64 %a1) #0 {
b0:
  %v0 = shl i64 %a1, 7
  %v1 = lshr i64 %a1, 57
  %v2 = or i64 %v0, %v1
  %v3 = and i64 %v2, %a0
  ret i64 %v3
}

; CHECK-LABEL: f17
; CHECK: r1:0 ^= rol(r3:2,#7)
define i64 @f17(i64 %a0, i64 %a1) #0 {
b0:
  %v0 = shl i64 %a1, 7
  %v1 = lshr i64 %a1, 57
  %v2 = or i64 %v0, %v1
  %v3 = xor i64 %v2, %a0
  ret i64 %v3
}

attributes #0 = { norecurse nounwind readnone "target-cpu"="hexagonv60" "target-features"="-packets" }
