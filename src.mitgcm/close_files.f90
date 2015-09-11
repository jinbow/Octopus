subroutine close_files()
    use global, only: fn_ids,fn_uvwtsg_ids,fn_id_mld,NPP
    implicit none
    integer :: i
!    do i =1,20
!       do j=1,NPP
!        close(fn_ids(i,j))
!    enddo
!    enddo
    do i =1,6
        close(fn_uvwtsg_ids(i))
    enddo
    close(fn_id_mld)

end subroutine close_files
