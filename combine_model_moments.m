% What this matlab code does:
% combine results of std.deviation and correlation in different scenarios.


clear;
clc;
close all;


%% MODEL 1 ==  model01 (flex wage, fixed effort, w/o fin.fric)==========
cd('mycode-model 01')

Dynare_model01; 

cd('model01output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w',  'theta'} ;
[m n] = size(varlist);
count=1;

result = [];
result= array2table(result);
text = cell2table({strcat("flex wage, fixed effort, w/o fin.fric")});
result{1,1}=text{1,1};
count=count+1;

for i=1:n
  model1.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model1.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model1.std.(varlist{i}) ;
  result{count+1,i}=model1.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

model_moments.result=result;
model_moments.count=count;
model_moments.varlist=varlist;
model_moments.n=n;

clearvars -except model_moments

cd ..
cd ..


save model_moments


%% MODEL 2===  model2 (flex wage, fixed effort, w/ fin.fric) ==========
cd('mycode-model 2')

Dynare_model2; 

cd('model2output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("flex wage, fixed effort, w/ fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 2/model2output')

for i=1:n
  model2.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model2.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model2.std.(varlist{i}) ;
  result{count+1,i}=model2.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments

%% MODEL 3===  model41 (flex wage, endo effort, w/o fin.fric)
cd('mycode-model 41')

Dynare_model41; 

cd('model41output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("flex wage, endo effort, w/o fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 41/model41output')

for i=1:n
  model3.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model3.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model3.std.(varlist{i}) ;
  result{count+1,i}=model3.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments

%% MODEL 4===  model3 (flex wage, endo effort, w/ fin.fric)
cd('mycode-model 3')

Dynare_model3; 

cd('model3output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("flex wage, endo effort, w/ fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 3/model3output')

for i=1:n
  model4.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model4.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model4.std.(varlist{i}) ;
  result{count+1,i}=model4.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments


%% MODEL 5===  model82 (sticky wage, fixed effort, w/o fin.fric)======
cd('mycode-model 8')

Dynare_model82; 

