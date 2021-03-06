
!-----------------------------------------------------------------
!	Programmed by Youn Shik Park
!-----------------------------------------------------------------

	include 'param.f'

      PROGRAM AMC_STEPL

	REAL FinOptParm(10), ObsVal(6)
	! ObsVal	| Runoff, Baseflow, N, P, BOD, S


!--------Calibrate Runoff and Baseflow
	call WaterOpt
	open(12, file='amc_status_w.pys', status='replace')
	  write(12,*) 'ys'
	close(12)
	

!--------Calibrate Nutrients
	open(2, file='stepl_obs.pys', status='old')
	  do i=1, 6
	    read(2,*) ObsVal(i)
	  enddo
	close(2)

	! sediment
	if (ObsVal(6) < 99999999.0) then
	  call SedOpt(ObsVal(6),6)
	  open(14, file='amc_status_s.pys', status='replace')
	    write(14,*) 'ys'
	  close(14)
	endif

	! N
	if (ObsVal(3) < 99999999.0) then
	  call NutOpt(ObsVal(3),3)
	  open(16, file='amc_status_n.pys', status='replace')
	    write(16,*) 'ys'
	  close(16)
	endif

	! P
	if (ObsVal(4) < 99999999.0) then
	  call NutOpt(ObsVal(4),4)
	  open(16, file='amc_status_p.pys', status='replace')
	    write(16,*) 'ys'
	  close(16)
	endif

	! BOD
	if (ObsVal(5) < 99999999.0) then
	  call NutOpt(ObsVal(5),5)
	  open(16, file='amc_status_b.pys', status='replace')
	    write(16,*) 'ys'
	  close(16)
	endif

        open(20, file='amc_status_d.pys', status='replace')
          write(20,*) 'ys'
	close(20)

      END



!------------------------------------------------------------
	SUBROUTINE NutOpt(CurObsVal,NutNum)
	
	REAL CurObsVal, CurPar(6), CurDiff, CurSimVal(6), Diff(20)
	REAL myParCur
	INTEGER NutNum, CurIdx
!	CurObsVal				| Observed Value
!	CurPar(:)				| Opt. values of myOptPar.pys
!	CurDiff					| Smallest Difference between Obs. and Sim.
!	Diff(:)					| Current Difference between Obs. and Sim.
!	NutNum					| 3-6. N, P, BOD, or Sediment
!	CurIdx					| Index of Smallest Difference
!	myParCur


!	write(*,*) CurObsVal, NutNum
	open(4, file='myOptPar.pys', status='old')
	  do i = 1, 6
	    read(4,*) CurPar(i)
	  enddo
	close(4)


	!----1st loop
	CurDiff = 9999999999.99
	do i = 1, 20

	  CurPar(NutNum) = i/1.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/1.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo
	

	myParCur = (CurIdx-1) / 1.0


!	write(*,*) myParCur
!	write(*,*) '==========================='
	!-- 2nd loop
	do i = 1, 20
	  CurPar(NutNum) = myParCur + i/10.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/10.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo	

	myParCur = myParCur + (CurIdx-1) / 10.0

!	write(*,*) myParCur
!	write(*,*) '==========================='


	!-- 3rd loop
	do i = 1, 20
	  CurPar(NutNum) = myParCur + i/100.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/100.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo	

	myParCur = myParCur + (CurIdx-1) / 100.0

!	write(*,*) myParCur
!	write(*,*) '==========================='


	!-- 4th loop
	do i = 1, 20
	  CurPar(NutNum) = myParCur + i/1000.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/1000.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo	

	myParCur = myParCur + (CurIdx / 1000.0)

!	write(*,*) myParCur
!	write(*,*) '==========================='


	END
!------------------------------------------------------------
!------------------------------------------------------------
!------------------------------------------------------------
!------------------------------------------------------------
	SUBROUTINE SedOpt(CurObsVal,NutNum)
	
	REAL CurObsVal, CurPar(6), CurDiff, CurSimVal(6), Diff(20)
	REAL myParCur
	INTEGER NutNum, CurIdx
!	CurObsVal				| Observed Value
!	CurPar(:)				| Opt. values of myOptPar.pys
!	CurDiff					| Smallest Difference between Obs. and Sim.
!	Diff(:)					| Current Difference between Obs. and Sim.
!	NutNum					| 3-6. N, P, BOD, or Sediment
!	CurIdx					| Index of Smallest Difference
!	myParCur


!	write(*,*) CurObsVal, NutNum
	open(4, file='myOptPar.pys', status='old')
	  do i = 1, 6
	    read(4,*) CurPar(i)
	  enddo
	close(4)


	!----1st loop
	CurDiff = 9999999999.99
	do i = 1, 12

	  CurPar(NutNum) = i/10.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/10.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo
	

	myParCur = (CurIdx-1) / 10.0


!	write(*,*) myParCur
!	write(*,*) '==========================='
	!-- 2nd loop
	do i = 1, 20
	  CurPar(NutNum) = myParCur + i/100.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/100.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo	

	myParCur = myParCur + (CurIdx-1) / 100.0

!	write(*,*) myParCur
!	write(*,*) '==========================='


	!-- 3rd loop
	do i = 1, 20
	  CurPar(NutNum) = myParCur + i/1000.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/1000.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo	

	myParCur = myParCur + (CurIdx-1) / 1000.0

!	write(*,*) myParCur
!	write(*,*) '==========================='


	!-- 4th loop
	do i = 1, 20
	  CurPar(NutNum) = myParCur + i/10000.0
	  open(4, file='myOptPar.pys', status='replace')
	    do j = 1, 6
	      write(4,*) CurPar(j)
	    enddo
	  close(4)

	  call STEPL

	  open(6, file='stepl_rst.pys', status='old')
	    do j = 1, 6
	      read(6,*) CurSimVal(j)
	    enddo
	  close(6)

	  Diff(i) = abs(CurSimVal(NutNum)-CurObsVal)
!	  write(*,*) i/10000.0, Diff(i)

	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif	  	

	enddo	

	myParCur = myParCur + (CurIdx / 10000.0)

!	write(*,*) myParCur
!	write(*,*) '==========================='


	END
!------------------------------------------------------------
!------------------------------------------------------------
!------------------------------------------------------------
!------------------------------------------------------------
! The subroutine optimizes OptParm(1) and OptParm(2).
	SUBROUTINE WaterOpt

	REAL SimRunoff, ObsRunoff, ObsBaseflow, SimBaseflow
	REAL MyParm(2), TmpParm(20), Diff(20), CurDiff, CurIdx

	open(2, file='stepl_obs.pys', status='old')
	  read(2,*) ObsRunoff
	  read(2,*) ObsBaseflow
	close(2)

	! Optimize Runoff ----------------------------------------------------------
	CurDiff = 9999999999.99
	do i = 1, 15
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) i/10.0
	    do j = 1, 5
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*) SimRunoff
	  close(6)
	  Diff(i) = abs(SimRunoff-ObsRunoff)
!	  write(*,*) i/10.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo

	MyParm(1) = (CurIdx-1) / 10.0

!	write(*,*) '==========================='
	do i = 1, 20
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1) + i/100.0
	    do j = 1, 5
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*) SimRunoff
	  close(6)
	  Diff(i) = abs(SimRunoff-ObsRunoff)
!	  write(*,*) MyParm(1) + i/100.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo
	
	MyParm(1) = MyParm(1) + (CurIdx-1)/100.0

!	write(*,*) '==========================='
	do i = 1, 20
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1) + i/1000.0
	    do j = 1, 5
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*) SimRunoff
	  close(6)
	  Diff(i) = abs(SimRunoff-ObsRunoff)
!	  write(*,*) MyParm(1) + i/1000.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo

	MyParm(1) = MyParm(1) + (CurIdx-1)/1000.0

!	write(*,*) '==========================='
	do i = 1, 20
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1) + i/10000.0
	    do j = 1, 5
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*) SimRunoff
	  close(6)
	  Diff(i) = abs(SimRunoff-ObsRunoff)
!	  write(*,*) MyParm(1) + i/10000.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo

	MyParm(1) = MyParm(1) + CurIdx/10000.0
!	write(*,*) 'RUNOFF:', MyParm(1)

	! Optimize Baseflow --------------------------------------------------------
	CurDiff = 9999999999.99
	do i = 1, 15
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1)
	    write(4,*) i/10.0
	    do j = 1, 4
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*) 
	    read(6,*) SimBaseflow
	  close(6)
	  Diff(i) = abs(SimBaseflow-ObsBaseflow)
!	  write(*,*) i/10.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo

	MyParm(2) = (CurIdx-1) / 10.0

!	write(*,*) '==========================='
	do i = 1, 20
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1)
	    write(4,*) MyParm(2) + i/100.0
	    do j = 1, 4
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*)
	    read(6,*) SimBaseflow
	  close(6)
	  Diff(i) = abs(SimBaseflow-ObsBaseflow)
!	  write(*,*) MyParm(2) + i/100.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo
	
	MyParm(2) = MyParm(2) + (CurIdx-1)/100.0

!	write(*,*) '==========================='
	do i = 1, 20
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1)
	    write(4,*) MyParm(2) + i/1000.0
	    do j = 1, 4
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*)
	    read(6,*) SimBaseflow
	  close(6)
	  Diff(i) = abs(SimBaseflow-ObsBaseflow)
!	  write(*,*) MyParm(2) + i/1000.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo

	MyParm(2) = MyParm(2) + (CurIdx-1)/1000.0

!	write(*,*) '==========================='
	do i = 1, 20
	  open(4, file='myOptPar.pys', status='replace')
	    write(4,*) MyParm(1)
	    write(4,*) MyParm(2) + i/10000.0
	    do j = 1, 4
	      write(4,*) '1.0'
	    enddo
	  close(4)
	  call STEPL
	  open(6, file='stepl_rst.pys', status='old')
	    read(6,*)
	    read(6,*) SimBaseflow
	  close(6)
	  Diff(i) = abs(SimBaseflow-ObsBaseflow)
