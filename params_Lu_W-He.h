c-----mass
      real(8),parameter:: am_W  = 183.84 *aump/aume
      real(8),parameter:: am_He =   4.0026 *aump/aume
c
c  cut off should be larger than R+D (=4.13158A+0.93018A =5.06176A)
c
c.....length scaling for hybrid QMCL calculation
      real(8),parameter:: slen= 1d0 /3.165d0 *3.172d0
      real(8),parameter:: aa2bs= aa2bohr *slen
c.....W-W and W-He parameters
      real(8),parameter:: p_D0(1:2,1:2)=(/
     &     2.87454d0 *ev2hrt,
     &     0.377472d0 *ev2hrt,
     &     0.377472d0 *ev2hrt,
     &     0d0 *ev2hrt
     &     /)
      real(8),parameter:: p_r0(1:2,1:2)=(/
     &     2.38631d0 *aa2bs,
     &     3.40623d0 *aa2bs,
     &     3.40623d0 *aa2bs,
     &     0d0 *aa2bs
     &     /)
      real(8),parameter:: p_beta(1:2,1:2)=(/
     &     1.33682d0  /aa2bs,
     &     0.602677d0 /aa2bs,
     &     0.602677d0 /aa2bs,
     &     0d0 /aa2bs
     &     /)
      real(8),parameter:: p_S(1:2,1:2)=(/
     &     1.25348d0,
     &     4.399296d0,
     &     4.399296d0,
     &     0d0
     &     /)
      real(8),parameter:: p_gamma(1:2,1:2)=(/
     &     8.3879d-4,
     &     2.623239d-2,
     &     2.623239d-2,
     &     0d0
     &     /)
      real(8),parameter:: p_c(1:2,1:2)=(/
     &     0.850284d0,
     &     0.371185d0,
     &     0.371185d0,
     &     0d0
     &     /)
      real(8),parameter:: p_d(1:2,1:2)=(/
     &     0.144317d0,
     &     0.252377d0,
     &     0.252377d0,
     &     0d0
     &     /)
      real(8),parameter:: p_h(1:2,1:2)=(/
     &     -0.36846d0,
     &     0.741345d0,
     &     0.741345d0,
     &     0d0
     &     /)
      real(8),parameter:: p_R1(1:2,1:2)=(/
     &     4.131580d0 *aa2bs,
     &     3.00d0 *aa2bs,
     &     3.00d0 *aa2bs,
     &     0d0 *aa2bs
     &     /)
      real(8),parameter:: p_D1(1:2,1:2)=(/
     &     0.930180d0 *aa2bs,
     &     0.35d0 *aa2bs,
     &     0.35d0 *aa2bs,
     &     0d0 *aa2bs
     &     /)
c.....He-He parameters
      real(8),parameter:: p_HeHe_rc    = p_R1(1,1) +p_D1(1,1)
      real(8),parameter:: p_HeHe_rm    = 2.970d0 *aa2bs
      real(8),parameter:: p_HeHe_A     = 1.9211529d+5
      real(8),parameter:: p_HeHe_alpha = 10.73520708d0
      real(8),parameter:: p_HeHe_c6    = 1.34920045d0
      real(8),parameter:: p_HeHe_c8    = 0.41365922d0
      real(8),parameter:: p_HeHe_c10   = 0.17078164d0
      real(8),parameter:: p_HeHe_beta  = -1.89296514d0
      real(8),parameter:: p_HeHe_D     = 1.4132d0
      real(8),parameter:: p_HeHe_eps   = 10.94d0 *fkb

      
