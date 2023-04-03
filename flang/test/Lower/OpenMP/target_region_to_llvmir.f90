!RUN: %flang_fc1 -emit-llvm -fopenmp %s -o - | FileCheck %s

!===============================================================================
! Simple target region
!===============================================================================

!CHECK-LABEL: @omp_target_region
subroutine omp_target_region
  integer :: a
  integer :: b
  integer :: c
  a = 10
  b = 20
  !CHECK: call void @__omp_offloading_[[DEV:.*]]_[[FIL:.*]]_omp_target_region__l[[LINE:.*]](ptr %{{.*}}, ptr %{{.*}}, ptr %{{.*}})

  !CHECK: define internal void @__omp_offloading_[[DEV]]_[[FIL]]_omp_target_region__l[[LINE]](ptr %[[ADDR_A:.*]], ptr %[[ADDR_B:.*]], ptr %[[ADDR_C:.*]])
  !CHECK: %[[VAL_A:.*]] = load i32, ptr %[[ADDR_A]], align 4
  !CHECK: %[[VAL_B:.*]] = load i32, ptr %[[ADDR_B]], align 4
  !CHECK: %[[SUM:.*]] = add i32 %[[VAL_A]], %[[VAL_B]]
  !CHECK: store i32 %[[SUM]], ptr %[[ADDR_C]], align 4
  !$omp target
      c = a + b
  !$omp end target

end subroutine omp_target_region
