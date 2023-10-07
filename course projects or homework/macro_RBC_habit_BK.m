%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rongli Xue
% 2022-07
% This file solves the RBC model with habit formation in homework 5 by Blanchard-Kahn Method.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; 
clear; 
close all;
%% 1. Parameters
palpha = 0.33;
pbeta = 0.99;
pdelta = 0.025;
ph = 0.8;
prho = 0.98;
psigma = 0.0072;
% Calibration of pgamma
% Target: steady-state n = 0.25
n = 0.25;
pgamma = (1-pbeta*ph)/(1-ph)*(1-palpha)*(1/pbeta - 1 + pdelta)/(1/pbeta - 1 + pdelta - palpha*pdelta)/(n/(1-n))


%% 2. Calculate linear policy function by Blanchard-Kahn method
% Control variable x = (c,n,y,lambda); state variable s = (c(-1),k,A)
% After deriving the FOCs, we have a system of linear difference equations in a
% matrix form. 
A = zeros(7,7);
A(1,1) = ( 1 + pbeta * ph^2 )/( (1 - pbeta*ph) * (1 - ph) );
A(1,4) = 1;
A(1,5) = - ph /( (1 - pbeta*ph) * (1 - ph) );
A(2,2) = -1/(1-n);
A(2,3) = 1;
A(2,4) = 1;
A(3,4) = 1;
A(4,2) = 1 - palpha;
A(4,3) = -1;
A(4,6) = palpha;
A(4,7) = 1;
A(5,1) = pdelta-(1/pbeta - 1 + pdelta)/palpha;
A(5,3) = (1/pbeta - 1 + pdelta)/palpha;
A(5,6) = 1- pdelta;
A(6,7) = prho;
A(7,1) = 1;

B = zeros(7,7);
B(1,1) = pbeta*ph/((1 - pbeta*ph) * (1 - ph));
B(3,3) = (1/pbeta - 1 + pdelta) / (1/pbeta);
B(3,4) = 1;
B(3,6) = -(1/pbeta - 1 + pdelta) / (1/pbeta);
B(5,6) = 1;
B(6,7) = 1;
B(7,5) = 1;

C = A\B;
[Q,Lambda_mat] = eig(C);
Qinv = inv(Q);
Lambda_vec = diag(Lambda_mat);

Index = find(Lambda_vec<1 & Lambda_vec>-1);
Equations = Qinv(Index,:);

% Calculate policy function: control variable x as a function of state variable s
D = Equations(:,1:4);
E = Equations(:,5:7);
% [D,E]*[x;s] = 0 -> D*x + E*s = 0 -> x = - inv(D)*E*s, which is the policy function
PolicyMat = - inv(D)*E

% Given policy function, calculate the law of motion for state variables:
% A(5:7,1:4)*x_t + A(5:7,5:7)*s_t = E_t ( B(5:7,1:4)*x_{t+1} + B(5:7,5:7)*s_{t+1})
% =  B(5:7,5:7) * E_t s_{t+1}, since B(5:7,1:4) = zero matrix
% By policy function, x_t = PolicyMat*s_t. 
% Therefore, (A(5:7,1:4)*PolicyMat+A(5:7,5:7))*s_t = B(5:7,5:7) * E_t s_{t+1}
% Hence,  E_t s_{t+1} = B(5:7,5:7)\(A(5:7,1:4)*PolicyMat+A(5:7,5:7)) *s_t
TransMat =  B(5:7,5:7)\(A(5:7,1:4)*PolicyMat+A(5:7,5:7)) 

%% 3. Simulation 
time = 100;
StateVariablePath = zeros(3,time);
StateVariablePath(3,1) = 0.01; %  1% tech shock 
for t =2:time
 StateVariablePath(:,t) = TransMat*StateVariablePath(:,t-1 );
end
ControlVariablePath = PolicyMat*StateVariablePath;
% Calculate percentage deviation
StateVariablePath = 100*StateVariablePath;
ControlVariablePath = 100*ControlVariablePath;
timeline = 0:time-1;

%% 4. Plot impulse response functions
figure
 
subplot(2,3,1);
plot(timeline,ControlVariablePath(3,:),'LineWidth',2); % output 
xlabel('Quarter');
title('Output')

subplot(2,3,2);
plot(timeline,ControlVariablePath(2,:),'LineWidth',2); % labor
xlabel('Quarter');
title('Labor');

subplot(2,3,3);
plot(timeline,ControlVariablePath(1,:),'LineWidth',2); %consumption ct
xlabel('Quarter');
title('Consumption')

subplot(2,3,4);
plot(timeline,ControlVariablePath(4,:),'LineWidth',2); %consumption ct
xlabel('Quarter');
title('\lambda (Shadow price)')

subplot(2,3,5);
plot(timeline,StateVariablePath(2,:),'LineWidth',2); % capital
xlabel('Quarter');
title('Capital')

subplot(2,3,6);
plot(timeline,StateVariablePath(3,:),'LineWidth',2); % technology
xlabel('Quarter');
title('Technology')

sgtitle('Percentage deviation from the steady state')
