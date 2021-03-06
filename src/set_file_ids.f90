subroutine set_file_ids()

#include "cpp_options.h"

    use global,only : FnPartiInitId,fn_ids,Npts,NPP,&
#ifdef isArgo
    save_argo_FnIDs,&
#ifdef saveArgoProfile
    save_argo_profileIDs,&
#endif
#endif

#ifdef isGlider
    save_glider_FnIDs,&
#endif
   fn_uvwtsg_ids,fn_id_mld,output_dir

    implicit none
    integer*8 :: i,j,k

    k=9000
    ! file ids
    do i=1,11
       do j=1,NPP
        fn_ids(i,j) = k
        k=k+1
       enddo
    enddo


!===> glider file ID

#ifdef isGlider
    do i=1,Npts
       do j=1,NPP
        save_glider_FnIDs(i,j) = k
        k=k+1
       enddo
    enddo
#endif
print*, '-------+++'

    do i=1,7
        fn_uvwtsg_ids(i) = k
        k=k+1
    enddo

    fn_id_mld=k
    k=k+1
    FnPartiInitId=k
    k=k+1

#ifdef isArgo
   do i =1, Npts
      do j=1, NPP
        save_argo_FnIDs(i,j)=k
        k=k+1
#ifdef saveArgoProfile
        save_argo_profileIDs(i,j)=k
        k=k+1
#endif
      enddo
   enddo
#endif
       

    call system('mkdir -p '//trim(output_dir))

end subroutine set_file_ids
