!RUN: %flang_fc1 -emit-fir -fopenmp %s -o - | FileCheck %s

!===============================================================================
! Simple target region
!===============================================================================

!CHECK-LABEL: func.func @_QPomp_target_region() {
subroutine omp_target_region
  integer :: a
  integer :: b
  integer :: c
  a = 10
  b = 20

  !CHECK omp.target   {
  !CHECK %[[VAL_0:.*]] = fir.load %{{.*}} : !fir.ref<i32>
  !CHECK %[[VAL_1:.*]] = fir.load %{{.*}} : !fir.ref<i32>
  !CHECK %[[VAL_2:.*]] = arith.addi %[[VAL_0]], %[[VAL_1]] : i32
  !CHECK fir.store %[[VAL_2]] to {{.*}} : !fir.ref<i32>
  !CHECK omp.terminator
  !$omp target
      c = a + b
      !$omp end target

end subroutine omp_target_region

!===============================================================================
! Two targe regions
!===============================================================================

!CHECK-LABEL: func.func @_QPomp_target_regions() {
subroutine omp_target_regions
  integer :: a
  integer :: b
  integer :: c
  a = 10
  b = 20

  !CHECK omp.target   {
  !CHECK %[[VAL_0:.*]] = fir.load %[[ADDR_A]]:.*]] : !fir.ref<i32>
  !CHECK %[[VAL_1:.*]] = fir.load %{{.*}} : !fir.ref<i32>
  !CHECK %[[VAL_2:.*]] = arith.addi %[[VAL_0]], %[[VAL_1]] : i32
  !CHECK fir.store %[[VAL_2]] to [[ADDR_C:.*]] : !fir.ref<i32>
  !CHECK omp.terminator
  !$omp target
     c = a + b
  !$omp end target
  !CHECK %[[VAL_3:.*]] = fir.load %[[ADDR_C]] : !fir.ref<i32>
  !CHECK %[[VAL_4:.*]] = fir.load %[[ADDR_A]] : !fir.ref<i32>
  !CHECK %[[VAL_5:.*]] = arith.subi %[[VAL_3]], %[[VAL_4]] : i32
  !CHECK fir.store %[[VAL_5]] to [[ADDR_C:.*]] : !fir.ref<i32>
  !$omp target
     c = c - a
  !$omp end target

end subroutine omp_target_regions



