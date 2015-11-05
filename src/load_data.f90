subroutine load_data(IPP)
    use omp_lib
    use global, only: casename,tt,fn_ids,xyz,tsg,&
        Npts,parti_mld,DumpClock,&
        NPP,output_dir,pickup
    implicit none
    character(len=128) :: fn
    character(len=16) :: fn1
    !    integer*8 :: iwrite
    integer*8,intent(in) :: IPP
    real*4 :: xyz1(Npts,3) !,xyz2(Npts,3),xyz3(Npts)

    !    iwrite=int(tt/DumpClock)+1
    !tt=(pickup-1)*DumpClock
    !    write(fn,"(I10.10)") iwrite
    write(fn,"(I10.10)") int(pickup,8)
    write(fn1,"(I4.4)") IPP

    !$OMP PARALLEL SECTIONS
    !$OMP SECTION
    open(fn_ids(1,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.XYZ.'//trim(fn)//'.data',&
        access='direct',form='unformatted', convert='BIG_ENDIAN',recl=3*4*Npts,status='old')
    read(fn_ids(1,IPP),rec=1) xyz1
    close(fn_ids(1,IPP))
    xyz(:,:,IPP)=real(xyz1,8)

#ifdef saveTSG
    !$OMP SECTION
    open(fn_ids(2,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.TSG.'//trim(fn)//'.data',&
        access='direct',form='unformatted',convert='BIG_ENDIAN',recl=3*4*Npts,status='old')
    read(fn_ids(2,IPP),rec=1) xyz2
    close(fn_ids(2,IPP))
    tsg(:,:,IPP)=real(xyz2,8)
#endif

#ifdef useMLD
    !$OMP SECTION
    open(fn_ids(3,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.MLD.'//trim(fn)//'.data',&
        access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*Npts,status='old')
    read(fn_ids(3,IPP),rec=1) xyz3
    close(fn_ids(3,IPP))
    parti_mld(:,IPP)=real(xyz3,8)
#endif


!$OMP END PARALLEL SECTIONS

end subroutine load_data
