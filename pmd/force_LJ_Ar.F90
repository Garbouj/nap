module LJ_Ar
contains
  subroutine force_LJ_Ar(namax,natm,tag,ra,nnmax,aa,strs,h,hi,tcom &
       ,nb,nbmax,lsb,lsrc,myparity,nn,sv,rc,lspr &
       ,mpi_md_world,myid_md,epi,epot,nismax,acon,avol)
!-----------------------------------------------------------------------
!  Parallel implementation of LJ force calculation
!    - only force on i is considered, no need to send back
!-----------------------------------------------------------------------
    implicit none
    include "mpif.h"
    include "./params_unit.h"
    include "params_LJ_Ar.h"
    integer,intent(in):: namax,natm,nnmax,nismax
    integer,intent(in):: nb,nbmax,lsb(0:nbmax,6),lsrc(6),myparity(3) &
         ,nn(6),mpi_md_world,myid_md,lspr(0:nnmax,namax)
    real(8),intent(in):: ra(3,namax),h(3,3,0:1),hi(3,3),rc &
         ,acon(nismax),tag(namax),sv(3,6)
    real(8),intent(inout):: tcom,avol
    real(8),intent(out):: aa(3,namax),epi(namax),epot,strs(3,3,namax)

    integer:: i,j,k,l,m,n,ierr,is,ixyz,jxyz
    real(8):: xi(3),xij(3),rij,riji,dvdr &
         ,dxdi(3),dxdj(3),x,y,z,epotl,at(3),tmp

    logical,save:: l1st=.true.
    real(8),save:: vrc,dvdrc

    if( l1st ) then
!.....assuming fixed atomic volume
      avol= alcar**3 /4
      if(myid_md.eq.0) write(6,'(a,es12.4)') ' avol =',avol
!.....prefactors
      vrc= 4d0 *epslj *((sgmlj/rc)**12 -(sgmlj/rc)**6)
      dvdrc=-24.d0 *epslj *( 2.d0*sgmlj**12/(rc**13) &
           -sgmlj**6/(rc**7) )
!.....assuming fixed (constant) atomic volume
      avol= (2d0**(1d0/6) *sgmlj)**2 *sqrt(3d0) /2
      l1st=.false.
    endif

    aa(1:3,1:namax)=0d0
    epi(1:namax)= 0d0
    epotl= 0d0
    strs(1:3,1:3,1:natm+nb)= 0d0

!-----loop over resident atoms
    do i=1,natm
      xi(1:3)= ra(1:3,i)
      do k=1,lspr(0,i)
        j=lspr(k,i)
        if(j.eq.0) exit
        if(j.le.i) cycle
        x= ra(1,j) -xi(1)
        y= ra(2,j) -xi(2)
        z= ra(3,j) -xi(3)
        xij(1:3)= h(1:3,1,0)*x +h(1:3,2,0)*y +h(1:3,3,0)*z
        rij= sqrt(xij(1)**2+ xij(2)**2 +xij(3)**2)
        riji= 1d0/rij
        dxdi(1:3)= -xij(1:3)*riji
        dxdj(1:3)=  xij(1:3)*riji
        dvdr=(-24.d0*epslj)*(2.d0*(sgmlj*riji)**12*riji &
             -(sgmlj*riji)**6*riji) &
             -dvdrc
!---------force
        aa(1:3,i)=aa(1:3,i) -dxdi(1:3)*dvdr
        aa(1:3,j)=aa(1:3,j) -dxdj(1:3)*dvdr
!---------potential
        tmp= 0.5d0*( 4d0*epslj*((sgmlj*riji)**12 &
             -(sgmlj*riji)**6) -vrc -dvdrc*(rij-rc) )
        if(j.le.natm) then
          epi(i)=epi(i) +tmp
          epi(j)=epi(j) +tmp
          epotl= epotl +tmp +tmp
        else
          epi(i)=epi(i) +tmp
          epotl= epotl +tmp
        endif
!---------stress
        do ixyz=1,3
          do jxyz=1,3
            strs(jxyz,ixyz,i)=strs(jxyz,ixyz,i) &
                 -0.5d0*dvdr*xij(ixyz)*(-dxdi(jxyz))
            strs(jxyz,ixyz,j)=strs(jxyz,ixyz,j) &
                 -0.5d0*dvdr*xij(ixyz)*(-dxdi(jxyz))
          enddo
        enddo
      enddo
    enddo

!-----copy strs of boundary atoms
    call copy_strs_ba(tcom,namax,natm,nb,nbmax,lsb &
         ,lsrc,myparity,nn,sv,mpi_md_world,strs)
!-----atomic level stress in [eV/Ang^3] assuming 1 Ang thick
    do i=1,natm
      strs(1:3,1:3,i)= strs(1:3,1:3,i) /avol
    enddo

!-----reduced force
    do i=1,natm
      at(1:3)= aa(1:3,i)
      aa(1:3,i)= hi(1:3,1)*at(1) +hi(1:3,2)*at(2) +hi(1:3,3)*at(3)
    enddo
!-----multiply 0.5d0*dt**2/am(i)
    do i=1,natm
      is= int(tag(i))
      aa(1:3,i)= acon(is)*aa(1:3,i)
    enddo

!-----gather epot
    epot= 0d0
    call mpi_allreduce(epotl,epot,1,MPI_DOUBLE_PRECISION &
         ,MPI_SUM,mpi_md_world,ierr)
  end subroutine force_LJ_Ar
end module LJ_Ar
!-----------------------------------------------------------------------
!     Local Variables:
!     compile-command: "make pmd"
!     End:
