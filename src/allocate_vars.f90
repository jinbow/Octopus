subroutine allocate_parti()
#include "cpp_options.h"

    use global
    !, only :xyz, xyz0, uvwp, dxyz_fac, tsg,&
    !                  pi2f,pj2f,pk2f,pi2c,pj2c,pk2c,&
    !                  dif, djf, dkf, dic, djc, dkc, parti_mld,&
    !                  NPP,Npts,fn_ids,grad
    print*, "----------------------------------------------"
    print*, "start allocation of variables ......"


    ALLOCATE ( xyz(Npts,3,NPP), &
        xyz0(Npts,3,NPP), &
        uvwp(Npts,3,NPP), &
        dxyz_fac(Npts,3,NPP) )

    ALLOCATE (tsg(Npts,4,NPP))

#ifdef isArgo
    ALLOCATE (argo_clock(Npts,2,NPP),&
              save_argo_FnIDs(Npts,NPP) )
    argo_clock(:,:,:)=0
#endif

    tsg=0e0


#ifdef saveGradient
    ALLOCATE (grad(Npts,5,NPP))
#endif

    ALLOCATE ( pi2f(Npts,NPP),&
        pj2f(Npts,NPP),&
        pk2f(Npts,NPP),&
        pi2c(Npts,NPP),&
        pj2c(Npts,NPP),&
        pk2c(Npts,NPP),&
        dif(Npts,NPP), &
        djf(Npts,NPP), &
        dkf(Npts,NPP), &
        dic(Npts,NPP), &
        djc(Npts,NPP), &
        dkc(Npts,NPP), &
        parti_mld(Npts,NPP) )

#ifdef isGlider
    ALLOCATE ( glider_clock(Npts,2,NPP),&
               glider_position(Npts,4,NPP),&
               glider_uv(Npts,2,NPP),&
               glider_angle(Npts,NPP),&
               glider_cycle(Npts,NPP),&
               save_glider_FnIDs(Npts,NPP) )
#endif


    ALLOCATE ( fn_ids(20,NPP) )

    print*, "end allocation of variables ......"

end subroutine allocate_parti
