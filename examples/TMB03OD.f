*     MB03OD EXAMPLE PROGRAM TEXT
*
*     .. Parameters ..
      DOUBLE PRECISION ZERO, ONE
      PARAMETER        ( ZERO = 0.0D0, ONE = 1.0D0 )
      INTEGER          NIN, NOUT
      PARAMETER        ( NIN = 5, NOUT = 6 )
      INTEGER          NMAX, MMAX
      PARAMETER        ( NMAX = 10, MMAX = 10 )
      INTEGER          LDA
      PARAMETER        ( LDA = NMAX )
      INTEGER          LDTAU
      PARAMETER        ( LDTAU = MIN(MMAX,NMAX) )
      INTEGER          LDWORK
      PARAMETER        ( LDWORK = 3*NMAX + 1 )
*     .. Local Scalars ..
      CHARACTER*1      JOBQR
      INTEGER          I, INFO, J, M, N, RANK
      DOUBLE PRECISION RCOND, SVAL(3), SVLMAX
*     ..
*     .. Local Arrays ..
      DOUBLE PRECISION A(LDA,NMAX), DWORK(LDWORK), TAU(LDTAU)
      INTEGER          JPVT(NMAX)
*     .. External Subroutines ..
      EXTERNAL         MB03OD
*     .. Intrinsic Functions ..
      INTRINSIC        MIN
*     .. Executable Statements ..
*
      WRITE ( NOUT, FMT = 99999 )
*     Skip the heading in the data file and read the data.
      READ ( NIN, FMT = '()' )
      READ ( NIN, FMT = * ) M, N, JOBQR, RCOND, SVLMAX
      IF ( N.LT.0 .OR. N.GT.NMAX ) THEN
         WRITE ( NOUT, FMT = 99972 ) N
      ELSE
         IF ( M.LT.0 .OR. M.GT.MMAX ) THEN
            WRITE ( NOUT, FMT = 99971 ) M
         ELSE
            READ ( NIN, FMT = * ) ( ( A(I,J), J = 1,N ), I = 1,M )
*           QR with column pivoting.
            DO 10 I = 1, N
               JPVT(I) = 0
   10       CONTINUE
            CALL MB03OD( JOBQR, M, N, A, LDA, JPVT, RCOND, SVLMAX, TAU,
     $                   RANK, SVAL, DWORK, LDWORK, INFO )
*
            IF ( INFO.NE.0 ) THEN
               WRITE ( NOUT, FMT = 99998 ) INFO
            ELSE
               WRITE ( NOUT, FMT = 99995 ) RANK
               WRITE ( NOUT, FMT = 99994 ) ( JPVT(I), I = 1,N )
               WRITE ( NOUT, FMT = 99993 ) ( SVAL(I), I = 1,3 )
            END IF
         END IF
      END IF
*
      STOP
*
99999 FORMAT (' MB03OD EXAMPLE PROGRAM RESULTS',/1X)
99998 FORMAT (' INFO on exit from MB03OD = ',I2)
99995 FORMAT (' The rank is ',I5)
99994 FORMAT (' Column permutations are ',/(20(I3,2X)))
99993 FORMAT (' SVAL vector is ',/(20(1X,F10.4)))
99972 FORMAT (/' N is out of range.',/' N = ',I5)
99971 FORMAT (/' M is out of range.',/' M = ',I5)
      END