!	  write(*,*) MyParm(2) + i/10000.0, Diff(i)
	  if ( Diff(i) < CurDiff ) then
	    CurDiff = Diff(i)
	    CurIdx = i
	  endif
	enddo

	MyParm(2) = MyParm(2) + CurIdx/10000.0
!	write(*,*) 'BASEFLOW:', MyParm(2)

	!---------------- RE-RUN ------------------------------
	open(4, file='myOptPar.pys', status='replace')
	  write(4,*) MyParm(1)
	  write(4,*) MyParm(2)
	  do j = 1, 4
	    write(4,*) '1.0'
	  enddo
	close(4)
	call STEPL

	END
!------------------------------------------------------------
!------------------------------------------------------------
!------------------------------------------------------------
!-------------------STEPL------------------------------------
!------------------------------------------------------------
!------------------------------------------------------------
	SUBROUTINE STEPL
	
	use parm
		
	REAL :: AnnualRunoff(3), AnnualBaseflow
	! AnnualRunoff(2)		| Sum of Direct Runoff
	!						|  1: Other Landuse
	!						|  2: Urban
	!						|  3: Sum of 1 and 2
	! AnnualBaseflow		| Sum of Baseflow

!----------------------------------------------S read OptParm-------------------
	open(2, file='myOptPar.pys', status='old')
	  do i = 1, 6
	    read(2,*) OptParm(i)
	  enddo 
	close(2)
!----------------------------------------------E read OptParm-------------------

!----------S read main input file (mainINP.txt)---------------------------------
	open(1, file='mainINP.txt', status='old')
	  read(1,*) num, swsOpt
	  read(1,*)										! Table 1 
	  do i = 1, num
	    read(1,*) (LuseAreaWS(j,i),j=1,6), PctFeedlot(i), TAreaWS(i)
!     &			  AnnualR(i), RDays(i), AvgR(i)
	  enddo
!	  read(1,*) AnnualRF, RDaysF
	  read(1,*)										! Table 2
	  do i =1, num
	    read(1,*) (Animals(j,i),j=1,8), NumMonManure(i)
	  enddo
	  read(1,*)										! Table 3
	  do i = 1, num
	    read(1,*) NumSpSys(i), PpSpSys(i),SpFailRate(i), 
     &		      NumPpDrtDc(i), RdcDrtDc(i)
	  enddo
	  read(1,*)										! Table 4
	  do i = 1, num
	    read(1,*) (usleCropland(j,i),j=1,5)
	  enddo
	  read(1,*)
	  do i = 1, num
	    read(1,*) (uslePasture(j,i),j=1,5)
	  enddo
	  read(1,*)
	  do i = 1, num
	    read(1,*) (usleForest(j,i),j=1,5)
	  enddo	
	  read(1,*)
	  do i = 1, num
	    read(1,*) (usleUser(j,i),j=1,5)
	  enddo
	  read(1,*)										! Table 5
	  do i = 1, num
	    read(1,*) SHG(i), SoilNconc(i), SoilPconc(i), SoilBODconc(i)
	  enddo
	  read(1,*)										! Table 6
	  do i = 1, 5
	    read(1,*) (CN(j,i),j=1,4)
	  enddo
	  read(1,*)										! Table 6a
	  do i = 1, 9
	    read(1,*) (UrbanCN(j,i),j=1,4)
	  enddo
	  read(1,*)										! Table 7
	  do i = 1, 9
	    read(1,*) (NtConcRunoff(j,i),j=1,3)
	  enddo
	  read(1,*)										! Table 7a
	  do i = 1, 6
	    read(1,*) (NtConcGW(j,i),j=1,3)
	  enddo
	  read(1,*)										! Table 8
	  do i = 1, num
	    read(1,*) (UrbanDst(j,i),j=1,11)
	  enddo
	  read(1,*)										! Table 9
	  do i = 1, num
	    read(1,*) (Irrigation(j,i),j=1,5)
	  enddo

	close(1)

!----------E read main input file (mainINP.txt)---------------------------------
!----------------------------------------------S GW1 (LandRain_GW1.txt)---------
	open(2, file='LandRain_GW1.txt', status='old')
	  read(2,*)
	  do i = 1, 5
	    read(2,*) (GW1(j,i),j=1,4)
	  enddo
	close(2)
!----------------------------------------------E GW1 (LandRain_GW1.txt)---------
!------S update parameters by OptParm()-----------------------------------------
	do i = 1, 4
	  do j = 1, 5
	    CN(i,j) = CN(i,j) * OptParm(1)
	    if ( 100.0 < CN(i,j) ) CN(i,j) = 100.0
	  enddo
	  do j = 1, 9
	    UrbanCN(i,j) = UrbanCN(i,j) * OptParm(1)
	    if ( 100.0 < UrbanCN(i,j) ) UrbanCN(i,j) = 100.0
	  enddo
	  do j = 1, 5
	    GW1(i,j) = GW1(i,j) * OptParm(2)
	    if ( 0.9 < GW1(i,j) ) GW1(i,j) = 0.9
	  enddo
	enddo

	do i = 1, 3		! N, P BOD
	  do j = 1, 9
	    NtConcRunoff(i,j) = NtConcRunoff(i,j) * OptParm(i+2)
	  enddo
	  do j = 1, 6
	    NtConcGW(i,j) = NtConcGW(i,j) * OptParm(i+2)
	  enddo
	enddo


	DREC(1) = OptParm(6)



!------E update parameters by OptParm()-----------------------------------------

	Lambda = 0.2				! LandRain, shoud be 0.2
	call ANRUNOFF
	call LANDRAIN
	call BMPS
	call ANIMAL
	call FEEDLOTS
	call SEPTIC
	call SEDIMENT
	call URBAN
	call GULLY
	call TOTALLOAD

!!	open(10, file='myRST.csv', status='replace', recl=9999999)
!!	write(10,*) 'Watershed,N Load (no BMP),P Load (no BMP),
!!     &BOD Load (no BMP),Sediment Load (no BMP),N Reduction,
!!     &P Reduction,BOD Reduction,Sediment Reduction,N Load (with BMP),
!!     &P Load (with BMP),BOD (with BMP),Sediment Load (with BMP),	
!!     &%N Reduction,%P Reduction,%BOD Reduction,%Sed Reduction'

!	do i = 1, num
!	  write(10,*) i, (TL1(j,i),j=1,4)
!	enddo
!	do i = 1, num
!	  write(10,*) i, (TL1(j,i),j=5,8)
!        enddo
!	do i = 1, num
!          write(10,*) i, (TL1(j,i),j=9,12)
!	enddo
!	do i = 1, num
!	  write(10,*) i, (TL1(j,i),j=13,16)
!	enddo

!!	do i = 1, num
!!	  write(10,*) i, (TL1(j,i),j=1,16)
!!	enddo
!!	write(10,*) 'Total', (TL1(j,31),j=1,16)
!!	write(10,*) (TL1(j,31),j=1,16)
!!	close(10)
	
	AnnualRunoff(1) = 0.0
	AnnualRunoff(2) = 0.0
	AnnualRunoff(3) = 0.0
	AnnualBaseflow = 0.0
	do i = 1, num
	  AnnualRunoff(1) = AnnualRunoff(1) + VRunoff(6,i)
	  do j = 1, 9
	    AnnualRunoff(2) = AnnualRunoff(2) + VUrbanRunoff(j,i)
	  enddo
	  do j = 1, 6
	    AnnualBaseflow = AnnualBaseflow + GW4(j,i)
	  enddo
	enddo
	AnnualRunoff(3) = AnnualRunoff(1) + AnnualRunoff(2)

	! Runoff, Baseflow, N, P, BOD, S
	open(10, file='stepl_rst.pys', status='replace', recl=9999999)
	  write(10,*) AnnualRunoff(3)
	  write(10,*) AnnualBaseflow
	  do i = 1, 4
	    write(10,*) TL1(i,31)
	  enddo
	close(10)
	
	END

!---------------------------S SUBROUTINES---------------------------------------

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE ANRUNOFF
	use parm
	INTEGER :: pcpCount, tmpVal
	REAL :: myS, myS2, myS8, depth, depthSum
	! depth: daily runoff depth
	! depthSum: sum of daily runoff depth
	
	pcpCount = 0
	open(13, file='pcp.txt', status='old')
	  do i=1, 40000
	    read(13,*,end=1001) tmpVal, Rainfall(i)
	    pcpCount = pcpCount + 1
	  enddo
