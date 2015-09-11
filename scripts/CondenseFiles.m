%%written by Matt Mazloff for SOSE
clear all
close all

%%
addpath ~/ANALYSIS
%%
iters = 480:480:105120
JustMetas = 0;
for f =[ 59 60]
%DONE: 1 2 8 52 53 54
  switch f
    case  1; fname='STATE/SOstt_5d';  fout='THETA';   rec=1;NZ=42;
    case  2; fname='STATE/SOstt_5d';  fout='SALT';    rec=2;NZ=42;
    case  3; fname='STATE/SOstt_5d';  fout='UVEL';    rec=3;NZ=42;
    case  4; fname='STATE/SOstt_5d';  fout='VVEL';    rec=4;NZ=42;
    case  5; fname='STATE/SOstt_5d';  fout='WVEL';    rec=5;NZ=42;
    case  6; fname='STATE/SOstt_5d';  fout='PHIHYD';  rec=6;NZ=42;
    case  7; fname='STATE/SOstt_5d';  fout='DRHODR';  rec=7;NZ=42;
    case  8; fname='FORCING/SO_Frce5';fout='oceTAUX'; rec=1;NZ=1;
    case  9; fname='FORCING/SO_Frce5';fout='oceTAUY'; rec=2;NZ=1;
    case 10; fname='FORCING/SO_Frce5';fout='oceFWflx';rec=3;NZ=1;
    case 11; fname='FORCING/SO_Frce5';fout='oceSflux';rec=4;NZ=1;
    case 12; fname='FORCING/SO_Frce5';fout='oceQnet'; rec=5;NZ=1;
    case 13; fname='FORCING/SO_Frce5';fout='oceQsw';  rec=6;NZ=1;
    case 14; fname='FORCING/SO_Frce5';fout='oceFreez';rec=7;NZ=1;
    case 15; fname='FORCING/SO_Frce5';fout='KPPhbl';  rec=8;NZ=1;
    case 16; fname='OUT_2D/SO_2Doth'; fout='SIheff';  rec=1;NZ=1;
    case 17; fname='OUT_2D/SO_2Doth'; fout='PHIBOT';  rec=2;NZ=1;
    case 18; fname='TBDGT/SO_Tbdg5';  fout='ADVr_TH'; rec=1;NZ=42;
    case 19; fname='TBDGT/SO_Tbdg5';  fout='ADVx_TH'; rec=2;NZ=42;
    case 20; fname='TBDGT/SO_Tbdg5';  fout='ADVy_TH'; rec=3;NZ=42;
    case 21; fname='TBDGT/SO_Tbdg5';  fout='DFrE_TH'; rec=4;NZ=42;
    case 22; fname='TBDGT/SO_Tbdg5';  fout='DFxE_TH'; rec=5;NZ=42;
    case 23; fname='TBDGT/SO_Tbdg5';  fout='DFyE_TH'; rec=6;NZ=42;
    case 24; fname='TBDGT/SO_Tbdg5';  fout='DFrI_TH'; rec=7;NZ=42;
    case 25; fname='TBDGT/SO_Tbdg5';  fout='TOTTTEND';rec=8;NZ=42;
    case 26; fname='TBDGT/SO_Tbdg5';  fout='KPPg_TH'; rec=9;NZ=42;
    case 27; fname='SBDGT/SO_Sbdg5';  fout='ADVr_SLT';rec=1;NZ=42;
    case 28; fname='SBDGT/SO_Sbdg5';  fout='ADVx_SLT';rec=2;NZ=42;
    case 29; fname='SBDGT/SO_Sbdg5';  fout='ADVy_SLT';rec=3;NZ=42;
    case 30; fname='SBDGT/SO_Sbdg5';  fout='DFrE_SLT';rec=4;NZ=42;
    case 31; fname='SBDGT/SO_Sbdg5';  fout='DFxE_SLT';rec=5;NZ=42;
    case 32; fname='SBDGT/SO_Sbdg5';  fout='DFyE_SLT';rec=6;NZ=42;
    case 33; fname='SBDGT/SO_Sbdg5';  fout='DFrI_SLT';rec=7;NZ=42;
    case 34; fname='SBDGT/SO_Sbdg5';  fout='TOTSTEND';rec=8;NZ=42;
    case 35; fname='SBDGT/SO_Sbdg5';  fout='KPPg_SLT';rec=9;NZ=42;
    case 36; fname='UMOM/SO_Umom5';   fout='Um_Advec';rec=1;NZ=42;
    case 37; fname='UMOM/SO_Umom5';   fout='Um_Cori'; rec=2;NZ=42;
    case 38; fname='UMOM/SO_Umom5';   fout='Um_Diss'; rec=3;NZ=42;
    case 39; fname='UMOM/SO_Umom5';   fout='Um_dPHdx';rec=4;NZ=42;
    case 40; fname='UMOM/SO_Umom5';   fout='Um_Ext';  rec=5;NZ=42;
    case 41; fname='UMOM/SO_Umom5';   fout='TOTUTEND';rec=6;NZ=42;
    case 42; fname='UMOM/SO_Umom5';   fout='VISrI_Um';rec=7;NZ=42;
    case 43; fname='VMOM/SO_Vmom5';   fout='Vm_Advec';rec=1;NZ=42;
    case 44; fname='VMOM/SO_Vmom5';   fout='Vm_Cori'; rec=2;NZ=42;
    case 45; fname='VMOM/SO_Vmom5';   fout='Vm_Diss'; rec=3;NZ=42;
    case 46; fname='VMOM/SO_Vmom5';   fout='Vm_dPHdy';rec=4;NZ=42;
    case 47; fname='VMOM/SO_Vmom5';   fout='Vm_Ext';  rec=5;NZ=42;
    case 48; fname='VMOM/SO_Vmom5';   fout='TOTVTEND';rec=6;NZ=42;
    case 49; fname='VMOM/SO_Vmom5';   fout='VISrI_Vm';rec=7;NZ=42;
    case 50; fname='TSBAR/tbar';      fout='Theta30dy';rec=0;NZ=42;
    case 51; fname='TSBAR/sbar';      fout='Salt30dy';rec=0;NZ=42;
    case 52; fname='ICE/smrareabar';  fout='IceConc' ;rec=0;NZ=1;
    case 53; fname='IES/iestaubar';   fout='IEStau'  ;rec=0;NZ=1;
    case 54; fname='SSH/psbar'    ;   fout='SSHdaily';rec=0;NZ=1;
    case 55; fname='SSTnS/sstbar';   fout='SSTdaily'  ;rec=0;NZ=1;
    case 56; fname='SSTnS/smrsssbar';   fout='SSSdaily';rec=0;NZ=1;
    case 57; fname='UVBAR/ubar';      fout='Uvel30dy';rec=1;NZ=42;
    case 58; fname='UVBAR/vbar';      fout='Vvel30dy';rec=1;NZ=42;
    case 59; fname='TSFLUX/SO_TSFlx';fout='TFLUX'; rec=1;NZ=1;
    case 60; fname='TSFLUX/SO_TSFlx';fout='SFLUX'; rec=2;NZ=1;
  end 
  if JustMetas == 0
  fid = fopen([fout '.0000000060.data'],'w','b');
  if rec > 0
    for iter = iters
      if iter < 10;    iterstr = ['.000000000' num2str(iter) ];
      elseif iter < 100;iterstr = ['.00000000' num2str(iter) ];
      elseif iter < 1000;iterstr = ['.0000000' num2str(iter) ];
      elseif iter < 10000;iterstr = ['.000000' num2str(iter) ];
      elseif iter < 100000;iterstr = ['.00000' num2str(iter) ];
      else;iterstr = ['.0000' num2str(iter) ];
      end
      Q = rdmds([fname],iter,'rec',rec);
      fwrite(fid,Q,'single');
    end
    NT = length(iters);    
  elseif rec == 0
    if NZ == 1
      for t = 1:1096
        Q = rdmds([fname],9,'rec',t);
        fwrite(fid,Q,'single');
      end
      NT = 1096;
    elseif NZ == 42
      for t = 1:36 
        Q = rdmds([fname],9,'rec',t);
        fwrite(fid,Q,'single');
      end
      NT =   36;
    end
  end
  fclose(fid)
  end
  if rec > 0 ;    NT = length(iters);
  elseif rec == 0;
   if NZ == 1; NT = 1096;
   elseif NZ == 42;NT =   36;
   end
  end
  %NOW GENERATE META FOR IT
  fidm=fopen([fout '.0000000060.meta'],'w','b');
  if NZ == 1;fprintf(fidm,'%s\n',' nDims = [   2 ];');
  else;fprintf(fidm,'%s\n',' nDims = [   3 ];');end
  fprintf(fidm,'%s\n',[' dimList = [']);
  fprintf(fidm,'%s\n',['  2160,    1, 2160,']);
  fprintf(fidm,'%s\n',['   320,    1,  320,']);
  if NZ > 1;fprintf(fidm,'%s\n',['    42,    1,   42 ']);end
  fprintf(fidm,'%s\n',' ];');
  fprintf(fidm, '%s%s%s\n', [' dataprec = [ '''] , ['float32'] , [''' ];']);
  fprintf(fidm,'%s\n',[' nrecords = [      '  num2str(NT) ' ];']);    
  fprintf(fidm,'%s\n',' timeStepNumber = [    60 ];');
  fclose(fidm);
end
