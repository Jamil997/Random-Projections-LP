% here we tunt the parameters
n = 100; % Dimension of x
m = 20;  % Number of constraints
k = 10;  % Dimension after random projection

% Generate a random matrix A
A = randn(m, n);

% Generate random matrices for the linear programming problem
c = randn(n, 1);
b = randn(m, 1);

% Generate random projection matrix T
T = randn(k, n); % Fix the dimension to k x n

% Project the linear programming problem
c_proj = T * c;
A_proj = T * A';

% Solve the projected linear programming problem
options = optimoptions('linprog', 'Algorithm', 'interior-point'); % Use interior-point algorithm
x_proj = linprog(c_proj, [], [], A_proj', b, zeros(k, 1), [], options);

% Reconstruct the solution in the original space
x_star = pinv(T) * x_proj; % Use pinv(T) without transposing

% Solve the original linear programming problem
options = optimoptions('linprog', 'Algorithm', 'interior-point'); % Use interior-point algorithm
x = linprog(c, [], [], A, b, zeros(n, 1), [], options);

% Calculate the L2 norm between x and x_star
l2_norm = norm(x - x_star);

disp(['L2 norm between x and x_star: ', num2str(l2_norm)]);