1001    continue
	close(13)

      !write(*,*) pcpCount 
	
	! General Luse
	do i=1, 5								! luse
	  do j=1, 4								! hsg
	    if ( 0.0 < CN(j,i) ) then
	      myS = 25400.0 / CN(j,i) - 254.0
	    else
	      myS = 10000000000000.0 
	    endif	    
	    myS2 = myS * 0.2
	    myS8 = myS * 0.8
	    depth = 0.0
	    depthSum = 0.0
	    do k=1, pcpCount							! pcp
	      if ( myS2 < Rainfall(k) ) then
	        depth = ( (Rainfall(k)-myS2)**2 )/(Rainfall(k)+myS8)	
	      else
	        depth = 0.0
	      endif
	      depthSum = depthSum + depth
	    enddo								! k, pcp
	    depthSum = depthSum / pcpCount * 365
	    anDepth(j,i) = depthSum
	  enddo									! j, hsg
	enddo									! i, luse

	! Urban Luse
	do i=1, 9								! luse
	  do j=1, 4								! hsg
	    if ( 0.0 < UrbanCN(j,i) ) then
	      myS = 25400.0 / UrbanCN(j,i) - 254.0
	    else
	      myS = 10000000000000.0
	    endif	    
	    myS2 = myS * 0.2
	    myS8 = myS * 0.8
	    depth = 0.0
	    depthSum = 0.0
	    do k=1, pcpCount							! pcp
	      if ( myS2 < Rainfall(k) ) then
	        depth = ( (Rainfall(k)-myS2)**2 )/(Rainfall(k)+myS8)	
	      else
	        depth = 0.0
	      endif
	      depthSum = depthSum + depth
	    enddo								! k, pcp
	    depthSum = depthSum / pcpCount * 365
	    anDepth(j,i+5) = depthSum
	  enddo									! j, hsg
	enddo									! i, luse


	! Feedlot
	feCN(1) = 91
	feCN(2) = 92
	feCN(3) = 93
	feCN(4) = 94

	do j=1, 4								! hsg
	  if ( 0.0 < feCN(j) ) then
	    myS = 25400.0 / feCN(j) - 254.0
	  else
	    myS = 10000000000000.0
	  endif	    
	  myS2 = myS * 0.2
	  myS8 = myS * 0.8
	  depth = 0.0
	  depthSum = 0.0
	  do k=1, pcpCount							! pcp
	    if ( myS2 < Rainfall(k) ) then
	      depth = ( (Rainfall(k)-myS2)**2 )/(Rainfall(k)+myS8)	
	    else
	      depth = 0.0
	    endif
	    depthSum = depthSum + depth
	  enddo									! k, pcp
	  depthSum = depthSum / pcpCount * 365
	  feDepth(j) = depthSum / 25.4						! mm -> in
	enddo									! j, hsg

		
	! Calculate Annual Precipitation
	anPcpDepth = 0.0
	do i=1, pcpCount
	  anPcpDepth = anPcpDepth + Rainfall(i)
	enddo
	anPcpDepth = anPcpDepth / pcpCount * 365

!	do i=1, 14
!	  write(*,*) anDepth(1,i),anDepth(2,i),anDepth(3,i),anDepth(4,i)
!	enddo
!	write(*,*) anPcpDepth
	
		
	END ! ANRUNOFF
	 
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE LANDRAIN
	use parm
!	REAL :: anDepth(4,15)				! array of anDepth.txt

	! Table 1a, Detailed urban land use area (ac)
	do i = 1, num
	  UrbanArea(10,i) = 0.0
	  UrbanArea(11,i) = 0.0
	  do j = 1, 9
	    UrbanArea(j,i) = UrbanDst(j+1,i) * UrbanDst(1,i) / 100
	    UrbanArea(10,i) = UrbanArea(10,i) + UrbanArea(j,i)
	  enddo
	  UrbanArea(11,i) = UrbanArea(10,i) - ( UrbanArea(1,i) * 0.85 +
     &		UrbanArea(2,i) * 0.7  + UrbanArea(3,i) * 0.5  +
     &		UrbanArea(4,i) * 0.95 + UrbanArea(5,i) * 0.75 +
     &		UrbanArea(6,i) * 0.3  + UrbanArea(7,i) * 0.01 +
     &		UrbanArea(8,i) * 0.7  + UrbanArea(9,i) * 0.01 )
	enddo

	! Table 2.1, Curve Number
	do i = 1, num
	  do j = 1, 5
	    myCN(j,i) = CN(SHG(i),j)
	  enddo
	enddo

!!!!	open(11, file='anDepth.txt', status='old')
!!!!	  do i = 1, 14
!!!!	    read(11,*) anDepth(1,i), anDepth(2,i), 
!!!!     &               anDepth(3,i), anDepth(4,i)
!!!!	  enddo
!!!!	 read(11,*) anPcpDepth
!!!!	close(11)
	anPcpDepth = anPcpDepth * 0.03937
	! inch     = mm * 0.03937

	! Table 2.2, Calculated runoff (in)
!	do i = 1, num
!	  do j = 1, 5
!	    if ( 0 < (AvgR(i)-Lambda*(1000/myCN(j,i)-10)) ) then
!	      Runoff(j,i) = 
!     &		  ( AvgR(i)-Lambda*(1000/myCN(j,i)-10) )**2 /
!     &		  ( AvgR(i)+(1-Lambda)*(1000/myCN(j,i)-10) )
!	    else
!	      Runoff(j,i) = 0.0
!	    endif
!	  enddo
!	enddo


	do i = 1, num
	  do j = 1, 5
	    Runoff(j,i) = anDepth(SHG(i),j) * 0.03937
		  !      in = mm * 0.03937 
	  enddo
	enddo

	! Table 2.1a, Urban Runoff Curve Number
	do i = 1, num
	  do j = 1, 9
	    myUrbanCN(j,i) = UrbanCN(SHG(i),j)
	  enddo
	enddo

	! Table 2.2a, Runoff by urban landuse (in)
!	do i = 1, num
!	  do j = 1, 9
!	    if ( 0 < (AvgR(i)-Lambda*(1000/myUrbanCN(j,i)-10)) ) then
!	      UrbanRunoff(j,i) = 
!     &		  ( AvgR(i)-Lambda*(1000/myUrbanCN(j,i)-10) )**2 /
!     &		  ( AvgR(i)+(1-Lambda)*(1000/myUrbanCN(j,i)-10) )
!	    else
!	      UrbanRunoff(j,i) = 0.0
!	    endif
!	  enddo
!	enddo
	do i = 1, num
	  do j = 6, 14
	    UrbanRunoff(j-5,i) = anDepth(SHG(i),j) * 0.03937
		  !      in = mm * 0.03937 
	  enddo
	enddo
	
	! Table 2.3, Irrigation runoff (in)
	do i = 1, num
	  if ( 0 < (Irrigation(3,i)-Lambda*(1000/myCN(2,i)-10)) ) then
	    IrRunoff(1,i) =
     &        (Irrigation(3,i)-Lambda*(1000/myCN(2,i)-10)) ** 2 /
     &		(Irrigation(3,i)+(1-Lambda)*(1000/myCN(2,i)-10))
	  else
	    IrRunoff(1,i) = 0.0
	  endif
	  if ( 0 < (Irrigation(4,i)-Lambda*(1000/myCN(2,i)-10)) ) then
	    IrRunoff(2,i) =
     &        (Irrigation(4,i)-Lambda*(1000/myCN(2,i)-10)) ** 2 /
     &		(Irrigation(4,i)+(1-Lambda)*(1000/myCN(2,i)-10))
	  else
	    IrRunoff(2,i) = 0.0
	  endif
	  IrRunoff(3,i) = IrRunoff(1,i) - IrRunoff(2,i)
	enddo

	! Table GW2, Infiletation Fraction Based on SHG
	do i = 1, num
	  do j = 1, 5
	    GW2(j,i) = GW1(SHG(i),j)
	  enddo
	enddo	

	! Table GW3, Calculated Infiltration (in)
	do i = 1, num
	  do j = 1, 5
!	    GW3(j,i) = GW2(j,i) * AvgR(i)
	    GW3(j,i) = GW2(j,i) * anPcpDepth
	    ! in     = fraction * inch
	  enddo
	enddo	

	! Table GW4, Calculated infiltration volume (ac-ft)
	do i = 1, num
!	  GW4(1,i) = (GW3(1,i)/12) * RDays(i) * RDaysF * UrbanArea(11,i)
	  GW4(1,i) = (GW3(1,i)/12) * UrbanArea(11,i)
	  do j = 2, 5
!	    GW4(j,i) = (GW3(j,i)/12) * RDays(i) * RDaysF 
!     &					* LuseAreaWS(j,i)
	    GW4(j,i) = (GW3(j,i)/12) * LuseAreaWS(j,i)
	  enddo
	enddo
	! GW4(6,i) is calculated in "FEEDLOTS subroutine".


	! Table 4, Annual runoff by land uses (ac-ft)
	do i = 1, num
	  VRunoff(6,i) = 0.0
	  do j = 1, 5
	    VRunoff(j,i) = Runoff(j,i) / 12 * LuseAreaWS(j,i)
!     &				   LuseAreaWS(j,i) * RDays(i) * RDaysF
	  enddo
	  VRunoff(2,i) = VRunoff(2,i) + 
     &			IrRunoff(1,i) / 12 * Irrigation(2,i) * Irrigation(5,i)
	  do j = 1, 5
     	    VRunoff(6,i) = VRunoff(6,i) + VRunoff(j,i)
	  enddo
	enddo


	! Table 4a, Urban annual runoff (ac-ft)
	do i = 1, num
	  do j = 1, 9
	    VUrbanRunoff(j,i) = UrbanRunoff(j,i) / 12 * UrbanArea(j,i)
!     &					    UrbanArea(j,i) * RDays(i) * RDaysF
	  enddo
	enddo


	! Table 6, Runoff reduction by land uses (ac-ft)(for irrigation reduction in cropland)
	do i = 1, num
	  RdcIrRunoff(1,i) = IrRunoff(3,i) / 12 *
     &				Irrigation(2,i) * Irrigation(5,i)
	  RdcIrRunoff(2,i) = RdcIrRunoff(1,i)
	enddo	


!	do i = 1, num
!	  write(*,*) RdcIrRunoff(1,i)
!	enddo
!	write(*,*) '----------'

!	do i = 1, num
!	  write(*,*) VRunoff(6,i)
!	  do j = 1, 9
!	    write(*,*) VUrbanRunoff(j,i)
!	  enddo
!	enddo
!	write(*,*) '----'
!	do i = 1, num
!	  do j = 1, 6
!	    write(*,*) GW4(j,i)
!	  enddo
!	enddo



	RETURN
	END	! LandRain



