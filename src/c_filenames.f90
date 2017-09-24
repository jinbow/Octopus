subroutine c_filenames()
#include "cpp_options.h"

#ifdef one_file_per_step
    use global, only: filenames,Nrecs,filename_increment,FnPartiInit
    implicit none
    character(len=6) :: fnn
    character(len=5) :: variables(6)
    integer*8 :: i,j

    print*, trim(FnPartiInit)

    !using space to make sure " " has the same length as declared above

#if model==2
    variables=(/"U    ","V    ","W    ","Theta","Salt ","zeta "/)
#else
    variables=(/"U    ","V    ","W    ","Theta","Salt ","GAMMA"/)
#endif

    DO i = 1, Nrecs
        write(fnn,"(I6.6)") i*filename_increment+2160
        DO j = 1, 6
            filenames(i,j) = trim(variables(j))//'/'//trim(variables(j))//"_"//trim(fnn)//'.data'
        ENDDO
    ENDDO
    print*, "filename(1,1) c_filename",trim(filenames(1,1))

#endif

end subroutine c_filenames
