% this code solves the 2-period incomplete mkt model (homework).
clc
clear all

%% change epsilon from 0 to 0.2
clc
clear all
epsilon_vec = linspace(0,0.2,5000)';

TT=size(epsilon_vec,1);
c1_vec=zeros(TT,1);
a2_vec=zeros(TT,1);


for i=1:TT

    % parameters;
    sigma = 2.0;% risk aversion
    beta = 0.96;
    r = 1/beta-1; % risk-free interest rate
    p = 0.5;
    w1 = 0.1;
    w2_mean = 1;
    a1 = 0.1; % initial wealth
    alimit = 0.12; % borrowing limit
    
    vector_para(1)=sigma;
    vector_para(2)=beta;
    vector_para(3)=r;
    vector_para(4)=epsilon_vec(i);
    vector_para(5)=p;
    vector_para(6)=w1;
    vector_para(7)=w2_mean;
    vector_para(8)=a1;
    vector_para(9)=alimit;
    
    
    results_vec= solve_a2(vector_para);
    x=results_vec(1);
    c1=a1*(1+r)+w1-x;
       
    c1_vec(i)=c1;
    a2_vec(i)=x;
end


% margin
c1_margin_vec = zeros(TT, 1); % record c1 for giving a small amount of w1
a2_margin_vec = zeros(TT, 1); % record a2 for giving a small amount of w1
w1_margin = 10^(-3);

for i=1:TT

    % parameters;
    sigma = 2.0;% risk aversion
    beta = 0.96;
    r = 1/beta-1; % risk-free interest rate
    p = 0.5;
    w1 = 0.1;
    w2_mean = 1;
    a1 = 0.1; % initial wealth
    alimit = 0.12; % borrowing limit
    
    vector_para(1)=sigma;
    vector_para(2)=beta;
    vector_para(3)=r;
    vector_para(4)=epsilon_vec(i);
    vector_para(5)=p;
    vector_para(6)=w1 + w1_margin;
    vector_para(7)=w2_mean;
    vector_para(8)=a1;
    vector_para(9)=alimit;
    
    
    results_vec= solve_a2(vector_para);
    x=results_vec(1);
    c1_margin=a1*(1+r)+w1+ w1_margin-x;

    c1_margin_vec(i)=c1_margin;
    a2_margin_vec(i)=x;
end

figure;
subplot(1,2,1)
plot(epsilon_vec, c1_vec, '-.b','LineWidth',2);
hold on
plot(epsilon_vec, a2_vec,  '-r','LineWidth',2);
grid on
xlabel('uncertainty parameter \epsilon')
legend('Consumption $c_{1}$', 'Saving $a_{2}$', 'interpreter','latex','Location', 'best')



subplot(1,2,2)
mpc_vec= (c1_margin_vec(1:TT)-c1_vec(1:TT))/w1_margin; % marginal propsentity to consume
plot(epsilon_vec(1:TT),mpc_vec*100, '-ob','LineWidth',2);
grid on
hold on
mps_vec= (a2_margin_vec(1:TT)-a2_vec(1:TT))/w1_margin; % marginal propsentity to save
plot(epsilon_vec(1:TT),mps_vec*100, '-r','LineWidth',2);
hold on 
plot(epsilon_vec(1:TT),mps_vec'*100+mpc_vec*100, '-.g','LineWidth',2);%verify
xlabel('uncertainty parameter \epsilon')
legend('Marginal propensity to consume','Marginal propensity to save','interpreter','latex','Location', 'south')
ylabel('%')



saveas(gcf, 'Change_uncertainty','jpeg')


%% change a_limit from 0 to 0.2
clc
clear all
a_limit_vec = linspace(0,0.2,5000)';

TT=size(a_limit_vec,1);
c1_vec=zeros(TT,1);
a2_vec=zeros(TT,1);

for i=1:TT

    % parameters;
    sigma = 2.0;% risk aversion
    beta = 0.96;
    r = 1/beta-1; % risk-free interest rate
    epsilon = 0.1;
    
    p = 0.5;
    w1 = 0.1;
    w2_mean = 1;
    a1 = 0.1; % initial wealth
    
    vector_para(1)=sigma;
    vector_para(2)=beta;
    vector_para(3)=r;
    vector_para(4)=epsilon;
    vector_para(5)=p;
    vector_para(6)=w1;
    vector_para(7)=w2_mean;
    vector_para(8)=a1;
    vector_para(9)=a_limit_vec(i);% borrowing limit
    
    
    results_vec= solve_a2(vector_para);
    x=results_vec(1);
    c1=a1*(1+r)+w1-x;
    
    c1_vec(i)=c1;
    a2_vec(i)=x;
end

%margin
c1_margin_vec = zeros(TT, 1); % record c1 for giving a small amount of w1
a2_margin_vec = zeros(TT, 1); % record a2 for giving a small amount of w1
w1_margin=10^(-3);
for i=1:TT

    % parameters;
    sigma = 2.0;% risk aversion
    beta = 0.96;
    r = 1/beta-1; % risk-free interest rate
    epsilon = 0.1;
    
    p = 0.5;
    w1 = 0.1;
    w2_mean = 1;
    a1 = 0.1; % initial wealth
    
    vector_para(1)=sigma;
    vector_para(2)=beta;
    vector_para(3)=r;
    vector_para(4)=epsilon;
    vector_para(5)=p;
    vector_para(6)=w1+w1_margin;
    vector_para(7)=w2_mean;
    vector_para(8)=a1;
    vector_para(9)=a_limit_vec(i);% borrowing limit
    
    
    results_vec= solve_a2(vector_para);
    x=results_vec(1);
    c1_margin=a1*(1+r)+w1+w1_margin-x;
    
    c1_margin_vec(i)=c1_margin;
    a2_margin_vec(i)=x;
end

figure;
subplot(1,2,1)
plot(a_limit_vec, c1_vec, '-.b','LineWidth',2);
hold on
plot(a_limit_vec, a2_vec,  '-r','LineWidth',2);
grid on
xlabel('Borrowing limit')
legend('Consumption $c_{1}$', 'Saving $a_{2}$', 'interpreter','latex','Location', 'best')



subplot(1,2,2)
mpc_vec= (c1_margin_vec(1:TT)-c1_vec(1:TT))/w1_margin; % marginal propsentity to consume
plot(a_limit_vec(1:TT),mpc_vec*100, '-ob','LineWidth',2);
grid on
hold on
mps_vec= (a2_margin_vec(1:TT)-a2_vec(1:TT))/w1_margin; % marginal propsentity to save
plot(a_limit_vec(1:TT),mps_vec*100, '-r','LineWidth',2);
hold on 
plot(a_limit_vec(1:TT),mps_vec'*100+mpc_vec*100, '-.g','LineWidth',2);%verify
xlabel('Borrowing limit')
legend('Marginal propensity to consume','Marginal propensity to save','interpreter','latex','Location', 'best')
ylabel('%')


saveas(gcf, 'Change_borrow_limit','jpeg')
