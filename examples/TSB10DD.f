*     SB10DD EXAMPLE PROGRAM TEXT
*     Copyright (c) 2002-2020 NICONET e.V.
*
*     .. Parameters ..
      INTEGER          NIN, NOUT
      PARAMETER        ( NIN = 5, NOUT = 6 )
      INTEGER          NMAX, MMAX, PMAX
      PARAMETER        ( NMAX = 10, MMAX = 10, PMAX = 10 )
      INTEGER          LDA, LDB, LDC, LDD, LDAK, LDBK, LDCK, LDDK, LDX,
     $                 LDZ
      PARAMETER        ( LDA = NMAX, LDB = NMAX, LDC = PMAX, LDD = PMAX,
     $                   LDAK = NMAX, LDBK = NMAX, LDCK = PMAX,
     $                   LDDK = PMAX, LDX = NMAX, LDZ = NMAX )
      INTEGER          LIWORK
      PARAMETER        ( LIWORK = MAX( 2*MAX( MMAX, NMAX ),
     $                                 MMAX + PMAX, NMAX*NMAX ) )
      INTEGER          MPMX
      PARAMETER        ( MPMX = MAX( MMAX, PMAX ) )
      INTEGER          LDWORK
      PARAMETER        ( LDWORK =
     $                   MAX( ( NMAX + MPMX )*( NMAX + MPMX + 6 ),
     $                        13*NMAX*NMAX + MMAX*MMAX + 2*MPMX*MPMX +
     $                        NMAX*( MMAX + MPMX ) +
     $                        MAX( MMAX*( MMAX + 7*NMAX ),
     $                             2*MPMX*( 8*NMAX + MMAX + 2*MPMX ) )
     $                             + 6*NMAX +
     $                             MAX( 14*NMAX + 23, 16*NMAX,
     $                                  2*NMAX + MAX( MMAX, 2*MPMX ),
     $                                  3*MAX( MMAX, 2*MPMX ) ) ) )
*     .. Local Scalars ..
      DOUBLE PRECISION GAMMA, TOL
      INTEGER          I, INFO, J, M, N, NCON, NMEAS, NP
*     .. Local Arrays ..
      LOGICAL          BWORK(2*NMAX)
      INTEGER          IWORK(LIWORK)
      DOUBLE PRECISION A(LDA,NMAX), AK(LDA,NMAX), B(LDB,MMAX),
     $                 BK(LDBK,PMAX), C(LDC,NMAX), CK(LDCK,NMAX),
     $                 D(LDD,MMAX), DK(LDDK,PMAX), X(LDX,NMAX),
     $                 Z(LDZ,NMAX), DWORK(LDWORK), RCOND( 8 )
*     .. External Subroutines ..
      EXTERNAL         SB10DD
*     .. Intrinsic Functions ..
      INTRINSIC        MAX
*     .. Executable Statements ..
*
      WRITE ( NOUT, FMT = 99999 )
*     Skip the heading in the data file and read the data.
      READ ( NIN, FMT = '()' )
      READ ( NIN, FMT = * ) N, M, NP, NCON, NMEAS
      IF ( N.LT.0 .OR. N.GT.NMAX ) THEN
         WRITE ( NOUT, FMT = 99990 ) N
      ELSE IF ( M.LT.0 .OR. M.GT.MMAX ) THEN
         WRITE ( NOUT, FMT = 99989 ) M
      ELSE IF ( NP.LT.0 .OR. NP.GT.PMAX ) THEN
         WRITE ( NOUT, FMT = 99988 ) NP
      ELSE IF ( NCON.LT.0 .OR. NCON.GT.MMAX ) THEN
         WRITE ( NOUT, FMT = 99987 ) NCON
      ELSE IF ( NMEAS.LT.0 .OR. NMEAS.GT.PMAX ) THEN
         WRITE ( NOUT, FMT = 99986 ) NMEAS
      ELSE
         READ ( NIN, FMT = * ) ( ( A(I,J), J = 1,N ), I = 1,N )
         READ ( NIN, FMT = * ) ( ( B(I,J), J = 1,M ), I = 1,N )
         READ ( NIN, FMT = * ) ( ( C(I,J), J = 1,N ), I = 1,NP )
         READ ( NIN, FMT = * ) ( ( D(I,J), J = 1,M ), I = 1,NP )
         READ ( NIN, FMT = * ) GAMMA, TOL
         CALL SB10DD( N, M, NP, NCON, NMEAS, GAMMA, A, LDA, B, LDB,
     $                C, LDC, D, LDD, AK, LDAK, BK, LDBK, CK, LDCK,
     $                DK, LDDK, X, LDX, Z, LDZ, RCOND, TOL, IWORK,
     $                DWORK, LDWORK, BWORK, INFO )
         IF ( INFO.EQ.0 ) THEN
            WRITE ( NOUT, FMT = 99997 )
            DO 10 I = 1, N
               WRITE ( NOUT, FMT = 99992 ) ( AK(I,J), J = 1,N )
   10       CONTINUE
            WRITE ( NOUT, FMT = 99996 )
            DO 20 I = 1, N
               WRITE ( NOUT, FMT = 99992 ) ( BK(I,J), J = 1,NMEAS )
   20       CONTINUE
            WRITE ( NOUT, FMT = 99995 )
            DO 30 I = 1, NCON
               WRITE ( NOUT, FMT = 99992 ) ( CK(I,J), J = 1,N )
   30       CONTINUE
            WRITE ( NOUT, FMT = 99994 )
            DO 40 I = 1, NCON
               WRITE ( NOUT, FMT = 99992 ) ( DK(I,J), J = 1,NMEAS )
   40       CONTINUE
            WRITE( NOUT, FMT = 99993 )
            WRITE( NOUT, FMT = 99991 ) ( RCOND(I), I = 1, 8 )
         ELSE
            WRITE( NOUT, FMT = 99998 ) INFO
         END IF
      END IF
      STOP
*
99999 FORMAT (' SB10DD EXAMPLE PROGRAM RESULTS',/1X)
99998 FORMAT (/' INFO on exit from SB10DD =',I2)
99997 FORMAT (/' The controller state matrix AK is'/)
99996 FORMAT (/' The controller input matrix BK is'/)
99995 FORMAT (/' The controller output matrix CK is'/)
99994 FORMAT (/' The controller matrix DK is'/)
99993 FORMAT (/' The estimated condition numbers are'/)
99992 FORMAT (10(1X,F8.4))
99991 FORMAT ( 5(1X,D12.5))
99990 FORMAT (/' N is out of range.',/' N = ',I5)
99989 FORMAT (/' M is out of range.',/' M = ',I5)
99988 FORMAT (/' NP is out of range.',/' NP = ',I5)
99987 FORMAT (/' NCON is out of range.',/' NCON = ',I5)
99986 FORMAT (/' NMEAS is out of range.',/' NMEAS = ',I5)
      END
