*------------------------------------------------------------*;
* Assoc: Sorting Training Data;
*------------------------------------------------------------*;
proc sort data=EMWS1.Ids2_DATA(keep= SERVICE ACCOUNT) out=WORK.SORTEDTRAIN;
by ACCOUNT;
run;
*------------------------------------------------------------* ;
* EM: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    SERVICE(DESC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* EM: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;

%mend DMDBVar;
*------------------------------------------------------------*;
* EM: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.SORTEDTRAIN
dmdbcat=WORK.EM_DMDB
maxlevel = 100001
normlen= 256
out=WORK.EM_DMDB
;
id
ACCOUNT
;
class %DMDBClass;
target
SERVICE
;
run;
quit;
options nocleanup;
proc assoc dmdb dmdbcat=WORK.EM_DMDB out=EMWS1.Assoc_ASSOC data=WORK.EM_DMDB
pctsup = 5
items=4
;
customer
ACCOUNT
;
target
SERVICE
;
run;
quit;
proc rulegen in = EMWS1.Assoc_ASSOC out=EMWS1.Assoc_RULE minconf = 10
;
run;
quit;
*------------------------------------------------------------*;
* Assoc: Selecting rules;
*------------------------------------------------------------*;
proc sort data=EMWS1.Assoc_RULE;
by descending LIFT;
where SET_SIZE>1;
run;
data WORK.ASSOCSUBSET;
set EMWS1.Assoc_RULE(obs=181);
index=_N_;
label index = "%sysfunc(sasmsg(sashelp.dmine, rpt_ruleIndex_vlabel,  NOQUOTE))";
label _LHAND = "%sysfunc(sasmsg(sashelp.dmine, rpt_leftHandSide_vlabel,  NOQUOTE))";
label _RHAND = "%sysfunc(sasmsg(sashelp.dmine, rpt_rightHandSide_vlabel,  NOQUOTE))";
run;
