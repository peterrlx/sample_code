/*
**  model 0: no financial frictions+fixed effort+flexible wage (non-linear version)
*/


//-------------------------------------------------------------------------
//  Declare variables
//-------------------------------------------------------------------------


var z, y, c_h, d, k, i, Lambda_k, Lambda_h, R, w, J, m, u, theta, v, n, x, f, q;
// predetermined_variables k n u; 
varexo ep_z;

//-------------------------------------------------------------------------
//  Parameters
//-------------------------------------------------------------------------

parameters rho, eta, m0, alpha, delta, beta, gamma, varphi, u_b, zeta, rho_z, sig_z, 
z_ss, e_ss, u_ss, n_ss, f_ss, v_ss, theta_ss, R_ss, y_k_ss, k_n_ss, y_n_ss, y_ss, k_ss,
i_ss, x_ss, Lambda_k_ss, Lambda_h_ss, w_ss, a_ss, c_h_ss, d_ss, J_ss;

% labor mkt
rho = 0.04; % separation rate
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
u_ss = 0.0625; 

% employment
n_ss = 1-u_ss;

% job finding rate
f_ss = 0.6; 

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

model;

//  Technology process
    log(z) = rho_z*log(z(-1)) + ep_z; 
 
//  output
    y=c_h+d+i+zeta*x^2*n(-1)/2;

    i = y-w*n-zeta*x^2*n(-1)/2-d;

    y = z*e_ss*k(-1)^alpha*n(-1)^(1-alpha);
 
//  wage
    w=eta*((1-alpha)*y/n(-1)+zeta*x^2/2+(1-rho)*zeta*x)+(1-eta)*(u_b+varphi)
-beta*eta*(1-rho-f)*(Lambda_h(+1)*J(+1));
 
//  firm's surplus  
    J = (1-alpha)*(y/n(-1)) - w + zeta*x^2/2 + (1-rho)*zeta*x;
 
//  Labor Market Tightness
    theta = v/u(-1);
 
//  Unemployment
    u = 1-n;
 
//  Matching
    m = u^(eta)*v^(1-eta);
 
//  Employment Dynamics
    n = (1-rho+x)*n(-1);
 
//  hiring rate
    x = q*v/n(-1);
 
//  job creation condition
    x = beta*Lambda_k(+1)*J(+1)/zeta;
 
//  Transition Probabilities
    q = m/v;
    f = m/u(-1);
 
// Capital Renting
    Lambda_h(+1) = 1/R/beta;
 
//  investment
   1 = beta*Lambda_k*(alpha*y(+1)/k+1-delta);
 
 
//  Capital Dynamics
    k = (1-delta)*k(-1) + i;
 
//  Marginal Utility
    Lambda_k = d/d(+1);
    Lambda_h = c_h/c_h(+1);


end;

//-------------------------------------------------------------------------
//  The Steady State
//-------------------------------------------------------------------------
initval;
z = 1;
y = y_ss;
c_h = c_h_ss;
d = d_ss;
k = k_ss;
i = i_ss;
Lambda_k = 1;
Lambda_h = 1;
R = R_ss;
w = w_ss;
J = J_ss;
m = m_ss;
u = u_ss;
theta = theta_ss;
v = v_ss;
n = n_ss;
x = x_ss;
f = f_ss;
q = q_ss;
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


//  GT's original monthly simulation
//stoch_simul(periods=121000, hp_filter=14400, drop=1000, irf=80);

//  Quarterly simulation compatible to BCK
stoch_simul(order=1, periods=4000, hp_filter=1600, drop=1000, irf=40);

