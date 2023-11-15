% Define the dimensions
m = 1000;
n = 2000;
k_values = [500, 600, 700, 800, 900]; % Values of k to iterate over

% Initialize a table to store the results
resultsTable = table([], [], [], [], 'VariableNames', {'K', 'L2_Norm_Error', 'Original_Problem_Time', 'Projection_Problem_Time'});

% Generate a full rank matrix A of size m x n
A = rand(m, n);
[Q, ~] = qr(A'); % Transpose A because MATLAB's QR deals with columns
A = Q(:, 1:m)'; % Take the first m columns of Q transpose (full rank)

% Generate vectors c and b with appropriate dimensions
c = rand(n, 1);
b = A * abs(rand(n, 1));

% Set options for linear programming
options = optimoptions('linprog', 'Algorithm', 'dual-simplex');

% Loop over different values of k
for k = k_values
    % Generate a random Gaussian matrix T of size k x m
    T = randn(k, m);

    % Linear programming problem: minimize c'x subject to Ax = b, x >= 0
    startTime = tic; % Start timer for original problem
    [x, ~, ~, ~] = linprog(c, [], [], A, b, zeros(n, 1), [], options);
    originalTime = toc(startTime); % CPU time for original problem

    % Linear programming problem with random projections: minimize c'x subject to TAx = Tb, x >= 0
    startTime = tic; % Start timer for alternative problem
    [x_proj, ~, ~, ~] = linprog(c, [], [], T*A, T*b, zeros(n, 1), [], options);
    projectionTime = toc(startTime); % CPU time for alternative problem

    % Compare solutions in L2 norm
    errorL2 = norm(x - x_proj);

    % Add the results to the table
    resultsTable = [resultsTable; {k, errorL2, originalTime, projectionTime}];
end

% Display the table
disp(resultsTable);

