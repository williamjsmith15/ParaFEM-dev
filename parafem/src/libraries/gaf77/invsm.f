c  *****************************************************************
c  *                                                               *
c  *                  Subroutine invsm                             *
c  *                                                               *
c  *****************************************************************
c  Single Precision Version 1.11
c  Written by Gordon A. Fenton, Princeton, Jan. 20, 1988.
c  Latest Update: Jun 9, 1999
c
c  PURPOSE  compute the inverse of a real symmetric matrix
c
c  INVSM calls FACLD to decompose the real symmetric positive definite
c  matrix A into L*D*L' form where L is lower triangular and is stored in
c  the lower triangle of A and D is diagonal with the reciprocals of its
c  elements stored in the diagonal of A. The inverse of L is then found and
c  rewritten into the lower triangle of A followed by the inverse of A,
c  again written into its own lower triangle.
c  Argument are as follows;
c
c     A   input positive definite symmetric matrix with necessary values
c         stored in the upper triangle and diagonal. On output, the inverse of
c         A is stored in the lower triangle A(i,j), i = 1,n and j = 1,i
c         (including the diagonal, which is overwritten). (input/output)
c
c    IA   input integer containing the column dimension of A as specified in
c         the calling routine. (input)
c
c     n   order of the matrix A. (input)
c
c  ierr   integer error flag which is set to zero if inversion is successfull
c         and to -1 if the matrix is found to be algorithmically singular.
c         (output)
c
c  REVISION HISTORY:
c  1.1	returns ierr = 0 now when it works.
c  1.11	replaced dummy dimensions with a (*) for GNU's compiler (Jun 9/99)
c----------------------------------------------------------------------------
      Subroutine invsm( A, ia, n, ierr )
      dimension A(ia,1)
      data zero/0.0/
c                              decompose A by Crout's method; form L and D
      ierr = -1
      det  = facld( A, ia, n )
      if ( det .eq. zero ) return
c                          overwrite L with L-inverse in lower triangle of A
      do 20 i = 1, n
      do 20 j = i+1, n
         z = -A(j,i)
         do 10 k = i+1, j-1
            z = z - A(j,k) * A(k,i)
  10     continue
         A(j,i) = z
  20  continue
c                          overwrite L-inverse with A-inverse
      do 40 i = 1, n
         z = A(i,i)
         do 30 k = i+1, n
            y = A(k,i)
            A(k,i) = A(k,i) * A(k,k)
            z = z + y * A(k,i)
  30     continue
         A(i,i) = z
c
         do 40 j = i+1, n
         do 40 k = j+1, n
            A(j,i) = A(j,i) + A(k,j) * A(k,i)
  40  continue
c
      ierr = 0
      return
      end
