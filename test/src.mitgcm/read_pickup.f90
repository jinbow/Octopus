subroutine read_pickup()
    use global, only: casename,xyz,tsg,tt,pickup
    implicit none
    character(len=128) :: fn

    write(fn,"(I10.10)") int(pickup)
    fn=trim(casename)//'.pickup.'//trim(fn)//'.data'
    open(10,file=trim(fn),form='unformatted',&
        access='stream',convert='BIG_ENDIAN',status='old')
    print*, "========================================="
    print*, "pickup data from "//fn

    read(10) xyz,tsg,tt

    close(10)

end subroutine read_pickup
