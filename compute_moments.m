% This code imports US data for main business cycle variables, uses 
% HP-filter to detrend them, and computes their long-run volatility and 
% correlation with output.

clear all;close all;
clc;

%% Output ===========================
fid=fopen('OUTPUT.txt');
TX= textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
Y=TX{3}; 
Y=log(Y); % 1947:Q1-2023:Q3

%% Vacancies (merge two datasets: conference board and JOLTS) ===========================
%%%%%%%% get vacancy data from Conference Board(index, monthly, 01/1951--07/2006)  %%%%%%%%%%%
fid=fopen('HELPWANT.txt');
TX = textscan(fid,'%f %f %f %f','HeaderLines',0,'delimiter', '\t');
fclose(fid);
V=TX{4};
V=QUARTER(V); % make quarterly averages: 1951:Q1--2006:Q2
Vtest=log(V(end-22+1:end));% 2001:Q1-2006:Q2
V=log(V(1:end-22));  % 1951:Q1-2000:Q4

%%%%%%%%%%%%  get JOLTS (monthly, 1,000, 12/2000 -- 11/2023) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid=fopen('JOLTS.txt');
TX = textscan(fid,'%s %s %s %f','HeaderLines',1);
fclose(fid);
VJ=TX{4};%vacancies
VJ = VJ(2:end-2); % get rid of 12/2000, 2023/10, 2023/11
VJ=QUARTER(VJ); % make quarterly averages -- 
VJtest=log(VJ(1:22)); % 2001:Q1-2006:Q2 (22 quarters)
VJ=log(VJ); % 2001:Q1-2023:Q3 (91 quarters)

%%%%%%%%%% merge %%%%%%%%%%
scale = VJ + Vtest(1)-VJtest(1); % 2001:Q1-2023:Q3 (91 quarters)
v=[V;scale];%scale jolts series  % 1951:Q1-2023:Q3


