% What this matlab code does:
% 1. computes the properties of model1.
% 2. runs dynare code "model01.mod" with parameters specified.

% Rongli Xue, 2023-12



clear;
clc;
close all;





%   run dynare model


dynare model01.mod;

%dynare model01_non_linear.mod;

%dynare model01_non_linear2.mod;

% plot figures

figure;

subplot(3,3,1);
plot([0:options_.irf],[0 oo_.irfs.y_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Output');
xlim([0,20]);
yline(0,'--r','LineWidth',1);


subplot(3,3,2);
plot([0:options_.irf],[0 oo_.irfs.c_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Consumption');
xlim([0,20]);
yline(0,'--r','LineWidth',1);

subplot(3,3,3);
plot([0:options_.irf],[0 oo_.irfs.i_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Investment');
xlim([0,20]);
yline(0,'--r','LineWidth',1);


subplot(3,3,4);
plot([0:options_.irf],[0 oo_.irfs.n_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Employment');
yline(0,'--r','LineWidth',1);


subplot(3,3,5);
plot([0:options_.irf],[0 oo_.irfs.u_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Unemployment');
yline(0,'--r','LineWidth',1);


subplot(3,3,6);
plot([0:options_.irf],[0 oo_.irfs.v_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Vacancy');
yline(0,'--r','LineWidth',1);


subplot(3,3,7);
plot([0:options_.irf],[0 oo_.irfs.theta_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Tightness');
yline(0,'--r','LineWidth',1);

subplot(3,3,8);
plot([0:options_.irf],[0 oo_.irfs.w_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Wages');
yline(0,'--r','LineWidth',1);


subplot(3,3,9);
plot([0:options_.irf],[0 oo_.irfs.z_ep_z],'Linewidth', 2, 'Color', [0, 0.4470, 0.7410]);
title('Productivity shock');
yline(0,'--r','LineWidth',1);



% model_diagnostics(M_,options_,oo_)

% 
% %   relative std. dev
result = fopen('model01.log', 'A');
%result = fopen('model01_non_linear.log', 'A');
%result = fopen('model01_non_linear2.log', 'A');

fprintf(result, '\n\n\nSTD. DEV. relative to Output \n');
fprintf('\n\n\nSTD. DEV. relative to Output \n');
rel_std(1) = sqrt(oo_.var(1,1))/sqrt(oo_.var(2,2));
rel_std(2) = sqrt(oo_.var(2,2))/sqrt(oo_.var(2,2));
for i = 3:M_.orig_endo_nbr
    rel_std(i) = sqrt(oo_.var(i,i))/sqrt(oo_.var(2,2));
end

for i = 1:M_.orig_endo_nbr
    fprintf('%10s %12.4f \n', M_.endo_names_long{i}, rel_std(i));
    fprintf(result, '%10s %12.4f \n', M_.endo_names_long{i}, rel_std(i));
end

comp.rel_std.z = rel_std(1);
comp.rel_std.y = rel_std(2);
comp.rel_std.c = rel_std(3);
comp.rel_std.c_h = rel_std(4);
comp.rel_std.d = rel_std(5);
comp.rel_std.k = rel_std(6);
comp.rel_std.i = rel_std(7);
comp.rel_std.Lambda_k = rel_std(8);
comp.rel_std.Lambda_h = rel_std(9);
comp.rel_std.R = rel_std(10);
comp.rel_std.w = rel_std(11);
comp.rel_std.J = rel_std(12);
comp.rel_std.mu_k = rel_std(13);
comp.rel_std.m = rel_std(14);
comp.rel_std.u = rel_std(15);
comp.rel_std.v = rel_std(16);
comp.rel_std.n = rel_std(17);
comp.rel_std.x = rel_std(18);
comp.rel_std.f = rel_std(19);
comp.rel_std.q = rel_std(20);
comp.rel_std.theta = rel_std(21);
comp.rel_std.N = rel_std(22);
comp.rel_std.uu = rel_std(23);
comp.rel_std.vv = rel_std(24);
comp.rel_std.nn = rel_std(25);

% compute correlation
fprintf(result, '\n\n\n Contemporaneous Correlation with Output \n');
fprintf('\n\n\n Contemporaneous Correlation with Output \n');
corr(1) = oo_.contemporaneous_correlation(1,2);
corr(2) = oo_.contemporaneous_correlation(2,2);
for i = 3:M_.endo_nbr
    corr(i) = oo_.contemporaneous_correlation(i,2);
end

for i = 1:M_.endo_nbr
    fprintf('%10s %12.4f \n', M_.endo_names_long{i}, corr(i));
    fprintf(result, '%10s %12.4f \n', M_.endo_names_long{i}, corr(i));
end

comp.corr.z = corr(1);
comp.corr.y = corr(2);
comp.corr.c = corr(3);
comp.corr.c_h = corr(4);
comp.corr.d = corr(5);
comp.corr.k = corr(6);
comp.corr.i = corr(7);
comp.corr.Lambda_k = corr(8);
comp.corr.Lambda_h = corr(9);
comp.corr.R = corr(10);
comp.corr.w = corr(11);
comp.corr.J = corr(12);
comp.corr.mu_k = corr(13);
comp.corr.m = corr(14);
comp.corr.u = corr(15);
comp.corr.v = corr(16);
comp.corr.n = corr(17);
comp.corr.x = corr(18);
comp.corr.f = corr(19);
comp.corr.q = corr(20);
comp.corr.theta = corr(21);
comp.corr.N = corr(22);
comp.corr.uu = corr(23);
comp.corr.vv = corr(24);
comp.corr.nn = corr(25);

%   compute the regression coefficients 
% (correlation of endogeneous variables with output)

fprintf(result, '\n\n\nRegression Coefficients on Output \n');
fprintf('\n\n\nRegression Coefficients on Output \n');
for i = 1:M_.orig_endo_nbr
    reg_coef(i) = oo_.var(i,2)/oo_.var(2,2);
    fprintf('%10s %12.4f \n', M_.endo_names_long{i}, reg_coef(i));
    fprintf(result, '%10s %12.4f \n', M_.endo_names_long{i}, reg_coef(i));
end

comp.reg_coef.z = reg_coef(1);
comp.reg_coef.y = reg_coef(2);
comp.reg_coef.c = reg_coef(3);
comp.reg_coef.c_h = reg_coef(4);
comp.reg_coef.d = reg_coef(5);
comp.reg_coef.k = reg_coef(6);
comp.reg_coef.i = reg_coef(7);
comp.reg_coef.Lambda_k = reg_coef(8);
comp.reg_coef.Lambda_h = reg_coef(9);
comp.reg_coef.R = reg_coef(10);
comp.reg_coef.w = reg_coef(11);
comp.reg_coef.J = reg_coef(12);
comp.reg_coef.mu_k = reg_coef(13);
comp.reg_coef.m = reg_coef(14);
comp.reg_coef.u = reg_coef(15);
comp.reg_coef.v = reg_coef(16);
comp.reg_coef.n = reg_coef(17);
comp.reg_coef.x = reg_coef(18);
comp.reg_coef.f = reg_coef(19);
comp.reg_coef.q = reg_coef(20);
comp.reg_coef.theta = reg_coef(21);
comp.reg_coef.N = reg_coef(22);
comp.reg_coef.uu = reg_coef(23);
comp.reg_coef.vv = reg_coef(24);
comp.reg_coef.nn = reg_coef(25);
 
%   compute impulse responses

irfs_ez = zeros(M_.orig_endo_nbr,options_.irf);
shock_ez = -0.01;

for i = 1:M_.orig_endo_nbr
    irfs_ez(oo_.dr.order_var(i),1) = oo_.dr.ghu(i)*shock_ez;
end


for j = 2:options_.irf
    for i = 1:M_.endo_nbr
        irfs_ez(oo_.dr.order_var(i),j) = oo_.dr.ghx(i,1)*irfs_ez(oo_.dr.state_var(1),j-1) ...
                                       + oo_.dr.ghx(i,2)*irfs_ez(oo_.dr.state_var(2),j-1) ...
                                       + oo_.dr.ghx(i,3)*irfs_ez(oo_.dr.state_var(3),j-1) ...
                                       + oo_.dr.ghx(i,4)*irfs_ez(oo_.dr.state_var(4),j-1)...
                                       + oo_.dr.ghx(i,5)*irfs_ez(oo_.dr.state_var(5),j-1);
    end
end


%   save computed irfs

comp.irfs.ez.z = -irfs_ez(1,:);
comp.irfs.ez.y = -irfs_ez(2,:);
comp.irfs.ez.c = -irfs_ez(3,:);
comp.irfs.ez.c_h = -irfs_ez(4,:);
comp.irfs.ez.d = -irfs_ez(5,:);
comp.irfs.ez.k = -irfs_ez(6,:);
comp.irfs.ez.i = -irfs_ez(7,:);
comp.irfs.ez.Lambda_k = -irfs_ez(8,:);
comp.irfs.ez.Lambda_h = -irfs_ez(9,:);
comp.irfs.ez.R = -irfs_ez(10,:);
comp.irfs.ez.w = -irfs_ez(11,:);
comp.irfs.ez.J = -irfs_ez(12,:);
comp.irfs.ez.mu_k = -irfs_ez(13,:);
comp.irfs.ez.m = -irfs_ez(14,:);
comp.irfs.ez.u = -irfs_ez(15,:);
comp.irfs.ez.v = -irfs_ez(16,:);
comp.irfs.ez.n = -irfs_ez(17,:);
comp.irfs.ez.x = -irfs_ez(18,:);
comp.irfs.ez.f = -irfs_ez(19,:);
comp.irfs.ez.q = -irfs_ez(20,:);
comp.irfs.ez.theta = -irfs_ez(21,:);

save('computed_irfs.mat', 'comp');


%   delete dynare generated m files

rmdir('+model01', 's');
% rmdir('+model1_non_linear', 's');


%   move and save dynare results to output folder (non-linear)
% 
% mkdir('model1output');
% output_dir = strcat('model1output/');
% 
% 
% 
% fclose('all');
% movefile('model1_non_linear.log', output_dir);
% 
% movefile('computed_irfs.mat', output_dir);
% 
% movefile('model1_non_linear/Output/model1_non_linear_results.mat', output_dir);
% 
% movefile('model1_non_linear/graphs/model1_non_linear_IRF_ep_z1.eps', output_dir);
% movefile('model1_non_linear/graphs/model1_non_linear_IRF_ep_z2.eps', output_dir);
% movefile('model1_non_linear/graphs/model1_non_linear_IRF_ep_z3.eps', output_dir);


%   move and save dynare results to output folder (log-linear)

mkdir('model01output');
output_dir = strcat('model01output/');



fclose('all');
movefile('model01.log', output_dir);

movefile('computed_irfs.mat', output_dir);

movefile('model01/Output/model01_results.mat', output_dir);

% movefile('model01/graphs/model01_IRF_ep_z1.eps', output_dir);
% movefile('model01/graphs/model01_IRF_ep_z2.eps', output_dir);
% movefile('model01/graphs/model01_IRF_ep_z3.eps', output_dir);

(zeta*x_ss^2*n_ss/2)/y_ss


y_ss/n_ss