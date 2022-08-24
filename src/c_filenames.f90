subroutine c_filenames()
#include "cpp_options.h"

#ifdef one_file_per_step

!Need to hard code the file names below for one file per step scenario. 
!Pay attention to the calculation of time increment

    use global, only: filenames,Nrecs,filename_increment,FnPartiInit
    implicit none
    character(len=5) :: fnn
    character(len=5) :: variables(6)
    integer*8 :: i,j

    print*, trim(FnPartiInit)
    !Use space to make sure " " has the same length as declared above, len=5 in this case. (There should be a clever way doing
    !this.)

    variables=(/"U    ","V    ","W    ","T    ","S    ","G    "/)

    !The variable 'filenames' is a two-dimensional array contaning the filenames for all variables at all steps. 
    !The first dimension in filenames(i,j) corresponds to the number of files/steps for each varaible. Dimension size = Nrecs.
    !The second dimension corresponds to varialbe defined in 'variables' above. We have 6 variables here corresponding to
    !U/V/W/T/S/G where 'G' is neutral density. It was used in a paper related to DIMES where we release particles on a neutral
    !density surface. You can leave fn_GAMMA ='', G will not be used. 
    DO i = 1, Nrecs
        write(fnn,"(I5.5)") i*filename_increment+4060
        DO j = 1, 6
            !filenames(i,j) = trim(variables(j))//'/'//trim(variables(j))//"_90x300x640_"//trim(fnn)//'.data'
            filenames(i,j) = "rot_"//trim(variables(j))//"_"//trim(fnn)//'.bin'
        ENDDO
    ENDDO
    print*, "filename(1,1) c_filename",trim(filenames(1,1))

#else
    use global, only: fn_UVEL,fn_VVEL,fn_THETA,fn_WVEL,fn_SALT,fn_GAMMA, filenames,Nrecs,filename_increment,FnPartiInit

    filenames(1,1)=fn_UVEL
    filenames(1,2)=fn_VVEL
    filenames(1,3)=fn_WVEL
    filenames(1,4)=fn_THETA
    filenames(1,5)=fn_SALT
    filenames(1,6)=fn_GAMMA

#endif

end subroutine c_filenames
