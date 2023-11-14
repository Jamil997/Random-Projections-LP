% here we establish the problem dimensions
m = 1000;
n = 2000;

% Values of A, b,c
A = eye(m, n);
b = ones(m, 1);
c = ones(n, 1);

% Bounds for the solution
lb = zeros(n, 1);
ub = inf * ones(n, 1);

% Options for the linprog function
options = optimoptions('linprog', 'Algorithm', 'dual-simplex');

% Varying k as a percentage of m
k_values = round(linspace(0.1*m, 0.9*m, 5)); % 10%, 30%, 50%, 70%, 90% of m
results = zeros(length(k_values), 4); % To store k, CPU times, and error

for i = 1:length(k_values)
    k = k_values(i);
    
    % Generating matrix T (k by m) with random Gaussian variables
    T = randn(k, m);

    % Measuring CPU time for the original problem
    tic;
    [x_original, ~, exitflag_original] = linprog(c, [], [], A, b, lb, ub, options);
    cpu_time_original = toc;

    if exitflag_original ~= 1
        fprintf('Original problem with k = %d has no optimal solution or an error occurred.\n', k);
        continue;
    end

    % New problem setup
    A_new = T * A;
    b_new = T * b;

    % here we measure CPU time for the new problem
    tic;
    [x_new, ~, exitflag_new] = linprog(c, [], [], A_new, b_new, lb, ub, options);
    cpu_time_new = toc;

    if exitflag_new ~= 1
        fprintf('New problem with k = %d has no optimal solution or an error occurred.\n', k);
        continue;
    end

    % Comparing solutions using L2 norm
    error = norm(x_original - x_new);

    % Storing results
    results(i, :) = [k, cpu_time_original, cpu_time_new, error];
end

% Creating a table from the results
result_table = array2table(results, 'VariableNames', {'k', 'CPU_Time_Original', 'CPU_Time_New', 'Error_L2_Norm'});
disp(result_table);

