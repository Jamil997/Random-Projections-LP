% Define the dimensions
m = 1000;
n = 2000;

% Generate a full rank matrix A of size m x n
A = rand(m, n);
[Q, ~] = qr(A'); % Transpose A because MATLAB's QR deals with columns
A = Q(:, 1:m)'; % Take the first m columns of Q transpose (full rank)

% Generating vectors c and b 
c = rand(n, 1);
b = A * abs(rand(n, 1));

% Linear programming problem: minimize c'x subject to Ax = b, x >= 0
options = optimoptions('linprog', 'Algorithm', 'dual-simplex');
[x, fval, exitflag, output] = linprog(c, [], [], A, b, zeros(n, 1), [], options);

% Display the solution
disp('Solution to the linear programming problem:');
disp(x);
disp('Objective function value:');
disp(fval);
