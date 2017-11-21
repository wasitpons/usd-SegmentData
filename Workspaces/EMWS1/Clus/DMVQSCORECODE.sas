*****************************************;
*** Begin Scoring Code from PROC DMVQ ***;
*****************************************;


*** Begin Class Look-up, Standardization, Replacement ;
drop _dm_bad; _dm_bad = 0;

*** Standardize MeanHHSz ;
drop T_MeanHHSz ;
if missing( MeanHHSz ) then T_MeanHHSz = .;
else T_MeanHHSz = (MeanHHSz - 2.58493223313137) * 2.58930470583859;

*** Standardize MedHHInc ;
drop T_MedHHInc ;
if missing( MedHHInc ) then T_MedHHInc = .;
else T_MedHHInc = (MedHHInc - 39536.2575318565) * 0.00006148543496;

*** Standardize RegDens ;
drop T_RegDens ;
if missing( RegDens ) then T_RegDens = .;
else T_RegDens = (RegDens - 50.4474561485497) * 0.0346774797578;

*** End Class Look-up, Standardization, Replacement ;


*** Omitted Cases;
if _dm_bad then do;
   _SEGMENT_ = .; Distance = .;
   goto CLUSvlex ;
end; *** omitted;

*** Compute Distances and Cluster Membership;
label _SEGMENT_ = 'Segment Id' ;
label Distance = 'Distance' ;
array CLUSvads [10] _temporary_;
drop _vqclus _vqmvar _vqnvar;
_vqmvar = 0;
do _vqclus = 1 to 10; CLUSvads [_vqclus] = 0; end;
if not missing( T_MeanHHSz ) then do;
   CLUSvads [1] + ( T_MeanHHSz - -0.92628764361133 )**2;
   CLUSvads [2] + ( T_MeanHHSz - 0.51697021838652 )**2;
   CLUSvads [3] + ( T_MeanHHSz - 0.63363036107304 )**2;
   CLUSvads [4] + ( T_MeanHHSz - 0.16171311215481 )**2;
   CLUSvads [5] + ( T_MeanHHSz - 1.88194921140887 )**2;
   CLUSvads [6] + ( T_MeanHHSz - 3.86599558463777 )**2;
   CLUSvads [7] + ( T_MeanHHSz - 0.1613050352395 )**2;
   CLUSvads [8] + ( T_MeanHHSz - 0.24422666571889 )**2;
   CLUSvads [9] + ( T_MeanHHSz - 10.6551643104474 )**2;
   CLUSvads [10] + ( T_MeanHHSz - -0.8303670737549 )**2;
end;
else _vqmvar + 1;
if not missing( T_MedHHInc ) then do;
   CLUSvads [1] + ( T_MedHHInc - -0.35338675733083 )**2;
   CLUSvads [2] + ( T_MedHHInc - 6.76688161787887 )**2;
   CLUSvads [3] + ( T_MedHHInc - 3.20630159469379 )**2;
   CLUSvads [4] + ( T_MedHHInc - -0.33540442977751 )**2;
   CLUSvads [5] + ( T_MedHHInc - -0.32191939518578 )**2;
   CLUSvads [6] + ( T_MedHHInc - -0.54413462259247 )**2;
   CLUSvads [7] + ( T_MedHHInc - 0.04249626400391 )**2;
   CLUSvads [8] + ( T_MedHHInc - 1.3629498396933 )**2;
   CLUSvads [9] + ( T_MedHHInc - -0.35310209328303 )**2;
   CLUSvads [10] + ( T_MedHHInc - -0.58720094334777 )**2;
end;
else _vqmvar + 1;
if not missing( T_RegDens ) then do;
   CLUSvads [1] + ( T_RegDens - 1.03130886971571 )**2;
   CLUSvads [2] + ( T_RegDens - 0.82490226965535 )**2;
   CLUSvads [3] + ( T_RegDens - 0.96061312093441 )**2;
   CLUSvads [4] + ( T_RegDens - -0.75469744791684 )**2;
   CLUSvads [5] + ( T_RegDens - 0.71471636802034 )**2;
   CLUSvads [6] + ( T_RegDens - -0.4479977487411 )**2;
   CLUSvads [7] + ( T_RegDens - 0.47693169691322 )**2;
   CLUSvads [8] + ( T_RegDens - 0.91840573758564 )**2;
   CLUSvads [9] + ( T_RegDens - -0.33454946530565 )**2;
   CLUSvads [10] + ( T_RegDens - -1.21279682245173 )**2;
end;
else _vqmvar + 1;
_vqnvar = 3 - _vqmvar;
if _vqnvar <= 1.0231815394945E-12 then do;
   _SEGMENT_ = .; Distance = .;
end;
else do;
   _SEGMENT_ = 1; Distance = CLUSvads [1];
   _vqfzdst = Distance * 0.99999999999988; drop _vqfzdst;
   do _vqclus = 2 to 10;
      if CLUSvads [_vqclus] < _vqfzdst then do;
         _SEGMENT_ = _vqclus; Distance = CLUSvads [_vqclus];
         _vqfzdst = Distance * 0.99999999999988;
      end;
   end;
   Distance = sqrt(Distance * (3 / _vqnvar));
end;
CLUSvlex :;

***************************************;
*** End Scoring Code from PROC DMVQ ***;
***************************************;