%% Unemployment =======================
%%%%%% unemp level
fid=fopen('UNEMP_LEVEL.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
UL=TX{3}; % unemployment level
UL=QUARTER(UL);% make quarterly averages
UL=log(UL);  % 1948:Q1-2023:Q4

%%%%%% unemp rate
fid=fopen('UNEMP_RATE.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
UR=TX{3}; % unemployment rate
UR=QUARTER(UR);% make quarterly averages
UR=log(UR); % 1948:Q1-2023:Q4

%% Labor market tightness =======================
% adjust size
ind=max(size(v));
UL= UL(1:end-1); %1948:Q1-2023:Q3
UL = UL(end-ind+1:end); %1951:Q1-2023:Q3
% combine series
TH=v-UL; %in logs - ratio of levels %1951:Q1-2023:Q3

%% Employment ============================
fid=fopen('EMP.txt');
TX= textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
N=TX{3};
N=log(N); %1947:Q1-2023:Q3

%% Real Wage ============================
%%% BLS real wage data
fid=fopen('RW.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
RW=TX{3};
RW=log(RW); %1947:Q1-2023:Q3

%%% CPI-adjusted Real Wage

%%%%% get nominal wage data (CES, monthly)  01/1964--12/2023
fid=fopen('NW.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
NW=TX{3};
NW=QUARTER(NW); %make quarterly averages

%%%%% get price data (CPI, monthly)  01/1947--12/2023
fid=fopen('CPI-URBAN.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
CPI=TX{3};
CPI=QUARTER(CPI); %make quarterly averages

%%%%% Construct (log) real wage series
ind=max(size(NW));
CPI=CPI(end-ind+1:end);
RW_CPI=log(NW)-log(CPI); % 1964:Q1-2023:Q4
RW_CPI=RW_CPI(1:end-1);% 1964:Q1-2023:Q3

%%  Consumption ==============================

%%%% Real Personal Consumption Expenditures %%%%%%
% fid=fopen('CONSUMP.txt');
% TX= textscan(fid,'%s %f','HeaderLines',1);
% fclose(fid);
% C=TX{2}; 
% C=log(C); % 1947:Q1-2023:Q3



%%%% PCE %%%%
fid=fopen('PCE.txt');
TX= textscan(fid,'%s %f','HeaderLines',1);
fclose(fid);
C=TX{2}; 
C=QUARTER(C); %1959:Q1:2023:Q3

%%%%% get price data (CPI, monthly)  01/1947--12/2023
fid=fopen('CPI-URBAN.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
CPI=TX{3};
CPI=QUARTER(CPI); %make quarterly averages
CPI=CPI(1:end-1); %1947:Q1:2023:Q3

%%%%% Construct (log) real consumption series
ind=max(size(C));
CPI=CPI(end-ind+1:end);
C=log(C)-log(CPI); % 1959:Q1-2023:Q3

%%  Investment ==============================
fid=fopen('INVEST.txt');
TX= textscan(fid,'%s %f','HeaderLines',1);
fclose(fid);
INV=TX{2}; 

%%%%% get price data (CPI, monthly)  01/1947--12/2023
fid=fopen('CPI-URBAN.txt');
TX = textscan(fid,'%s %s %f','HeaderLines',1);
fclose(fid);
CPI=TX{3};
CPI=QUARTER(CPI); %make quarterly averages
CPI=CPI(1:end-1); %1947:Q1:2023:Q3

%%%%% Construct (log) real investment series
ind=max(size(INV));
CPI=CPI(end-ind+1:end);
INV=log(INV)-log(CPI); % 1959:Q1-2023:Q3



%%  Adjust size of series, log, and HP filter ===========
%%%%% tightness is shortest: 1951:Q1-2023:Q3
% ind = max(size(TH));
% BLS_y = Y(end-ind+1:end);
% BLS_v = v(end-ind+1:end);
% BLS_u = UR(end-1-ind+1:end-1);
% BLS_n = N(end-ind+1:end);
% BLS_w = RW(end-ind+1:end);
% BLS_th = TH;
% C = C(end-ind+1:end);
% INV = INV(end-ind+1:end);
% disp('Time Period: 1951:Q1-2023:Q3');
% fprintf('\n');



%%%%% Wage is shortest: 1964:Q1-2023:Q3
ind = max(size(RW_CPI));
BLS_y = Y(end-ind+1:end);
BLS_v = v(end-ind+1:end);
BLS_u = UR(end-1-ind+1:end-1);
BLS_n = N(end-ind+1:end);
BLS_th = TH(end-ind+1:end);
BLS_w = RW_CPI;
C = C(end-ind+1:end);
INV = INV(end-ind+1:end);
disp('Time Period: 1964:Q1-2023:Q3');
fprintf('\n');


% ff= (2007-1964+1)*4; % 1964:Q1-2007:Q1
% BLS_y = BLS_y(1:ff);
% BLS_v = BLS_v(1:ff);
% BLS_u = BLS_u(1:ff);
% BLS_n = BLS_n(1:ff);
% BLS_th = BLS_th(1:ff);
% BLS_w = BLS_w (1:ff);
% C = C(1:ff);
% INV = INV(1:ff);
% disp('Time Period: 1964:Q1-2007:Q1');

% ff= (2013-1964+1)*4; % 1964:Q1-2013:Q1
% BLS_y = BLS_y(1:ff);
% BLS_v = BLS_v(1:ff);
% BLS_u = BLS_u(1:ff);
% BLS_n = BLS_n(1:ff);
% BLS_th = BLS_th(1:ff);
% BLS_w = BLS_w (1:ff);
% C = C(1:ff);
% INV = INV(1:ff);
% disp('Time Period: 1964:Q1-2013:Q1');
% fprintf('\n');

% ff= (2023-1964+1)*4-1; 
% bb = (2020-1964+1)*4;
% BLS_y = BLS_y(bb:ff);
% BLS_v = BLS_v(bb:ff);
% BLS_u = BLS_u(bb:ff);
% BLS_n = BLS_n(bb:ff);
% BLS_th = BLS_th(bb:ff);
% BLS_w = BLS_w (bb:ff);
% C = C(bb:ff);
% INV = INV(bb:ff);
% disp('Time Period: 2020:Q1-2023:Q1');
% fprintf('\n');

% ff= (2013-1964+1)*4; 
% bb = (2007-1964+1)*4;
% BLS_y = BLS_y(bb:ff);
% BLS_v = BLS_v(bb:ff);
% BLS_u = BLS_u(bb:ff);
% BLS_n = BLS_n(bb:ff);
% BLS_th = BLS_th(bb:ff);
% BLS_w = BLS_w (bb:ff);
% C = C(bb:ff);
% INV = INV(bb:ff);
% disp('Time Period: 2007:Q1-2013:Q1');
% fprintf('\n');

% ff= (2009-1964+1)*4; 
% bb = (2007-1964+1)*4;
% BLS_y = BLS_y(bb:ff);
% BLS_v = BLS_v(bb:ff);
% BLS_u = BLS_u(bb:ff);
% BLS_n = BLS_n(bb:ff);
% BLS_th = BLS_th(bb:ff);
% BLS_w = BLS_w (bb:ff);
% C = C(bb:ff);
% INV = INV(bb:ff);
% disp('Time Period: 2007:Q1-2009:Q1');
% fprintf('\n');


data_all = [BLS_y BLS_u BLS_v BLS_th BLS_n BLS_w C INV];
varlist = {'y', 'u',  'v',  'theta', 'n', 'w','c','i'} ;


%%%%%%% detrended with HP filter %%%%%%%

data_ = [data_all];
[period num_var] = size(data_);
data_all_hp = zeros(period,num_var);

lambda= 1600;  % parameter of HP-filter

for i = 1:num_var
    data_all_hp(:,i) = data_all(:,i) - hptrend(data_all(:,i), lambda);
end

theta_hp = data_all_hp(:,4);
save theta_hp.txt theta_hp -ascii

v_hp = data_all_hp(:,3);
save v_hp.txt v_hp -ascii


%%  compute std deviation
SD = std(data_all_hp);
SD_matrix = [SD; SD/SD(1)];

%%  compute correlation with output
Corr=corrcoef(data_all_hp);


%%  present results
disp('Std. Dev relative to output:')
fprintf('\n');
for i = 1:num_var
    fprintf('%s %12.2f \n', varlist{i}, SD_matrix(2,i));
end

fprintf('\n');

disp('Contemporaneous correlation with output:')
fprintf('\n');
for i = 1:num_var
    fprintf('%s %12.2f \n', varlist{i}, Corr(1,i));
end