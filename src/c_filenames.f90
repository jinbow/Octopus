subroutine c_filenames()
#include "cpp_options.h"

#ifdef one_file_per_step
    use global, only: filenames,Nrecs,filename_increment,FnPartiInit
    implicit none
    character(len=64) :: fnn
    character(len=5) :: variables(6)
    integer*8 :: i,j

    print*, trim(FnPartiInit)
    !using space to make sure " " has the same length as declared above

    variables=(/"UVEL ","VVEL ","WVEL ","Theta","Salt ","GAMMA"/)

    DO i = 1, Nrecs
        write(fnn,"(I10.10)") i*filename_increment
        DO j = 1, 6
            filenames(i,j) = trim(variables(j))//"."//trim(fnn)//'.data'
        ENDDO
    ENDDO
    print*, "filename(1,1) c_filename",trim(filenames(1,1))

    print*, trim(FnPartiInit)

#endif

end subroutine c_filenames