!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE FEEDLOTS
	use parm
	REAL PrvAreaF

	! Table 1, Select a range of paved percentage for feedlots
	do i = 1, num
	  Feedlots_1(1,i) = LuseAreaWS (6,i)
	  Feedlots_1(2,i) = PctFeedlot(i)
!	  Feedlots_1(3,i) = AvgR(i)
	  Feedlots_1(4,i) = BMPeff_FL(1,i)
	  Feedlots_1(5,i) = BMPeff_FL(2,i)
	  Feedlots_1(6,i) = BMPeff_FL(3,i)
	  if ( Feedlots_1(2,i) < 25 ) then
	    PrvAreaF = 0.125
	    Feedlots_4(i,1) = feCN(1)
	  elseif ( 25 <= Feedlots_1(2,i) .and. Feedlots_1(2,i) < 50 ) then
	    PrvAreaF = 0.375
	    Feedlots_4(i,1) = feCN(2)
	  elseif ( 50 <= Feedlots_1(2,i) .and. Feedlots_1(2,i) < 75 ) then
	    PrvAreaF = 0.625
	    Feedlots_4(i,1) = feCN(3)
	  else
	    PrvAreaF = 0.875
	    Feedlots_4(i,1) = feCN(4)
	  endif
	  Feedlots_1(7,i) = Feedlots_1(1,i) * PrvAreaF
!	  GW4(6,i) = (GW3(1,i)/12) * RDays(i) * RDaysF * Feedlots_1(7,i) 
	  GW4(6,i) = (GW3(1,i)/12) * Feedlots_1(7,i)
	enddo

	! Table 2, Agricultural animals
	do i = 1, num
	  do j = 1, 11
	    Feedlots_2(j,i) = 0
	  enddo
	  Feedlots_2(1,i) = Animals(1,i)
	  Feedlots_2(3,i) = Animals(2,i)
	  Feedlots_2(5,i) = Animals(3,i)
	  Feedlots_2(7,i) = Animals(4,i)
	  Feedlots_2(8,i) = Animals(5,i)
	  Feedlots_2(9,i) = Animals(6,i)
	  Feedlots_2(10,i) = Animals(7,i)
	  Feedlots_2(11,i) = Animals(8,i)
	enddo

	! Table 5, Ratio of nutrients produced by animals relative to 1000 lb of slaughter steer
	open(6, file='Feedlot.txt', status='old')
	  read(6,*)
	  do i = 1, 11
	    read(6,*) (Feedlots_5(j,i),j=1,4)
	  enddo
	close(6)


	! Table 4, Feedlot load calculation
	do i = 1, num
	  ! Feedlots_4(i,1) was calculated at Table 1
	  Feedlots_4(i,2) = 1000 / Feedlots_4(i,1) - 10
	  if ( PctFeedlot(i) < 25 ) then
	    Feedlots_4(i,3) = feDepth(1)
	  elseif ( 25 <= PctFeedlot(i) .and. PctFeedlot(i) < 50 ) then
	    Feedlots_4(i,3) = feDepth(2)
	  elseif ( 50 <= PctFeedlot(i) .and. PctFeedlot(i) < 75 ) then
	    Feedlots_4(i,3) = feDepth(3)
	  else
	    Feedlots_4(i,3) = feDepth(4)
	  end if
	  Feedlots_4(i,4) = Feedlots_4(i,3) * Feedlots_1(1,i)
	  Feedlots_4(i,5) = 0.0
	  do j = 1, 11
	    Feedlots_4(i,5) = Feedlots_4(i,5) + 
     &					  Feedlots_2(j,i) * Feedlots_5(1,j) 
	  enddo
	  Feedlots_4(i,6) = 0.0
	  do j = 1, 11
	    Feedlots_4(i,6) = Feedlots_4(i,6) + 
     &					  Feedlots_2(j,i) * Feedlots_5(2,j) 
	  enddo
	  Feedlots_4(i,7) = 0.0
	  do j = 1, 11
	    Feedlots_4(i,7) = Feedlots_4(i,7) + 
     &					  Feedlots_2(j,i) * Feedlots_5(3,j) 
	  enddo
	  Feedlots_4(i,8) = 0.0
	  do j = 1, 11
	    Feedlots_4(i,8) = Feedlots_4(i,8) + 
     &					  Feedlots_2(j,i) * Feedlots_5(4,j) 
	  enddo
	  if ( 0 < Feedlots_1(1,i) ) then
	    Feedlots_4(i,9) = Feedlots_4(i,5) / Feedlots_1(1,i)
	    Feedlots_4(i,10) = Feedlots_4(i,6) / Feedlots_1(1,i)
	    Feedlots_4(i,11) = Feedlots_4(i,7) / Feedlots_1(1,i)
	    Feedlots_4(i,12) = Feedlots_4(i,8) / Feedlots_1(1,i)
	  else
	    Feedlots_4(i,9) = 0.0
	    Feedlots_4(i,10) = 0.0
	    Feedlots_4(i,11) = 0.0
	    Feedlots_4(i,12) = 0.0
	  endif
	  Feedlots_4(i,13) = min(Feedlots_4(i,9),100.0) / 100
	  Feedlots_4(i,14) = min(Feedlots_4(i,10),100.0) / 100
	  Feedlots_4(i,15) = min(Feedlots_4(i,11),100.0) / 100
	  Feedlots_4(i,16) = min(Feedlots_4(i,12),100.0) / 100
	  Feedlots_4(i,17) = Feedlots_4(i,13) * 1500
	  Feedlots_4(i,18) = Feedlots_4(i,14) * 300
	  Feedlots_4(i,19) = Feedlots_4(i,15) * 2000
	  Feedlots_4(i,20) = Feedlots_4(i,16) * 4500
	enddo

	! Table 3, Load from feedlot (lb/yr) (1 ac x in x mg/l = 0.227 lb)
	! Load_Fdl(6,30)
	do i = 1, num
	  if ( 0 < Feedlots_1(1,i) ) then
	    Load_Fdl(1,i) = Feedlots_4(i,4) * Feedlots_4(i,17) * 0.227
	    Load_Fdl(2,i) = Feedlots_4(i,4) * Feedlots_4(i,18) * 0.227
	    Load_Fdl(3,i) = Feedlots_4(i,4) * Feedlots_4(i,19) * 0.227
	    Load_Fdl(4,i) = Load_Fdl(1,i) * Feedlots_1(4,i)
	    Load_Fdl(5,i) = Load_Fdl(2,i) * Feedlots_1(5,i)
	    Load_Fdl(6,i) = Load_Fdl(3,i) * Feedlots_1(6,i)
	  else
	    Load_Fdl(1,i) = 0.0
	    Load_Fdl(2,i) = 0.0
	    Load_Fdl(3,i) = 0.0
	    Load_Fdl(4,i) = 0.0
	    Load_Fdl(5,i) = 0.0
	    Load_Fdl(6,i) = 0.0
	  endif
	enddo


!	do i = 1, num
!	  write(*,*) (Load_Fdl(j,i),j=1,6)
!	enddo

	RETURN
	END

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE BMPS
	use parm

	open(3,file='BMPs.txt',status='old')
	  read(3,*)
	  do i = 1, num
	    read(3,*) (BMPeff_C(j,i),j=1,5)
	  enddo
	  read(3,*)
	  read(3,*)
	  do i = 1, num
	    read(3,*) (BMPeff_P(j,i),j=1,5)
	  enddo
	  read(3,*)
	  read(3,*)
	  do i = 1, num
	    read(3,*) (BMPeff_F(j,i),j=1,5)
	  enddo
	  read(3,*)
	  read(3,*)
	  do i = 1, num
	    read(3,*) (BMPeff_U(j,i),j=1,5)
	  enddo
	  read(3,*)
	  read(3,*)
	  do i = 1, num
	    read(3,*) (BMPeff_FL(j,i),j=1,5)
	  enddo

	close(3)

	

!	do i = 1, num
!	  write(*,*) (BMPeff_F(j,i),j=1,5)
!	enddo
	
	RETURN
	END

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE ANIMAL
	use parm
	
	open(4, file='Reference.txt',status='old')
	  read(4,*)
	  do i = 1, 13
	    read(4,*) (Ref(j,i),j=1,4)
	  enddo	
	close(4)	

	! Table 1, Agricultural animals
	do i = 1, num
	  if ( 0 < LuseAreaWS(2,i) ) then
	    AEU(i) = (Animals(1,i) * Ref(1,1) + Animals(2,i) * Ref(1,2) +
     &			  Animals(3,i) * Ref(1,3) + Animals(4,i) * Ref(1,4) +
     &			  Animals(5,i) * Ref(1,5) + Animals(6,i) * Ref(1,6) +
     &			  Animals(7,i) * Ref(1,7) + Animals(8,i) * Ref(1,8) )/
     &			  1000 / LuseAreaWS(2,i)
	  else
	    AEU(i) = 0.0
	  endif
	enddo

	! Table 2, Wildlife density in cropland
	open(5, file='WildLife.txt',status='old')
	  do i = 1, 5
	    read(5,*) WildLifeD(1,i)
	    WildLifeD(2,i) = WildLifeD(1,i) / 640
	  enddo
	close(5)

	! Table 3, Estimated wildlife and AEU in watersheds
	do i = 1, num
	  do j = 1, 5
	    AEUwl(j,i) = LuseAreaWS(2,i) * WildLifeD(2,j)
	  enddo
	  if ( 0 < LuseAreaWS(2,i) ) then
	    AEUwl(6,i) = (AEUwl(1,i) * Ref(1,9) + AEUwl(2,i) * Ref(1,10) + 
     &				 AEUwl(3,i) * Ref(1,11) + AEUwl(4,i) * Ref(1,12) + 
     &				 AEUwl(5,i) * Ref(1,13) ) / 1000 /  LuseAreaWS(2,i)
	  else
	    AEUwl(6,i) = 0.0
	  endif
	enddo

	! Table 4, Total animal equivalent units and nutrient concentrations 
	do i = 1, num
	  AnimalPNB(1,i) = AEU(i) + AEUwl(6,i)
	  if ( AnimalPNB(1,i) <= 1.5 ) then
	    AnimalPNB(2,i) = NtConcRunoff(1,1)
	    AnimalPNB(3,i) = NtConcRunoff(1,2)
	    AnimalPNB(4,i) = NtConcRunoff(2,1)
	    AnimalPNB(5,i) = NtConcRunoff(2,2)
	    AnimalPNB(6,i) = NtConcRunoff(3,1)
	    AnimalPNB(7,i) = NtConcRunoff(3,2)
	  elseif ( 1.5 < AnimalPNB(1,i) .and. AnimalPNB(1,i) < 2.5 ) then
	    AnimalPNB(2,i) = NtConcRunoff(1,3)
	    AnimalPNB(3,i) = NtConcRunoff(1,4)
	    AnimalPNB(4,i) = NtConcRunoff(2,3)
	    AnimalPNB(5,i) = NtConcRunoff(2,4)
	    AnimalPNB(6,i) = NtConcRunoff(3,3)
	    AnimalPNB(7,i) = NtConcRunoff(3,4)
	  else
	    AnimalPNB(2,i) = NtConcRunoff(1,5)
	    AnimalPNB(3,i) = NtConcRunoff(1,6)
	    AnimalPNB(4,i) = NtConcRunoff(2,5)
	    AnimalPNB(5,i) = NtConcRunoff(2,6)
	    AnimalPNB(6,i) = NtConcRunoff(3,5)
	    AnimalPNB(7,i) = NtConcRunoff(3,6)
	  endif 

	enddo

