// RUN: heir-opt --cggi-expand-lut %s | FileCheck %s

#encoding = #lwe.unspecified_bit_field_encoding<cleartext_bitwidth = 3>
!ct_ty = !lwe.lwe_ciphertext<encoding = #encoding>

// CHECK-LABEL: @lut2
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]]
func.func @lut2(%arg0: !ct_ty, %arg1: !ct_ty) -> !ct_ty {
  // CHECK-DAG: %[[const2:.*]] = arith.constant 2 : i3
  // CHECK: %[[mul_b:.*]] = lwe.mul_scalar %[[arg0]], %[[const2]]
  // CHECK: %[[res:.*]] = lwe.add %[[mul_b]], %[[arg1]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[res]] {lookup_table = 8 : ui8}
  // CHECK: return %[[pbs]]
  %r1 = cggi.lut2 %arg0, %arg1 {lookup_table = 8 : ui8} : !ct_ty
  return %r1 : !ct_ty
}

// CHECK-LABEL: @lut3
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]], %[[arg2:.*]]: ![[ct]]
func.func @lut3(%arg0: !ct_ty, %arg1: !ct_ty, %arg2: !ct_ty) -> !ct_ty {
  // CHECK-DAG: %[[const4:.*]] = arith.constant -4 : i3
  // CHECK-DAG: %[[const2:.*]] = arith.constant 2 : i3
  // CHECK: %[[mul_c:.*]] = lwe.mul_scalar %[[arg0]], %[[const4]]
  // CHECK: %[[mul_b:.*]] = lwe.mul_scalar %[[arg1]], %[[const2]]
  // CHECK: %[[add_cb:.*]] = lwe.add %[[mul_c]], %[[mul_b]]
  // CHECK: %[[res:.*]] = lwe.add %[[add_cb]], %[[arg2]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[res]] {lookup_table = 8 : ui8}
  // CHECK: return %[[pbs]]
  %r1 = cggi.lut3 %arg0, %arg1, %arg2 {lookup_table = 8 : ui8} : !ct_ty
  return %r1 : !ct_ty
}

// CHECK-LABEL: @lut_lincomb
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]]
func.func @lut_lincomb(%arg0: !ct_ty, %arg1: !ct_ty) -> !ct_ty {
  // CHECK-DAG: %[[const3:.*]] = arith.constant 3 : i3
  // CHECK-DAG: %[[const6:.*]] = arith.constant -2 : i3
  // CHECK: %[[mul_c:.*]] = lwe.mul_scalar %[[arg0]], %[[const3]]
  // CHECK: %[[mul_b:.*]] = lwe.mul_scalar %[[arg1]], %[[const6]]
  // CHECK: %[[add_cb:.*]] = lwe.add %[[mul_c]], %[[mul_b]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[add_cb]] {lookup_table = 68 : index}
  // CHECK: return %[[pbs]]
  %r1 = cggi.lut_lincomb %arg0, %arg1 {coefficients = array<i32: 3, 6>, lookup_table = 68 : index} : !ct_ty
  return %r1 : !ct_ty
}

#encoding4 = #lwe.unspecified_bit_field_encoding<cleartext_bitwidth = 4>
!ct_ty4 = !lwe.lwe_ciphertext<encoding = #encoding4>

// CHECK-LABEL: @lut_bitwidth_4
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]]
func.func @lut_bitwidth_4(%arg0: !ct_ty4, %arg1: !ct_ty4) -> !ct_ty4 {
  // CHECK-DAG: %[[const3:.*]] = arith.constant 3 : i4
  // CHECK-DAG: %[[const6:.*]] = arith.constant 6 : i4
  // CHECK: %[[mul_c:.*]] = lwe.mul_scalar %[[arg0]], %[[const3]]
  // CHECK: %[[mul_b:.*]] = lwe.mul_scalar %[[arg1]], %[[const6]]
  // CHECK: %[[add_cb:.*]] = lwe.add %[[mul_c]], %[[mul_b]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[add_cb]] {lookup_table = 68 : index}
  // CHECK: return %[[pbs]]
  %r1 = cggi.lut_lincomb %arg0, %arg1 {coefficients = array<i32: 3, 6>, lookup_table = 68 : index} : !ct_ty4
  return %r1 : !ct_ty4
}
