/*
**  model 0: no financial frictions+fixed effort+flexible wage
*/


//-------------------------------------------------------------------------
//  Declare variables
//-------------------------------------------------------------------------


var z, y, c, c_h, d, k, i, Lambda_k, Lambda_h, R, w, J, m, u, theta, v, n, x, f, q;
// predetermined_variables k n u; 
varexo ep_z;

//-------------------------------------------------------------------------
//  Parameters
//-------------------------------------------------------------------------

parameters rho, eta, m0, alpha, delta, beta, gamma, varphi, u_b, zeta, rho_z, sig_z, 
z_ss, e_ss, u_ss, n_ss, f_ss, v_ss, theta_ss, R_ss, y_k_ss, k_n_ss, y_n_ss, y_ss, k_ss,
i_ss, x_ss, Lambda_k_ss, Lambda_h_ss, w_ss, a_ss, c_ss, c_h_ss, d_ss, J_ss;

% labor mkt
eta = 0.5; % worker's bargaining power
m0 = 1; % matching efficiency

% firm
alpha = 1/3;  % share of capital in the production function
delta = 0.025; % capital depreciation rate

% worker
gamma = 0.5; % Frisch elasticity of labor supply

% household
beta = 0.99; % discount factor

% productivity shock process
rho_z = 0.95;  % persistence
sig_z = 0.008; % deviation

//-------------------------------------------------------------------------
//  Parameters defined on the model (steady state)
//-------------------------------------------------------------------------

% technology
z_ss = 1;

% fixed effort 
e_ss = 0.5;  

% unemployment
u_ss = 0.057; 

% employment
n_ss = 1-u_ss;

% job finding rate
f_ss = 0.6; 

// separation rate
rho = u_ss*f_ss/(1-u_ss); % separation rate

% vacancy
v_ss = (f_ss*u_ss^(1-eta)/m0)^(1/(1-eta)); 

% labor mkt tightness
theta_ss = v_ss/u_ss; 

% capital renting rate
R_ss = 1/beta; 

% y/k ratio
y_k_ss = (1/beta-(1-delta))/alpha;


% k/n ratio
k_n_ss = (y_k_ss/(z_ss*e_ss))^(1/(alpha-1));

% y/n ratio
y_n_ss = z_ss*e_ss*(k_n_ss)^alpha;

% output
y_ss = y_n_ss*n_ss;

% capital
k_ss = k_n_ss*n_ss;

% investment
i_ss = delta*k_ss;

% hiring rate
x_ss = rho;

% Lambda
Lambda_k_ss = 1 ;
Lambda_h_ss = 1 ;

% disutility of labor parameter
varphi = (1-alpha)*z_ss*k_n_ss^alpha*(1-e_ss)^(1/gamma) ;

% jointly calibrate hiring cost parameter (zeta) and unemployment benefit (u_b) 


% solve s.s. wage
B = varphi*((1-e_ss)^(1-1/gamma)-1)/(1-1/gamma); % disutility of labor

repl_ratio = 0.75; % set target to compute wage


Q = eta*(1-beta*(1-rho-f_ss))/(1-beta*eta*(1-rho-f_ss));

AA = Q*(1-alpha)*y_n_ss + Q*((x_ss^2/2+(1-rho)*x_ss)*beta*(1-alpha)*y_n_ss)/((1-beta*(1-rho))*x_ss-beta*x_ss^2/2)...
    + (1-eta)*(repl_ratio-1)*B/(1-beta*eta*(1-rho-f_ss));
BB = 1+ (Q*beta*((x_ss^2)/2+(1-rho)*x_ss))/((1-beta*(1-rho))*x_ss-beta*x_ss^2/2)-...
    (1-eta)*repl_ratio/(1-beta*eta*(1-rho-f_ss));

w_ss = AA/BB;


u_b = repl_ratio*(w_ss+B);



aaa = beta*((1-alpha)*y_n_ss-w_ss);
bbb = (1-beta*(1-rho))*x_ss-beta*x_ss^2/2;
zeta = aaa/bbb; % pin down hiring cost parameter

% consumption
c_ss = y_ss-delta*k_ss- (zeta/2)*x_ss^2/n_ss;

% dividend
d_ss = y_ss-w_ss*n_ss-i_ss-zeta*x_ss^2*n_ss/2;

% household consumption
c_h_ss = c_ss-d_ss;

% firm's surplus
a_ss = (1-alpha)*y_n_ss;
J_ss = a_ss - w_ss + zeta*x_ss^2/2 + (1-rho)*zeta*x_ss; 

m_ss = u_ss^(eta)*v_ss^(1-eta);
q_ss = m_ss/v_ss;
f_ss = m_ss/u_ss;


//-------------------------------------------------------------------------
//  The Model
//-------------------------------------------------------------------------

model(linear);

//  Technology process
    z = rho_z*z(-1) - ep_z;
 
//  output
    y_ss*y = c_h_ss*c_h + d_ss*d + i_ss*i + zeta*x_ss^2*n_ss*x + (zeta*x_ss^2*n_ss/2)*n(-1);

    d_ss*d + i_ss*i = y_ss*y - w_ss*n_ss*w - n_ss*(w_ss+zeta*x_ss^2/2)*n(-1) - zeta*x_ss^2*n_ss*x;

    y = z + alpha*k(-1)+(1-alpha)*n(-1);
 
//  wage
    w_ss*w = eta*(1-alpha)*(y_n_ss)*(y-n(-1)) 
    + eta*zeta*x_ss*(x_ss+1-rho)*x
    + beta*eta*J_ss*f_ss*f 
    - beta*eta*(1-rho-f_ss)*J_ss*(Lambda_h(+1)+J(+1));
 
//  firm's surplus  
    J_ss*J = (1-alpha)*(y_n_ss)*(y-n(-1)) - w_ss*w + zeta*x_ss*(x_ss+1-rho)*x;
 
//  Labor Market Tightness
    theta = v - u(-1);
 
//  Unemployment
    u = -((1-u_ss)/u_ss)*n;
 
//  Matching
    m = eta*u+ (1-eta)*v;
 
//  Employment Dynamics
    n = n(-1) + rho*x;
 
//  hiring rate
    x = q + v - n(-1);
 
//  job creation condition
    x = Lambda_k(+1) + J(+1);
 
//  Transition Probabilities
    q = m - v;
    f = m - u(-1);
 
// Capital Renting
    Lambda_h(+1) = -R;
 
//  investment
   0 = beta*(alpha*y_k_ss+1-delta)*Lambda_k
      +alpha*beta*y_k_ss*(y(+1)-k);
 
 
//  Capital Dynamics
    k = (1-delta)*k(-1) + (i_ss/k_ss)*i;
 
//  Marginal Utility
    Lambda_k = d-d(+1);
    Lambda_h = c_h - c_h(+1);

// consumption
   c_ss*c = c_h_ss*c_h + d_ss*d;

end;

//-------------------------------------------------------------------------
//  The Steady State
//-------------------------------------------------------------------------
initval;
z = 0;
y = 0;
c_h = 0;
d = 0;
k = 0;
i = 0;
Lambda_k = 0;
Lambda_h = 0;
R = 0;
w = 0;
J = 0;
m = 0;
u = 0;
theta = 0;
v = 0;
n = 0;
x = 0;
f = 0;
q = 0;
end;

resid(1);

steady;
check;

//-------------------------------------------------------------------------
//  Shocks and Simulation
//-------------------------------------------------------------------------

shocks;
var ep_z;   stderr sig_z;
end;


//  Quarterly simulation
stoch_simul(periods=4000, hp_filter=1600, drop=1000, irf=20);