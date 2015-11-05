subroutine save_pickup()
    use global, only: casename,tt,DumpClock,tsg,xyz
    implicit none
    character(len=64) :: fn
    write(fn,"(I10.10)") int(tt/DumpClock)+1
    print*, fn
    open(0,file=trim(casename)//'.pickup.'//trim(fn)//'.data',form='unformatted',&
        access='stream',convert='BIG_ENDIAN',status='replace')
    write(0) xyz,tsg,tt
    close(0)
end subroutine save_pickup
