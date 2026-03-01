% ============================================================
% MATLAB Code for Chapter 3 - Least Squares Exercises
% Math 401 - Applications of Linear Algebra
% ============================================================

%% Exercise 3.1
% Find the least-squares solution and least-squares error for:
% [1 2 3; -1 0 2; 5 1 1; 2 2 0] * x = [1;2;3;4]
disp('=== Exercise 3.1 ===');
A = [1 2 3; -1 0 2; 5 1 1; 2 2 0];
b = [1; 2; 3; 4];
x_hat = inv(A'*A) * A'*b;
ls_error = norm(A*x_hat - b);
fprintf('Least-squares solution x_hat:\n');
disp(x_hat);
fprintf('Least-squares error: %.6f\n\n', ls_error);

%% Exercise 3.2
% Find the vector in Col(A) closest to b.
% A = [1 2; 0 -3; 2 6], b = [1;1;0]
disp('=== Exercise 3.2 ===');
A = [1 2; 0 -3; 2 6];
b = [1; 1; 0];
x_hat = inv(A'*A) * A'*b;
proj = A * x_hat;  % vector in Col(A) closest to b
fprintf('Least-squares solution x_hat:\n'); disp(x_hat);
fprintf('Projection (vector in Col(A) closest to b):\n'); disp(proj);
fprintf('LS error: %.6f\n\n', norm(A*x_hat - b));

%% Exercise 3.3
% Using least squares, find the vector in
% span{[1;2;-1;0], [3;3;0;3]} closest to [0;0;0;1]
disp('=== Exercise 3.3 ===');
A = [1 3; 2 3; -1 0; 0 3];
b = [0; 0; 0; 1];
x_hat = inv(A'*A) * A'*b;
proj = A * x_hat;
fprintf('Least-squares solution x_hat:\n'); disp(x_hat);
fprintf('Closest vector in span:\n'); disp(proj);
fprintf('\n');

%% Exercise 3.6
% Using least squares, find the vector in span{[1;2]} closest to [5;5]
disp('=== Exercise 3.6 ===');
A = [1; 2];
b = [5; 5];
x_hat = inv(A'*A) * A'*b;
proj = A * x_hat;
fprintf('Scalar x_hat = %.6f\n', x_hat);
fprintf('Closest vector = [%.6f; %.6f]\n\n', proj(1), proj(2));

%% Exercise 3.7
% Use least-squares to find the point on the line y = 3x closest to (2, 3).
% Points on y=3x: parametrically (t, 3t). Matrix form: [1;3]*t = [2;3]
disp('=== Exercise 3.7 ===');
A = [1; 3];
b = [2; 3];
t_hat = inv(A'*A) * A'*b;
fprintf('Parameter t_hat = %.6f\n', t_hat);
fprintf('Closest point on y=3x: (%.6f, %.6f)\n\n', t_hat, 3*t_hat);

%% Exercise 3.10
% A = [1 2; -1 1; 0 3], b = [1;3;0]
% (a) Find LS solution the long way (orthogonal basis for Col(A))
% (b) Find LS solution the easy way (normal equations)
disp('=== Exercise 3.10 ===');
A = [1 2; -1 1; 0 3];
b = [1; 3; 0];

% (a) Orthogonal basis via Gram-Schmidt
c1 = A(:,1);
c2 = A(:,2);
c2_orth = c2 - (dot(c1,c2)/dot(c1,c1)) * c1;
fprintf('(a) c1 = [%g;%g;%g]\n', c1(1),c1(2),c1(3));
fprintf('    c2_orth = [%.4f;%.4f;%.4f]\n', c2_orth(1),c2_orth(2),c2_orth(3));
proj_b = (dot(b,c1)/dot(c1,c1))*c1 + (dot(b,c2_orth)/dot(c2_orth,c2_orth))*c2_orth;
fprintf('    Pr_ColA(b) = [%.4f;%.4f;%.4f]\n', proj_b(1),proj_b(2),proj_b(3));

% (b) Normal equations
x_hat = inv(A'*A) * A'*b;
fprintf('(b) x_hat via normal equations = [%.6f; %.6f]\n\n', x_hat(1), x_hat(2));

%% Exercise 3.11
% A = [2 -2; 1 4; 1 2], b = [-1;3;1]
disp('=== Exercise 3.11 ===');
A = [2 -2; 1 4; 1 2];
b = [-1; 3; 1];

% (a) Orthogonal basis
c1 = A(:,1); c2 = A(:,2);
c2_orth = c2 - (dot(c1,c2)/dot(c1,c1))*c1;
fprintf('(a) c2_orth = [%.4f;%.4f;%.4f]\n', c2_orth(1),c2_orth(2),c2_orth(3));
proj_b = (dot(b,c1)/dot(c1,c1))*c1 + (dot(b,c2_orth)/dot(c2_orth,c2_orth))*c2_orth;
fprintf('    Pr_ColA(b) = [%.4f;%.4f;%.4f]\n', proj_b(1),proj_b(2),proj_b(3));

% (b) Normal equations
x_hat = inv(A'*A) * A'*b;
fprintf('(b) x_hat = [%.6f; %.6f]\n', x_hat(1), x_hat(2));
fprintf('    LS error = %.6f\n\n', norm(A*x_hat - b));