!	do i = 1, num
!	  write(*,*) (AnimalPNB(j,i),j=1,5)
!	enddo
!	do i = 1, num
!	  write(*,*) (AnimalPNB(j+5,i),j=1,2)
!	enddo

	RETURN
	END

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE SEPTIC
	use parm

	! A table between Table 1 and 2
	open(7, file='Septic.txt', status='old')
	  do i = 1, 8
	    read(7,*) SpDB(i)
	  enddo
	close(7)
	
	! Table 1, Nutrient load from septic systems
	do i = 1, num
	  Septic_1(1,i) = NumSpSys(i)
	  Septic_1(2,i) = PpSpSys(i)
	  Septic_1(3,i) = SpFailRate(i)
	  Septic_1(4,i) = Septic_1(1,i) * Septic_1(3,i) / 100
	  Septic_1(5,i) = Septic_1(1,i) * Septic_1(2,i) *Septic_1(3,i)/100
	  Septic_1(6,i) = NumPpDrtDc(i)
	  Septic_1(7,i) = Septic_1(5,i) * SpDB(4)
	  Septic_1(8,i) = Septic_1(6,i) * SpDB(8)
	  Septic_1(9,i) = Septic_1(7,i) * 3.785412 / 24
	  Septic_1(10,i) = Septic_1(8,i) * 3.785412/24
	  Septic_1(11,i) = (Septic_1(9,i) * SpDB(1) + 
     &	                Septic_1(10,i) * SpDB(5)) / 453592.4
	  Septic_1(12,i) = (Septic_1(9,i) * SpDB(2) + 
     &	                Septic_1(10,i) * SpDB(6)) / 453592.4
	  Septic_1(13,i) = (Septic_1(9,i) * SpDB(3) + 
     &	                Septic_1(10,i) * SpDB(7)) / 453592.4
	  Septic_1(14,i) = RdcDrtDc(i) * Septic_1(10,i) / 100
	  Septic_1(15,i) = SpDB(5) * Septic_1(14,i) / 453592.4
	  Septic_1(16,i) = SpDB(6) * Septic_1(14,i) / 453592.4
	  Septic_1(17,i) = SpDB(7) * Septic_1(14,i) / 453592.4
	enddo

	! Table 2, Septic nutrient load in lb/yr	
	do i = 1, num
	  SepticPNB(1,i) = Septic_1(11,i) * 24 * 365
	  SepticPNB(2,i) = Septic_1(12,i) * 24 * 365
	  SepticPNB(3,i) = Septic_1(13,i) * 24 * 365
	  SepticPNB(4,i) = Septic_1(15,i) * 24 * 365
	  SepticPNB(5,i) = Septic_1(16,i) * 24 * 365
	  SepticPNB(6,i) = Septic_1(17,i) * 24 * 365
	  SepticPNB(7,i) = SepticPNB(1,i) - SepticPNB(4,i)
	  SepticPNB(8,i) = SepticPNB(2,i) - SepticPNB(5,i)
	  SepticPNB(9,i) = SepticPNB(3,i) - SepticPNB(6,i)
	enddo



!	do i = 1, num
!	  write(*,*) (SepticPNB(j,i),j=1,5)
!	enddo
!	write(*,*) '-------------------------'
!	do i = 1, num
!	  write(*,*) (SepticPNB(j,i),j=6,9)
!	enddo


	RETURN
	END
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE SEDIMENT
	use parm
	
	! Table 1, Input USLE parameters
	do i = 1, num
	  do j = 1, 5
	    Sed_1(j,i) = usleCropland(j,i)
	    Sed_1(j+5,i) = uslePasture(j,i)
	    Sed_1(j+10,i) = usleForest(j,i)
	    Sed_1(j+15,i) = usleUser(j,i)
	  enddo
	  Sed_1(22,i) = 0
	  if ( swsOpt < 2 ) then
	    do j = 1, 6
	      do k = 1, num
	        Sed_1(22,i) = Sed_1(22,i) + LuseAreaWS(j,k)
	      enddo
	    enddo	    
	  else
	    do j = 1, 6
	        Sed_1(22,i) = Sed_1(22,i) + LuseAreaWS(j,i)
	    enddo
	  endif
	  if ( Sed_1(22,i) <= 0 ) then
	    Sed_1(21,i) = 0
	  elseif ( 200 < Sed_1(22,i) ) then
	    Sed_1(21,i) = 0.417662*(Sed_1(22,i)/640)**(-0.134958)-0.127097
	    Sed_1(21,i) = Sed_1(21,i) * DREC(1)
	  else 
		Sed_1(21,i) = 0.42*(Sed_1(22,i)/640)**(-0.125)
	    Sed_1(21,i) = Sed_1(21,i) * DREC(1)
	  endif
	enddo

	! Table 1a, BMP and efficiency, C=Cropland, P=Pastureland,F=Forest,U=Urban
	do i = 1, num
	  Sed_1a(1,i) = BMPeff_C(4,i)
	  Sed_1a(2,i) = BMPeff_P(4,i)
	  Sed_1a(3,i) = BMPeff_F(4,i)
	  Sed_1a(4,i) = BMPeff_U(4,i)
	  Sed_1a(5,i) = BMPeff_C(1,i)
	  Sed_1a(6,i) = BMPeff_P(1,i)
	  Sed_1a(7,i) = BMPeff_F(1,i)
	  Sed_1a(8,i) = BMPeff_U(1,i)
	  Sed_1a(9,i) = BMPeff_C(2,i)
	  Sed_1a(10,i) = BMPeff_P(2,i)
	  Sed_1a(11,i) = BMPeff_F(2,i)
	  Sed_1a(12,i) = BMPeff_U(2,i)
	  Sed_1a(13,i) = BMPeff_C(3,i)
	  Sed_1a(14,i) = BMPeff_P(3,i)
	  Sed_1a(15,i) = BMPeff_F(3,i)
	  Sed_1a(16,i) = BMPeff_U(3,i)
	enddo

	! Table 2, Erosion and sediment delivery (ton/year)
	do i = 1, num
	  do j = 1, 4
	    Sed_2(j,i) = Sed_1(5*j-4,i) * Sed_1(5*j-3,i) * Sed_1(5*j-2,i)*
     &		  	     Sed_1(5*j-1,i) * Sed_1(5*j,i)
	  enddo
	  Sed_2(1,i) = Sed_2(1,i) * LuseAreaWS(2,i)
	  Sed_2(2,i) = Sed_2(2,i) * LuseAreaWS(3,i)
	  Sed_2(3,i) = Sed_2(3,i) * LuseAreaWS(4,i)
	  Sed_2(4,i) = Sed_2(4,i) * LuseAreaWS(5,i)
	  Sed_2(5,i) = 0.0
	  do j = 1, 4
	    Sed_2(5,i) = Sed_2(5,i) + Sed_2(j,i)
	  enddo
	  Sed_2(6,i) = Sed_2(5,i) * Sed_1(21,i)
	  ! Sed_2(7,i) , Sed_2(8,i) are calculated after Table 2a.
	enddo

	! Table 2a, Erosion and sediment delivery after BMP (ton/year)
	do i = 1, num
	  Sed_2a(5,i) = 0.0
	  do j = 1, 4
	    Sed_2a(j,i) = Sed_2(j,i) * (1-Sed_1a(j,i))
	    Sed_2a(5,i) = Sed_2a(5,i) + Sed_2a(j,i)
	    Sed_2a(6,i) = Sed_2a(5,i) * Sed_1(21,i)
	  enddo
	  Sed_2(7,i) = Sed_2(6,i) - Sed_2a(6,i)				! Table 2
	  if ( Sed_2(6,i) <= 0.0 ) then
	    Sed_2(8,i) = 0.0
	   else
	    Sed_2(8,i) = Sed_2(7,i) / Sed_2(6,i) * 100
	  endif
	enddo

	! Table 3, Nutrient load from sediment (ton/year)
	do i = 1, num
	  Sed_3(1,i) = SoilNconc(i)
	  Sed_3(2,i) = SoilPconc(i)
	  Sed_3(3,i) = SoilBODconc(i)
	  Sed_3(4,i) = Sed_3(1,i) * Sed_2(6,i) * 2 / 100
	  Sed_3(5,i) = Sed_3(2,i) * Sed_2(6,i) * 2 / 100
	  Sed_3(6,i) = Sed_3(3,i) * Sed_2(6,i) * 2 / 100
	  Sed_3(7,i) = Sed_3(4,i) * Sed_2(8,i) / 100
	  Sed_3(8,i) = Sed_3(5,i) * Sed_2(8,i) / 100
	  Sed_3(9,i) = Sed_3(6,i) * Sed_2(8,i) / 100
	enddo

	! Table 3a, Sediment and sediment nutrients by land uses with BMP (ton/year)
		! Sed_3a(16,30)
	do i = 1, num
	  Sed_3a(4,i) = Sed_1(21,i) * Sed_2(1,i) * (1-Sed_1a(1,i)) 
	  Sed_3a(8,i) = Sed_1(21,i) * Sed_2(2,i) * (1-Sed_1a(2,i))
	  Sed_3a(12,i) = Sed_1(21,i) * Sed_2(3,i) * (1-Sed_1a(3,i))
	  Sed_3a(16,i) = Sed_1(21,i) * Sed_2(4,i) * (1-Sed_1a(4,i))

	  do j = 1, 3
	    Sed_3a(j,i) = Sed_3a(4,i) * Sed_3(j,i) * 2 / 100
	    Sed_3a(j+4,i) = Sed_3a(8,i) * Sed_3(j,i) * 2 / 100
	    Sed_3a(j+8,i) = Sed_3a(12,i) * Sed_3(j,i) * 2 / 100
	    Sed_3a(j+12,i) = Sed_3a(16,i) * Sed_3(j,i) * 2 / 100
	  enddo
	enddo




