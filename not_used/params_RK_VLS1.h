c-----RK parameters based on LJ-Argon
      real(8),parameter:: eps_rk(2,2)= (/ 240d0*fkb, 120d0*fkb,
     &                                    120d0*fkb, 120d0*fkb /)
      real(8),parameter:: sgm_rk(2,2)= (/ 3.41d-10/ang, 3.41d-10/ang,
     &                                    3.41d-10/ang, 3.41d-10/ang/)
      real(8),parameter:: am_ar = 39.948d0
      integer,parameter:: nd_rk = 2048
