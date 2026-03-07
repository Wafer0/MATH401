% Exercise 8.1: SVD of matrices (a)-(d)
% Verify SVD computations from sol08_svd.tex

disp('=== Exercise 8.1: Singular Value Decomposition ===');
disp(' ');

% (a)
A = [1 2 -3; 0 1 1; 1 2 5; -1 0 2];
[U,S,V] = svd(A);
disp('(a) A = [1 2 -3; 0 1 1; 1 2 5; -1 0 2]');
fprintf('  Singular values: '); disp(diag(S)');
fprintf('  Reconstruct error: %.2e\n', norm(A - U*S*V'));
disp(' ');

% (b)
A = [-1 0 2 2 2; 0 2 3 0 1; 1 2 -2 1 2];
[U,S,V] = svd(A);
disp('(b) 3x5 matrix');
fprintf('  Singular values: '); disp(diag(S)');
disp(' ');

% (d)
A = [0.1 0.2 0.9 0.3; 0.9 0.2 0 0.2; 0.2 0.2 0.3 0.1; 0 0.3 0.7 0.6];
[U,S,V] = svd(A);
disp('(d) 4x4 matrix');
fprintf('  Singular values: '); disp(diag(S)');
fprintf('  Reconstruct error: %.2e\n', norm(A - U*S*V'));
