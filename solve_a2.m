function results_vec = solve_a2(vector_para)
%% solve the model by Euler equations

sigma=vector_para(1);
beta=vector_para(2);
r=vector_para(3);
epsilon=vector_para(4);
p=vector_para(5);
w1=vector_para(6);
w2_mean=vector_para(7);
a1=vector_para(8);
alimit=vector_para(9);

% search over x, the saving: (bi-sectional search method) define function handle.
uprime = @(x)  x^(-sigma) ; % marginal utility u'(c)
f = @(x)   uprime(a1*(1+r)+w1-x) -beta*(1+r)*p*uprime(x*(1+r)+w2_mean*(1+epsilon)) ...
-beta*(1+r)*(1-p)*uprime(x*(1+r)+w2_mean*(1-epsilon)) ;  %x is a2, f is an increasing function of x


count=1; % count the number of loops
error_tolerance = 10^(-12);
distance_x = 1.0; % initialize btw xmin and xmax


a2_min = -alimit;
a2_max = (1+r)*a1+w1-10^(-12);

f_min = f(a2_min);
f_max = f(a2_max);

while (f_min*f_max<0) && (count<200) && (distance_x>error_tolerance) 
  a2_mid = (a2_min+a2_max)/2;
  f_mid=f(a2_mid);
  % update the guessed a2
      if f(a2_min)*f(a2_mid)<0
          a2_max = a2_mid;
      else
          a2_min = a2_mid;
      end
   % update the function value
  f_min = f(a2_min);
  f_max = f(a2_max);
  distance_x = a2_max-a2_min ;
  count = count + 1;
end


if (  count >1  ) 
 a2_temp=(a2_max+a2_min)/2.0; 
else
 a2_temp=(-alimit);
end   

a2_solution = max(a2_temp,-alimit); 
c1 = a1*(1+r)-a2_solution + w1;


%fprintf('optimal consumption: %0.4f \n',c1) ;

%fprintf("optimal saving: %0.4f",a2_solution);

results_vec=[a2_solution, count, a2_min, f_min, a2_max, f_max ];
end