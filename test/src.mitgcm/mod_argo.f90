MODULE particles
  USE global
  ! define the class for particles
  TYPE argo
     REAL(kind=rc_kind) :: x,y,z,tc,
  END TYPE particle

  TYPE (particle), DIMENSION(:), ALLOCATABLE :: parti
  REAL(kind=rc_kind) ::  dz,swap1,swap2,swap3
  INTEGER,ALLOCATABLE :: file_id(:)
  INTEGER :: NPR_eachfile
  CHARACTER(len=3) :: file_id_char 

  PRIVATE   :: NPR_eachfile, file_id_char, dz, swap1, swap2, swap3,
file_id
  PUBLIC    :: parti

CONTAINS