!	do i = 1, num
!	  write(*,*) (Sed_3a(j,i),j=1,5)
!	enddo
!	write(*,*) '--------------------------'
!	do i = 1, num
!	  write(*,*) (Sed_3a(j,i),j=6,10)
!	enddo
!	write(*,*) '--------------------------'
!	do i = 1, num
!	  write(*,*) (Sed_3a(j,i),j=11,15)
!	enddo
!	write(*,*) '--------------------------'
!	do i = 1, num
!	  write(*,*) Sed_3a(16,i)
!	enddo



	RETURN
	END

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE URBAN
	use parm

	! Table 1, 2a, 3.2a, 3.3a, 3.4a, 3.5a
	open(8, file='BMPs.txt', status='old')
	  do i = 1, num * 5 + 9
	    read(8,*)
	  enddo
	  read(8,*)
	  
	  do i = 1, 4
	    read(8,*) (ub1(j,i),j=1,9)
	  enddo
	  read(8,*)

	  do i = 1, num
	    read(8,*) (ub2a(j,i),j=1,9)
	  enddo
	  read(8,*)

	  do i = 1, num
	    read(8,*) (ub32a(j,i),j=1,9)
	  enddo
	  read(8,*)
	  	
	  do i = 1, num
	    read(8,*) (ub33a(j,i),j=1,9)
	  enddo
	  read(8,*)

	  do i = 1, num
	    read(8,*) (ub34a(j,i),j=1,9)
	  enddo
	  read(8,*)

	  do i = 1, num
	    read(8,*) (ub35a(j,i),j=1,9)
	  enddo
	close(8)	

	! Table 2, Urban landuse distribution
		! UrbanArea(j,i) : j(1-9) are each area (ac).	

	! Table 3a, Percentage of BMP effective area (%)
	do i = 1, num
	  do j = 1, 9
	    if ( 0 < UrbanArea(j,i) ) then
	      ub3a(j,i) = ub2a(j,i) / UrbanArea(j,i) * 100
	    else
	      ub3a(j,i) = 0.0
	    endif
	  enddo
	enddo

	! Table 3.1,Urban runoff (ac-ft)
		! = VUrbanRunoff(j,i)

	! Table 3.2, 3.3, 3.4, 3.5
	do i = 1, num
	  do j = 1, 9
	    ub32(j,i) = 4047 * 0.3048 * VUrbanRunoff(j,i) * ub1(j,1)/1000
	    ub33(j,i) = 4047 * 0.3048 * VUrbanRunoff(j,i) * ub1(j,2)/1000
	    ub34(j,i) = 4047 * 0.3048 * VUrbanRunoff(j,i) * ub1(j,3)/1000
	    ub35(j,i) = 4047 * 0.3048 * VUrbanRunoff(j,i) * ub1(j,4)/1000
	  enddo
	enddo

	! Table 3.2b, 3.3b, 3.4b, 3.5b
	do i = 1, num
	  do j = 1, 9
	    ub32b(j,i) = ub32a(j,i) * ub32(j,i) * ub3a(j,i) / 100
	    ub33b(j,i) = ub33a(j,i) * ub33(j,i) * ub3a(j,i) / 100
	    ub34b(j,i) = ub34a(j,i) * ub34(j,i) * ub3a(j,i) / 100
	    ub35b(j,i) = ub35a(j,i) * ub35(j,i) * ub3a(j,i) / 100
	  enddo
	enddo

	! Table 4, Pollutant loads from urban in lb/year
	do i = 1, num
	  do j = 1, 12
	    ub4(j,i) = 0.0
	  enddo
	enddo

	do i = 1, num
	  do j = 1, 9
	    ub4(1,i) = ub4(1,i) + ub32(j,i)
	    ub4(2,i) = ub4(2,i) + ub33(j,i)
	    ub4(3,i) = ub4(3,i) + ub34(j,i)
	    ub4(4,i) = ub4(4,i) + ub35(j,i)
	    ub4(5,i) = ub4(5,i) + ub32b(j,i)
	    ub4(6,i) = ub4(6,i) + ub33b(j,i)
	    ub4(7,i) = ub4(7,i) + ub34b(j,i)
	    ub4(8,i) = ub4(8,i) + ub35b(j,i)
	  enddo
	  do j = 1, 8
	    ub4(j,i) = ub4(j,i) * 2.203 * Sed_1(21,i)
  	    ! Urban sediment * sediment delivery ratio
	  enddo
	  do j = 1, 4
	    ub4(j+8,i) = ub4(j,i) - ub4(j+4,i)
	  enddo

	enddo


!	do i = 1, num
!	  write(*,*) (ub4(j,i),j=1,5)
!	enddo
!	write(*,*) '--------------------'
!	do i = 1, num
!	  write(*,*) (ub4(j,i),j=6,10)
!	enddo
!	write(*,*) '--------------------'
!	do i = 1, num
!	  write(*,*) (ub4(j,i),j=11,12)
!	enddo
!	write(*,*) '--------------------'

	RETURN
	END

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE GULLY
	use parm

	open(9, file='Gully.txt', status='old')
	  do i = 1, 10
	    read(9,*) GSDB1(1,i), GSDB1(2,i)
	  enddo
	  read(9,*)
	  do i = 1, 4
	    read(9,*) GSDB2(i)
	  enddo
	  read(9,*)
	  read(9,*) numGully
	  do i = 1, numGully
	    read(9,*) GS1t(i), (GS1(j,i),j=1,7), GS1_soil(i)
	  enddo
	  read(9,*)

	  read(9,*) numStr
	  do i = 1, numStr
	    read(9,*) GS2t(i), (GS2(j,i),j=1,3), GS2_LtRc(i), GS2(6,i),
     &			  GS2_soil(i)
	  enddo
	close(9)
	
	! Table 1, Gully dimensions in the different watersheds
	do i = 1, numGully
	  GS1(8,i) = GSDB1(1,GS1_soil(i))
	  GS1(9,i) = GSDB1(2,GS1_soil(i))
	  if ( 0 < GS1(6,i) ) then
	    GS1(10,i) = (GS1(2,i) + GS1(3,i)) * GS1(4,i) * GS1(5,i) *
     &				GS1(8,i) / GS1(6,i) / 2
	  else 
	    GS1(10,i) = 0.0
	  endif
	  GS1(11,i) = GS1(7,i) * GS1(10,i)
	  if ( 0 < GS1(6,i) ) then
	    GS1(12,i) = (GS1(2,i) + GS1(3,i)) * GS1(4,i) * GS1(5,i) *
     &				GS1(8,i) * GS1(9,i) / GS1(6,i) / 2
	  else
	    GS1(12,i) = 0.0
	  endif
	  GS1(13,i) = GS1(7,i) * GS1(12,i)	
	enddo

	! Table 2, Impaired streambank dimensions in the different watersheds
	do i = 1, numStr
	  GS2(4,i) = GSDB2(GS2_LtRc(i))
	  GS2(5,i) = GSDB2(GS2_LtRc(i))
	  GS2(7,i) = GSDB1(1,GS2_soil(i))
	  GS2(8,i) = GSDB1(2,GS2_soil(i))
	  GS2(9,i) = GS2(2,i) * GS2(3,i) * GS2(5,i) * GS2(7,i)
	  GS2(10,i) = GS2(6,i) * GS2(9,i)
	  GS2(11,i) = GS2(2,i) * GS2(3,i) * GS2(5,i) *
     &			  GS2(7,i) * GS2(8,i)
	  GS2(12,i) = GS2(6,i) * GS2(11,i)
	enddo

	! Table 3, Load and load reduction (lb/year, GU=Gully; SB=Streambank) in the different watersheds
	do i = 1, 30
	  do j = 1, 20
	    GS3(j,i) = 0.0
	  enddo
	enddo
	do i = 1, numGully
	  GS3(4,GS1t(i)) = GS3(4,GS1t(i)) + GS1(10,i)
	  GS3(8,GS1t(i)) = GS3(8,GS1t(i)) + GS1(11,i)
	  GS3(17,GS1t(i)) = GS3(17,GS1t(i)) + GS1(12,i)
	  GS3(18,GS1t(i)) = GS3(18,GS1t(i)) + GS1(13,i)
	enddo
	do i = 1, numStr
	  GS3(12,GS2t(i)) = GS3(12,GS2t(i)) + GS2(9,i)
	  GS3(16,GS2t(i)) = GS3(16,GS2t(i)) + GS2(10,i)
	  GS3(19,GS2t(i)) = GS3(19,GS2t(i)) + GS2(11,i)
	  GS3(20,GS2t(i)) = GS3(20,GS2t(i)) + GS2(12,i)
	enddo	
	do i = 1, num
	  GS3(4,i) = GS3(4,i) * 2000
	  GS3(8,i) = GS3(8,i) * 2000
	  GS3(12,i) = GS3(12,i) * 2000
	  GS3(16,i) = GS3(16,i) * 2000
	  GS3(17,i) = GS3(17,i) * 2000
	  GS3(18,i) = GS3(18,i) * 2000
	  GS3(19,i) = GS3(19,i) * 2000
	  GS3(20,i) = GS3(20,i) * 2000
	  
	  GS3(1,i) = GS3(17,i) * SoilNconc(i) / 100
	  GS3(2,i) = GS3(17,i) * SoilPconc(i) / 100
	  GS3(3,i) = GS3(17,i) * SoilBODconc(i) / 100
	  GS3(5,i) = GS3(18,i) * SoilNconc(i) / 100
	  GS3(6,i) = GS3(18,i) * SoilPconc(i) / 100
	  GS3(7,i) = GS3(18,i) * SoilBODconc(i) / 100
	  GS3(9,i) = GS3(19,i) * SoilNconc(i) / 100
	  GS3(10,i) = GS3(19,i) * SoilPconc(i) / 100
	  GS3(11,i) = GS3(19,i) * SoilBODconc(i) / 100
	  GS3(13,i) = GS3(20,i) * SoilNconc(i) / 100
	  GS3(14,i) = GS3(20,i) * SoilPconc(i) / 100
	  GS3(15,i) = GS3(20,i) * SoilBODconc(i) / 100
	enddo
	! SoilNconc(i), SoilPconc(i), SoilBODconc(i)