cd('model82output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w_sticky',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("sticky wage, fixed effort, w/o fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 8/model82output')

for i=1:n
  model5.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model5.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model5.std.(varlist{i}) ;
  result{count+1,i}=model5.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments



%% MODEL 6===  model7 (sticky wage, fixed effort, w/ fin.fric)==============
cd('mycode-model 7')

Dynare_model7; 

cd('model7output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w_sticky',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("sticky wage, fixed effort, w fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 7/model7output')

for i=1:n
  model6.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model6.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model6.std.(varlist{i}) ;
  result{count+1,i}=model6.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments

%% MODEL 7===  model83 (sticky wage, engo effort, w/o fin.fric)======
cd('mycode-model 8')

Dynare_model82; 

cd('model83output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w_sticky',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("sticky wage, endo effort, w/o fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 8/model83output')

for i=1:n
  model7.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model7.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model7.std.(varlist{i}) ;
  result{count+1,i}=model7.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments


%% MODEL 8===  model61 (sticky wage, endo effort, w/ fin.fric (benchmark)) ==========

cd('mycode-model 61')

Dynare_model61; 

cd('model61output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w_sticky',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("sticky wage, endo effort, w/ fin.fric (benchmark)")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 61/model61output')

for i=1:n
  model8.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model8.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model8.std.(varlist{i}) ;
  result{count+1,i}=model8.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.count=count;
model_moments.varlist=varlist;
model_moments.n=n;



clearvars -except model_moments



save model_moments

%% MODEL 9===  model91 (flex wage, no effort, w/o fin.fric)
cd('mycode-model 9')

Dynare_model91; 

cd('model91output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("flex wage, no effort, w/o fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 9/model91output')

for i=1:n
  model9.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model9.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model9.std.(varlist{i}) ;
  result{count+1,i}=model9.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments




%% MODEL 10===  model101 (flex wage, no effort, w/ fin.fric)
cd('mycode-model 10')

Dynare_model101; 

cd('model101output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("flex wage, no effort, w/ fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 10/model101output')

for i=1:n
  model10.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model10.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model10.std.(varlist{i}) ;
  result{count+1,i}=model10.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments


%% MODEL 11===  model9 (sticky wage, no effort, w/o fin.fric)
cd('mycode-model 9')

Dynare_model91; 

cd('model9output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w_sticky',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("sticky wage, no effort, w/o fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 9/model9output')

for i=1:n
  model11.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model11.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model11.std.(varlist{i}) ;
  result{count+1,i}=model11.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments


%% MODEL 12===  model10 (sticky wage, no effort, w/o fin.fric)
cd('mycode-model 10')

Dynare_model10; 

cd('model10output')
load computed_irfs.mat;

varlist = {'y','c','i', 'uu',  'nn', 'vv', 'w_sticky',  'theta'} ;
[m n] = size(varlist);


result = [];
result= array2table(result);
text = cell2table({strcat("sticky wage, no effort, w/o fin.fric")});
result{1,1}=text{1,1};

cd ..
cd ..
load model_moments
count=  model_moments.count
count=count+1;
cd('mycode-model 10/model10output')

for i=1:n
  model12.std.(varlist{i}) = comp.rel_std.(varlist{i});
  model12.corr.(varlist{i}) = comp.corr.(varlist{i});
  result{count,i}=model12.std.(varlist{i}) ;
  result{count+1,i}=model12.corr.(varlist{i}) ;
end


allVars = 1:width(result);
result= renamevars(result,allVars, ["y","c","i", "u",  "n",  "v", "w", "theta"]);

count=count+1;

clearvars -except result count varlist n

cd ..
cd ..

load model_moments

model_moments.result(count-1,:)=result(1,:);
model_moments.result(count,:)=result(count-1,:);
model_moments.result(count+1,:)=result(count,:);
count=count+1;
model_moments.varlist=varlist;
model_moments.count=count;
model_moments.n=n;



clearvars -except model_moments



save model_moments

filename = 'model_moments.xlsx';
writetable(model_moments.result,filename,'Sheet','all_moments');

%% tightness

table={"Tightness"};

table(2,1)={"flex wage models:"};
table(1,3)={"w/o fin fric"};
table(1,4)={"w fin fric"};
table(3,2)={"no effort"};
table(4,2)={"fixed effort"};
table(5,2)={"endo effort"};
table(6,1)={"sticky wage models:"};
table(6,3)={"w/o fin fric"};
table(6,4)={"w fin fric"};
table(8,2)={"no effort"};
table(9,2)={"fixed effort"};
table(10,2)={"endo effort"};

ind=26; % no effort
table(3,3)={table2array(model_moments.result(ind,model_moments.n))};
table(3,4)={table2array(model_moments.result(ind+3,model_moments.n))};
table(8,3)={table2array(model_moments.result(ind+6,model_moments.n))};
table(8,4)={table2array(model_moments.result(ind+9,model_moments.n))};

ind=2; % fixed effort
table(4,3)={table2array(model_moments.result(ind,model_moments.n))};
table(4,4)={table2array(model_moments.result(ind+3,model_moments.n))};
table(9,3)={table2array(model_moments.result(ind+12,model_moments.n))};
table(9,4)={table2array(model_moments.result(ind+15,model_moments.n))};

ind=8; % endo effort
table(5,3)={table2array(model_moments.result(ind,model_moments.n))};
table(5,4)={table2array(model_moments.result(ind+3,model_moments.n))};
table(10,3)={table2array(model_moments.result(ind+12,model_moments.n))};
table(10,4)={table2array(model_moments.result(ind+15,model_moments.n))};

filename = 'model_moments.xlsx';
writecell(table,filename,'Sheet','std_theta');


%% unemployment

table={"Unemployment"};

table(2,1)={"flex wage models:"};
table(1,3)={"w/o fin fric"};
table(1,4)={"w fin fric"};
table(3,2)={"no effort"};
table(4,2)={"fixed effort"};
table(5,2)={"endo effort"};
table(6,1)={"sticky wage models:"};
table(6,3)={"w/o fin fric"};
table(6,4)={"w fin fric"};
table(8,2)={"no effort"};
table(9,2)={"fixed effort"};
table(10,2)={"endo effort"};

ind=26; % no effort
table(3,3)={table2array(model_moments.result(ind,4))};
table(3,4)={table2array(model_moments.result(ind+3,4))};
table(8,3)={table2array(model_moments.result(ind+6,4))};
table(8,4)={table2array(model_moments.result(ind+9,4))};

ind=2; % fixed effort
table(4,3)={table2array(model_moments.result(ind,4))};
table(4,4)={table2array(model_moments.result(ind+3,4))};
table(9,3)={table2array(model_moments.result(ind+12,4))};
table(9,4)={table2array(model_moments.result(ind+15,4))};

ind=8; % endo effort
table(5,3)={table2array(model_moments.result(ind,4))};
table(5,4)={table2array(model_moments.result(ind+3,4))};
table(10,3)={table2array(model_moments.result(ind+12,4))};
table(10,4)={table2array(model_moments.result(ind+15,4))};

filename = 'model_moments.xlsx';
writecell(table,filename,'Sheet','std_unemp');

%% vacancy

table={"vacancy"};

table(2,1)={"flex wage models:"};
table(1,3)={"w/o fin fric"};
table(1,4)={"w fin fric"};
table(3,2)={"no effort"};
table(4,2)={"fixed effort"};
table(5,2)={"endo effort"};
table(6,1)={"sticky wage models:"};
table(6,3)={"w/o fin fric"};
table(6,4)={"w fin fric"};
table(8,2)={"no effort"};
table(9,2)={"fixed effort"};
table(10,2)={"endo effort"};

ind=26; % no effort
table(3,3)={table2array(model_moments.result(ind,6))};
table(3,4)={table2array(model_moments.result(ind+3,6))};
table(8,3)={table2array(model_moments.result(ind+6,6))};
table(8,4)={table2array(model_moments.result(ind+9,6))};

ind=2; % fixed effort
table(4,3)={table2array(model_moments.result(ind,6))};
table(4,4)={table2array(model_moments.result(ind+3,6))};
table(9,3)={table2array(model_moments.result(ind+12,6))};
table(9,4)={table2array(model_moments.result(ind+15,6))};

ind=8; % endo effort
table(5,3)={table2array(model_moments.result(ind,6))};
table(5,4)={table2array(model_moments.result(ind+3,6))};
table(10,3)={table2array(model_moments.result(ind+12,6))};
table(10,4)={table2array(model_moments.result(ind+15,6))};

filename = 'model_moments.xlsx';
writecell(table,filename,'Sheet','std_vacancy');
