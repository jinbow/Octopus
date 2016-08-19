subroutine c_filenames()
#include "cpp_options.h"

    use global, only: filenames,Nrecs
    implicit none
    character(len=64) :: fn
    character(len=20) :: variables(6)
    integer*8 :: i,j

    variables=(/"UVEL","VVEL","WVEL","Theta","Salt","GAMMA"/)

    DO i = 1, Nrecs
        write(fn,"(I10.10)") i*20
        DO j = 1, 6
            filenames(i,j) = trim(variables(j))//"."//trim(fn)//'.data'
        ENDDO
    ENDDO
    print*, trim(filenames(1,1))

end subroutine c_filenames