!	do i = 1, num
!	  write(*,*) (GS3(j,i),j=1,5)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, num
!	  write(*,*) (GS3(j,i),j=6,10)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, num
!	  write(*,*) (GS3(j,i),j=11,15)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, num
!	  write(*,*) (GS3(j,i),j=16,20)
!	enddo
!	write(*,*) '----------------------------------'


!	do i = 1, numGully
!	  write(*,*) GS1t(i), (GS1(j,i),j=1,4)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, numGully
!	  write(*,*) (GS1(j,i),j=5,7), GS1_soil(i), GS1(8,i)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, numGully
!	  write(*,*) (GS1(j,i),j=9,13)
!	enddo
!	write(*,*) '-----------------------------------------------'
!	write(*,*) '-----------------------------------------------'
!	write(*,*) '-----------------------------------------------'
!	write(*,*) '-----------------------------------------------'
!	do i = 1, numStr
!	  write(*,*) GS2t(i), (GS2(j,i),j=1,3), GS2_LtRc(i)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, numStr
!	  write(*,*) (GS2(j,i),j=4,6), GS2_soil(i), GS2(7,i)
!	enddo
!	write(*,*) '----------------------------------'
!	do i = 1, numStr
!	  write(*,*) (GS2(j,i),j=8,12)
!	enddo
!	write(*,*) '----------------------------------'


	RETURN
	END
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
	SUBROUTINE TOTALLOAD
	use parm

	! Table a, Nutrient load from runoff (lb/year) without BMPs
	do i = 1, 31
	  do j = 1, 15
	    TLa(j,i) = 0.0
	  enddo
	enddo
	do i = 1, num
	  TLa(1,i) = VRunoff(2,i) * (( 1 - NumMonManure(i) / 12.0 ) * 
     &	 AnimalPNB(2,i) + ( NumMonManure(i) / 12.0 ) * AnimalPNB(3,i))
     &	 * 4047 * 0.3048 / 454
	  TLa(2,i) = VRunoff(2,i) * (( 1 - NumMonManure(i) / 12.0 ) * 
     &	 AnimalPNB(4,i) + ( NumMonManure(i) / 12.0 ) * AnimalPNB(5,i))
     &	 * 4047 * 0.3048 / 454
	  TLa(3,i) = VRunoff(2,i) * (( 1 - NumMonManure(i) / 12.0 ) * 
     &	 AnimalPNB(6,i) + ( NumMonManure(i) / 12.0 ) * AnimalPNB(7,i))
     &	 * 4047 * 0.3048 / 454
	  TLa(4,i) = VRunoff(3,i) * NtConcRunoff(1,7)*4047*0.3048/454
	  TLa(5,i) = VRunoff(3,i) * NtConcRunoff(2,7)*4047*0.3048/454
	  TLa(6,i) = VRunoff(3,i) * NtConcRunoff(3,7)*4047*0.3048/454
	  TLa(7,i) = VRunoff(4,i) * NtConcRunoff(1,8)*4047*0.3048/454
	  TLa(8,i) = VRunoff(4,i) * NtConcRunoff(2,8)*4047*0.3048/454
	  TLa(9,i) = VRunoff(4,i) * NtConcRunoff(3,8)*4047*0.3048/454
	  TLa(10,i) = VRunoff(5,i) * NtConcRunoff(1,9)*4047*0.3048/454
	  TLa(11,i) = VRunoff(5,i) * NtConcRunoff(2,9)*4047*0.3048/454
	  TLa(12,i) = VRunoff(5,i) * NtConcRunoff(3,9)*4047*0.3048/454
	  TLa(13,i) = TLa(1,i) + TLa(4,i) + TLa(7,i) + TLa(10,i)
	  TLa(14,i) = TLa(2,i) + TLa(5,i) + TLa(8,i) + TLa(11,i)
	  TLa(15,i) = TLa(3,i) + TLa(6,i) + TLa(9,i) + TLa(12,i)	  
	  do j = 1, 15
	    TLa(j,31) = TLa(j,31) + TLa(j,i)
	  enddo
	enddo

	! Table b, Nutrient load reduction in runoff with BMPs (lb/year)
	do i = 1, 31
	  do j = 1, 15
	    TLb(j,i) = 0.0
	  enddo
	enddo
	do i = 1, num
	  TLb(1,i) = ( TLa(1,i) - RdcIrRunoff(1,i) * AnimalPNB(2,i) 
     &		* 4047 * 0.3048 / 454 ) * Sed_1a(5,i) +
     &		RdcIrRunoff(1,i) * AnimalPNB(2,i) * 4047 * 0.3048 / 454 
	  TLb(2,i) = ( TLa(2,i) - RdcIrRunoff(1,i) * AnimalPNB(4,i) 
     &		* 4047 * 0.3048 / 454 ) * Sed_1a(9,i) +
     &		RdcIrRunoff(1,i) * AnimalPNB(4,i) * 4047 * 0.3048 / 454 
    	  TLb(3,i) = ( TLa(3,i) - RdcIrRunoff(1,i) * AnimalPNB(6,i) 
     &		* 4047 * 0.3048 / 454 ) * Sed_1a(13,i) +
     &		RdcIrRunoff(1,i) * AnimalPNB(6,i) * 4047 * 0.3048 / 454
        TLb(4,i) = TLa(4,i) * Sed_1a(6,i)
	  TLb(5,i) = TLa(5,i) * Sed_1a(10,i)
	  TLb(6,i) = TLa(6,i) * Sed_1a(14,i)
	  TLb(7,i) = TLa(7,i) * Sed_1a(7,i)
	  TLb(8,i) = TLa(8,i) * Sed_1a(11,i)
	  TLb(9,i) = TLa(9,i) * Sed_1a(15,i)
	  TLb(10,i) = TLa(10,i) * Sed_1a(8,i)
	  TLb(11,i) = TLa(11,i) * Sed_1a(12,i)
	  TLb(12,i) = TLa(12,i) * Sed_1a(16,i)
	  TLb(13,i) = TLb(1,i) + TLb(4,i) + TLb(7,i) + TLb(10,i)
	  TLb(14,i) = TLb(2,i) + TLb(5,i) + TLb(8,i) + TLb(11,i)
	  TLb(15,i) = TLb(3,i) + TLb(6,i) + TLb(9,i) + TLb(12,i)	  
	  do j = 1, 15
	    TLb(j,31) = TLb(j,31) + TLb(j,i)
	  enddo
	enddo

	! Table c, Nutrient and sediment load by land uses with BMP (lb/year)
	do i = 1, 31
	  do j = 1, 36
	    TLc(j,i) = 0.0
	  enddo
	enddo
	do i = 1, num
	  TLc(1,i) = ub4(9,i)
	  TLc(2,i) = ub4(10,i)
	  TLc(3,i) = ub4(11,i)
	  TLc(4,i) = ub4(12,i)
	  TLc(5,i) = TLa(1,i) - TLb(1,i) + Sed_3a(1,i) * 2000
	  TLc(6,i) = TLa(2,i) - TLb(2,i) + Sed_3a(2,i) * 2000
	  TLc(7,i) = TLa(3,i) - TLb(3,i) + Sed_3a(3,i) * 2000
	  TLc(8,i) = Sed_3a(4,i) * 2000
	  TLc(9,i) = TLa(4,i) - TLb(4,i) + Sed_3a(5,i) * 2000
	  TLc(10,i) = TLa(5,i) - TLb(5,i) + Sed_3a(6,i) * 2000
	  TLc(11,i) = TLa(6,i) - TLb(6,i) + Sed_3a(7,i) * 2000
	  TLc(12,i) = Sed_3a(8,i) * 2000
	  TLc(13,i) = TLa(7,i) - TLb(7,i) + Sed_3a(9,i) * 2000
	  TLc(14,i) = TLa(8,i) - TLb(8,i) + Sed_3a(10,i) * 2000
	  TLc(15,i) = TLa(9,i) - TLb(9,i) + Sed_3a(11,i) * 2000
	  TLc(16,i) = Sed_3a(12,i) * 2000
	  TLc(17,i) = Load_Fdl(1,i) - Load_Fdl(4,i)
	  TLc(18,i) = Load_Fdl(2,i) - Load_Fdl(5,i)
	  TLc(19,i) = Load_Fdl(3,i) - Load_Fdl(6,i)
	  TLc(20,i) = 0.0
	  TLc(21,i) = TLa(10,i) - TLb(10,i) + Sed_3a(13,i) * 2000
	  TLc(22,i) = TLa(11,i) - TLb(11,i) + Sed_3a(14,i) * 2000
	  TLc(23,i) = TLa(12,i) - TLb(12,i) + Sed_3a(15,i) * 2000
	  TLc(24,i) = Sed_3a(16,i) * 2000
	  TLc(25,i) = SepticPNB(7,i)
	  TLc(26,i) = SepticPNB(8,i)
	  TLc(27,i) = SepticPNB(9,i)
	  TLc(28,i) = 0.0
	  TLc(29,i) = GS3(1,i) - GS3(5,i)
	  TLc(30,i) = GS3(2,i) - GS3(6,i)
	  TLc(31,i) = GS3(3,i) - GS3(7,i)
	  TLc(32,i) = GS3(4,i) - GS3(8,i)
	  TLc(33,i) = GS3(9,i) - GS3(13,i)
	  TLc(34,i) = GS3(10,i) - GS3(14,i)
	  TLc(35,i) = GS3(11,i) - GS3(15,i)
	  TLc(36,i) = GS3(12,i) - GS3(16,i)	 
	  do j = 1, 36
	    TLc(j,31) = TLc(j,31) + TLc(j,i)
	  enddo 
	enddo


	! Table d, Load from groundwater by land uses with BMP (lb/year)
	do i = 1, 31
	  do j = 1, 28
	    TLd(j,i) = 0.0
	  enddo
	enddo
	do i = 1, num
	  TLd(1,i) = GW4(1,i)*NtConcGW(1,1)*4047*0.3048/454*DREC(1)
	  TLd(2,i) = GW4(1,i)*NtConcGW(2,1)*4047*0.3048/454*DREC(1)
	  TLd(3,i) = GW4(1,i)*NtConcGW(3,1)*4047*0.3048/454*DREC(1)
	  TLd(4,i) = 0.0
	  TLd(5,i) = GW4(2,i) * NtConcGW(1,2) * 4047 * 0.3048 / 454
	  TLd(6,i) = GW4(2,i) * NtConcGW(2,2) * 4047 * 0.3048 / 454
	  TLd(7,i) = GW4(2,i) * NtConcGW(3,2) * 4047 * 0.3048 / 454
	  TLd(8,i) = 0.0
	  TLd(9,i) = GW4(3,i) * NtConcGW(1,3) * 4047 * 0.3048 / 454
	  TLd(10,i) = GW4(3,i) * NtConcGW(2,3) * 4047 * 0.3048 / 454
	  TLd(11,i) = GW4(3,i) * NtConcGW(3,3) * 4047 * 0.3048 / 454
	  TLd(12,i) = 0.0
	  TLd(13,i) = GW4(4,i) * NtConcGW(1,4) * 4047 * 0.3048 / 454
	  TLd(14,i) = GW4(4,i) * NtConcGW(2,4) * 4047 * 0.3048 / 454
	  TLd(15,i) = GW4(4,i) * NtConcGW(3,4) * 4047 * 0.3048 / 454
	  TLd(16,i) = 0.0
	  TLd(17,i) = GW4(6,i) * NtConcGW(1,5) * 4047 * 0.3048 / 454
	  TLd(18,i) = GW4(6,i) * NtConcGW(2,5) * 4047 * 0.3048 / 454
	  TLd(19,i) = GW4(6,i) * NtConcGW(3,5) * 4047 * 0.3048 / 454
	  TLd(20,i) = 0.0
	  TLd(21,i) = GW4(5,i) * NtConcGW(1,6) * 4047 * 0.3048 / 454
	  TLd(22,i) = GW4(5,i) * NtConcGW(2,6) * 4047 * 0.3048 / 454
	  TLd(23,i) = GW4(5,i) * NtConcGW(3,6) * 4047 * 0.3048 / 454
	  TLd(24,i) = 0.0	
	  TLd(25,i) = TLd(1,i) + TLd(5,i) + TLd(9,i) + 
     &			  TLd(13,i) + TLd(17,i) + TLd(21,i)
	  TLd(26,i) = TLd(2,i) + TLd(6,i) + TLd(10,i) + 
     &			  TLd(14,i) + TLd(18,i) + TLd(22,i)
	  TLd(27,i) = TLd(3,i) + TLd(7,i) + TLd(11,i) + 
     &			  TLd(15,i) + TLd(19,i) + TLd(23,i)
	  TLd(28,i) = TLd(4,i) + TLd(8,i) + TLd(12,i) + 
     &			  TLd(16,i) + TLd(20,i) + TLd(24,i)
	  do j = 1, 28
	    TLd(j,31) = TLd(j,31) + TLd(j,i)
	  enddo
	enddo
	

	! Table 1, Total load by subwatershed(s)
	do i = 1, 31
	  do j = 1, 16
	    TL1(j,i) = 0.0
	  enddo
	enddo
	do i = 1, num
	  TL1(1,i) = TLa(13,i) + Load_Fdl(1,i) + Sed_3(4,i) * 2000 +
     &	ub4(1,i) + SepticPNB(1,i) + TLd(25,i) + GS3(1,i) + GS3(9,i)
	  TL1(2,i) = TLa(14,i) + Load_Fdl(2,i) + Sed_3(5,i) * 2000 +
     &	ub4(2,i) + SepticPNB(2,i) + TLd(26,i) + GS3(2,i) + GS3(10,i)
	  TL1(3,i) = TLa(15,i) + Load_Fdl(3,i) + Sed_3(6,i) * 2000 +
     &	ub4(3,i) + SepticPNB(3,i) + TLd(27,i) + GS3(3,i) + GS3(11,i)
	  TL1(4,i) = Sed_2(6,i) + ub4(4,i) / 2000 + TLd(28,i) / 2000 +
     &			 GS3(4,i) / 2000 + GS3(12,i) / 2000
	  TL1(5,i) = TLb(13,i) + Sed_3(7,i) * 2000 + ub4(5,i) +
     &		Load_Fdl(4,i) + SepticPNB(4,i) + GS3(5,i) + GS3(13,i)
	  TL1(6,i) = TLb(14,i) + Sed_3(8,i) * 2000 + ub4(6,i) +
     &		Load_Fdl(5,i) + SepticPNB(5,i) + GS3(6,i) + GS3(14,i)
	  TL1(7,i) = TLb(15,i) + Sed_3(9,i) * 2000 + ub4(7,i) +
     &		Load_Fdl(6,i) + SepticPNB(6,i) + GS3(7,i) + GS3(15,i)
	  TL1(8,i) = Sed_2(7,i) + ub4(8,i) / 2000 + TLd(28,i) / 2000 +
     &			 GS3(8,i) / 2000 + GS3(16,i) / 2000
	  do j  = 1, 4
	    TL1(8+j,i) = TL1(j,i) - TL1(j+4,i)
	    if ( 0 < TL1(j,i) ) then
	      TL1(12+j,i) = TL1(j+4,i) / TL1(j,i) * 100
	    else
	      TL1(12+j,i) = 0.0
	    endif
	  enddo
	  do j = 1, 12
	    TL1(j,31) = TL1(j,31) + TL1(j,i)
	  enddo
	enddo
	do j = 1, 4
	  if ( 0 < TL1(j,31) ) then
	    TL1(12+j,31) = TL1(j+4,31) / TL1(j,31) * 100
	  else
	    TL1(12+j,31) = 0.0
	  endif
	enddo


	! Table 2, Total load by land uses (with BMP)
	do i = 1, 10
	  do j = 1, 4
	    TL2(j,i) = 0.0
	  enddo	  
	enddo
	do i = 1, 9
	  do j = 1, 3
	    TL2(j,i) = TLc(4*i+j-4,31)
	  enddo
	  TL2(4,i) = TLc(4*i,31) / 2000
	enddo
	do j = 1, 4
	  TL2(j,10) = TLd(24+j,31)
	enddo
	do i = 1, 10
	  do j = 1, 4
	    TL2(j,11) = TL2(j,11) + TL2(j,i)
	  enddo	  
	enddo


!	do i = 1, num
!	  write(*,*) (TL1(j,i),j=1,5)
!	enddo
!	write(*,*) (TL1(j,31),j=1,5)
!	write(*,*) '-----------------------------'
!	do i = 1, num
!	  write(*,*) (TL1(j,i),j=6,10)
!	enddo
!	write(*,*) (TL1(j,31),j=6,10)
!	write(*,*) '-----------------------------'
!	do i = 1, num
!	  write(*,*) (TL1(j,i),j=11,15)
!	enddo
!	write(*,*) (TL1(j,31),j=11,15)
!	write(*,*) '-----------------------------'
!	do i = 1, num
!	  write(*,*) TL1(16,i)
!	enddo
!	write(*,*) TL1(16,31)

	RETURN 
	END










