% ============================================================
% MATLAB/Octave Code for Chapter 7.1 - Spectral Theorem
% Math 401 - Lay-McDonald 7.1.13-22 (Orthogonal Diagonalization)
% ============================================================

%% 7.1.13-22: Orthogonally diagonalize
disp('=== 7.1.13-22: Orthogonal Diagonalization ===');
mats = {
  [4 1; 1 4],                    % 13
  [2 -3; -3 2],                 % 14
  [5 6; 6 10],                  % 15
  [5 -4; -4 11],                % 16
  [1 1 6; 1 6 1; 6 1 1],        % 17
  [2 -1 1; -1 4 -1; 1 -1 2],    % 18
  [4 -2 4; -2 7 2; 4 2 4],      % 19
  [5 -8 4; -8 5 -4; 4 -4 -1],   % 20
  [5 4 1 1; 4 5 1 1; 1 1 5 4; 1 1 4 5],  % 21
  [5 0 1 0; 0 5 0 1; 1 0 5 0; 0 1 0 5]   % 22
};
for i = 1:length(mats)
  A = mats{i};
  [P, D] = eig(A);
  [P, ~] = qr(P);  % orthonormalize
  D = diag(D); [~,ord] = sort(real(D), 'descend');
  D = D(ord); P = P(:,ord);
  err = norm(A - P*diag(D)*P');
  fprintf('Ex %2d: ev=[', 12+i); fprintf('%.0f ', D); fprintf('], err=%.2e\n', err);
end
disp(' ');
