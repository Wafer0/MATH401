% ============================================================
% MATLAB/Octave Code for Chapter 8 - SVD
% Math 401 - Lay-McDonald 7.4; Justin 8.1
% (Spectral Theorem 7.1.13-22: see ex7_1_spectral_theorem.m)
% ============================================================

%% 7.4.1-4: Singular values
disp('=== 7.4.1-4: Singular Values ===');
A1 = [1 0; 0 -3]; A2 = [-3 0; 0 0]; A3 = [2 3; 0 2]; A4 = [3 0; 8 3];
for i = 1:4, A = eval(['A' num2str(i)]); s = svd(A); fprintf('Ex %d: sigma = ', i); disp(s'); end
disp(' ');

%% 7.4.5-12: SVD
disp('=== 7.4.5-12: SVD ===');
mats74 = {
  [-2 0; 0 0],                    % 5
  [-3 0; 0 -2],                   % 6
  [2 -1; 2 2],                    % 7
  [4 6; 0 4],                     % 8
  [3 -3; 0 0; 1 1],               % 9
  [7 1; 5 5; 0 0],                % 10
  [-3 1; 6 -2; 6 -2],             % 11
  [1 1; 0 1; -1 1]                % 12
};
for i = 1:length(mats74)
  A = mats74{i};
  [U,S,V] = svd(A);
  err = norm(A - U*S*V');
  fprintf('Ex %2d: sigma=[', 4+i); fprintf('%.3f ', diag(S)'); fprintf('], err=%.2e\n', err);
end
disp(' ');

%% 7.4.13: SVD of A = [3 2 2; 2 3 -2]
disp('=== 7.4.13: SVD of 2x3 matrix ===');
A = [3 2 2; 2 3 -2];
[U,S,V] = svd(A);
fprintf('Singular values: '); fprintf('%.4f ', diag(S)'); fprintf('\n');
fprintf('Reconstruct err: %.2e\n', norm(A - U*S*V'));
disp(' ');

%% 7.4.14: In Ex 7, unit vector x at which Ax has max length
disp('=== 7.4.14: Max ||Ax|| for Ex 7 ===');
A = [2 -1; 2 2];
[U,S,V] = svd(A);
v1 = V(:,1);
fprintf('x = v1 = '); fprintf('%.4f ', v1); fprintf('\n');
fprintf('||Ax|| = sigma1 = %.4f\n', S(1,1));
disp(' ');

%% 7.4.15-16: Rank = # positive singular values; Col A = first r cols of U; Nul A = last n-r cols of V
disp('=== 7.4.15-16: Rank and bases ===');
disp('Ex 15: 3x3 SVD, sigma=[7.10 3.10 0] => rank=2');
disp('Ex 16: 3x4 SVD, sigma=[12.48 6.34 0 0] => rank=2');
disp(' ');

%% Justin 8.1
disp('=== Justin 8.1: SVD ===');
% (a)
A = [1 2 -3; 0 1 1; 1 2 5; -1 0 2];
[U,S,V] = svd(A);
fprintf('(a) sigma: '); fprintf('%.4f ', diag(S)'); fprintf('\n');
fprintf('    err: %.2e\n', norm(A - U*S*V'));
% (b)
A = [-1 0 2 2 2; 0 2 3 0 1; 1 2 -2 1 2];
[U,S,V] = svd(A);
fprintf('(b) sigma: '); fprintf('%.4f ', diag(S)'); fprintf('\n');
% (d)
A = [0.1 0.2 0.9 0.3; 0.9 0.2 0 0.2; 0.2 0.2 0.3 0.1; 0 0.3 0.7 0.6];
[U,S,V] = svd(A);
fprintf('(d) sigma: '); fprintf('%.6f ', diag(S)'); fprintf('\n');
