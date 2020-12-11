subroutine c_filenames()
#include "cpp_options.h"

    use global, only: filenames,Nrecs,filename_increment,FnPartiInit
    implicit none
#ifdef one_file_per_step
    character(len=5) :: fnn
    character(len=5) :: variables(6)
    integer*8 :: i,j

    print*, trim(FnPartiInit)
    !using space to make sure " " has the same length as declared above

    variables=(/"U    ","V    ","W    ","T    ","S    ","G    "/)

    DO i = 1, Nrecs
        write(fnn,"(I5.5)") i*filename_increment
        DO j = 1, 6
            !filenames(i,j) = trim(variables(j))//'/'//trim(variables(j))//"_90x300x640_"//trim(fnn)//'.data'
            filenames(i,j) = "rot_"//trim(variables(j))//"_"//trim(fnn)//'.bin'
        ENDDO
    ENDDO
    print*, "filename(1,1) c_filename",trim(filenames(1,1))
#endif

#ifdef stationary_velocity
filenames(:,1)="UVEL.data"
filenames(:,2)="VVEL.data"
filenames(:,3)="WVEL.data"
#endif


end subroutine c_filenames
