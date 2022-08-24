subroutine c_filenames()
#include "cpp_options.h"

#ifdef one_file_per_step
    use global, only: filenames,Nrecs,filename_increment,FnPartiInit
    implicit none
    character(len=5) :: fnn
    character(len=5) :: variables(6)
    integer*8 :: i,j

    print*, trim(FnPartiInit)
    !using space to make sure " " has the same length as declared above

    variables=(/"U    ","V    ","W    ","Theta","Salt ","GAMMA"/)

    DO i = 1, Nrecs
        write(fnn,"(I5.5)") i*filename_increment+4060
        DO j = 1, 6
            filenames(i,j) = trim(variables(j))//'/'//trim(variables(j))//"_90x300x640_"//trim(fnn)//'.data'
        ENDDO
    ENDDO
    print*, "filename(1,1) c_filename",trim(filenames(1,1))

#endif

end subroutine c_filenames
