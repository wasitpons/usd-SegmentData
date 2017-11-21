*------------------------------------------------------------*;
* Assoc2: Sorting Training Data;
*------------------------------------------------------------*;
proc sort data=EMWS1.Ids2_DATA(keep=VISIT SERVICE ACCOUNT) out=WORK.SORTEDTRAIN;
by ACCOUNT VISIT;
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
    VISIT
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
var %DMDBVar;
target
SERVICE
;
run;
quit;
options nocleanup;
proc assoc dmdb dmdbcat=WORK.EM_DMDB out=EMWS1.Assoc2_ASSOC data=WORK.EM_DMDB
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
proc sequence data=WORK.EM_DMDB dmdbcat=WORK.EM_DMDB assoc=EMWS1.Assoc2_ASSOC out=EMWS1.Assoc2_SEQUENCE nitems = 3
pctsup = 2;
customer ACCOUNT;
target SERVICE;
visit VISIT
;
run;
quit;
*------------------------------------------------------------*;
* Assoc2: Selecting rules;
*------------------------------------------------------------*;
proc sort data=EMWS1.Assoc2_SEQUENCE;
by descending SUPPORT;
run;
data WORK.ASSOCSUBSET;
set EMWS1.Assoc2_SEQUENCE(obs=141);
index=_N_;
label index = "%sysfunc(sasmsg(sashelp.dmine, rpt_ruleIndex_vlabel,  NOQUOTE))";
label _LHAND = "%sysfunc(sasmsg(sashelp.dmine, rpt_leftHandSide_vlabel,  NOQUOTE))";
label _RHAND = "%sysfunc(sasmsg(sashelp.dmine, rpt_rightHandSide_vlabel,  NOQUOTE))";
run;
