% ============================================================
% MATLAB/Octave Code for Chapter 10 - Image Compression
% Math 401 - Lay-McDonald 7.5; Justin 10.1-10.6
% ============================================================

%% 7.5.1-2: Mean-deviation form and covariance matrix
disp('=== 7.5.1-2: Mean-deviation and Covariance ===');
% Ex 1
X1 = [19 22 6 3 2 20; 12 6 9 15 13 5];
M1 = mean(X1, 2);
B1 = X1 - M1;
S1 = (1/(size(X1,2)-1)) * B1*B1';
fprintf('Ex 1: Mean = '); disp(M1');
fprintf('Ex 1: Covariance S =\n'); disp(S1);
% Ex 2
X2 = [1 5 2 6 7 3; 3 11 6 8 15 11];
M2 = mean(X2, 2);
B2 = X2 - M2;
S2 = (1/(size(X2,2)-1)) * B2*B2';
fprintf('Ex 2: Mean = '); disp(M2');
fprintf('Ex 2: Covariance S =\n'); disp(S2);
disp(' ');

%% 7.5.3-4: Principal components
disp('=== 7.5.3-4: Principal Components ===');
[V1, D1] = eig(S1); [d1, ord1] = sort(diag(D1), 'descend');
V1 = V1(:, ord1);
fprintf('Ex 3: Eigenvalues of S1: '); fprintf('%.4f ', d1); fprintf('\n');
fprintf('Ex 3: First PC u1 = '); fprintf('%.4f ', V1(:,1)); fprintf('\n');
[V2, D2] = eig(S2); [d2, ord2] = sort(diag(D2), 'descend');
V2 = V2(:, ord2);
fprintf('Ex 4: Eigenvalues of S2: '); fprintf('%.4f ', d2); fprintf('\n');
fprintf('Ex 4: First PC u1 = '); fprintf('%.4f ', V2(:,1)); fprintf('\n');
disp(' ');

%% 7.5.5-6: First PC and % variance
disp('=== 7.5.5-6: First PC and %% Variance ===');
S5 = [164.12 32.73 81.04; 32.73 539.44 249.13; 81.04 249.13 189.11];
[V5, D5] = eig(S5); [d5, ord5] = sort(diag(D5), 'descend');
pct5 = d5(1) / sum(d5);
fprintf('Ex 5: First PC explains %.2f%% of variance\n', 100*pct5);
S6 = [29.64 18.38 5.00; 18.38 20.82 14.06; 5.00 14.06 29.21];
[V6, D6] = eig(S6); [d6, ord6] = sort(diag(D6), 'descend');
pct6 = d6(1) / sum(d6);
fprintf('Ex 6: First PC explains %.2f%% of variance\n', 100*pct6);
disp(' ');

%% 10.1: 4x4 image
disp('=== Exercise 10.1: 4x4 image ===');
A = [1 0.5 1 0; 0.5 1 0 1; 0.5 0.5 1 1; 1 0 0 0.5];
[U,S,V] = svd(A);
svals = diag(S);
fprintf('Singular values: '); fprintf('%.4f ', svals'); fprintf('\n');
for k = [3 2 1]
  var_pres = sum(svals(1:k).^2) / sum(svals.^2);
  fprintf('  k=%d: variance preserved = %.4f (%.2f%%)\n', k, var_pres, 100*var_pres);
end
disp(' ');

%% 10.2: 5x5 image
disp('=== Exercise 10.2: 5x5 image ===');
A = [1 0 1 0 1; 1 0 1 0 1; 1 1 0.5 1 1; 0 1 1 1 0; 1 0 0 0 1];
[U,S,V] = svd(A);
svals = diag(S);
fprintf('Singular values: '); fprintf('%.4f ', svals'); fprintf('\n');
for k = [4 3 2 1]
  var_pres = sum(svals(1:k).^2) / sum(svals.^2);
  fprintf('  k=%d: variance preserved = %.4f\n', k, var_pres);
end
disp(' ');

%% 10.3: User-supplied square image
disp('=== Exercise 10.3: user-supplied image workflow ===');
img_path = 'image.jpg';
if exist(img_path, 'file')
  A = imread(img_path);
  if ndims(A) == 3
    A = rgb2gray(A);
  end
  A = im2double(A);
  A = A - min(A(:));
  maxA = max(A(:));
  if maxA > 0
    A = A / maxA;
  end

  [m,n] = size(A);
  if m ~= n
    fprintf('Image is %dx%d, not square. Crop or resize before using this exercise.\n', m, n);
  else
    [U,S,V] = svd(A);
    svals = diag(S);
    count = length(svals);
    fprintf('Square image size: %dx%d\n', m, n);
    fprintf('Number of singular values: %d\n', count);

    for pct = [0.75 0.50 0.25]
      k = round(pct * count);
      var_pres = sum(svals(1:k).^2) / sum(svals.^2);
      fprintf('  keep %.0f%% of singular values: k=%d, quality=%.4f%%\n', ...
        100*pct, k, 100*var_pres);
    end

    target = 0.999;
    cum = cumsum(svals.^2);
    total = cum(end);
    k_min = find(cum/total >= target, 1);
    ratio = 2*k_min / count;
    fprintf('  min k for 99.9%% quality: %d, compression ratio=%.4f\n', k_min, ratio);
  end
else
  fprintf('Place a square image at %s to run Exercise 10.3.\n', img_path);
end
disp(' ');

%% 10.5: Min k for 99.9% quality
disp('=== Exercise 10.5: Min k for 99.9%% quality ===');
sigs = { [80.2608 63.3520 20.5871 8.4696 2.8841 1.6763 0.7962 0.6926 0.6553 0.6520], ...
  [138.5481 49.5181 16.5869 4.9396 3.2379 1.5248 1.1992 1.0277 1.0208 0.9786], ...
  [446.1649 163.4218 43.8892 13.7979 4.7417 1.3437 1.0500 0.6422 0.4532 0.4484], ...
  [209.4851 28.1916 22.8720 11.8304 6.3254 2.7847 1.2043 0.9255 0.8765 0.8722] };
labels = {'(a)','(b)','(c)','(d)'};
for i = 1:4
  s = sigs{i};
  cum = cumsum(s.^2);
  k = find(cum/cum(end) >= 0.999, 1);
  fprintf('%s k=%d, compression ratio=%.2f\n', labels{i}, k, 2*k/10);
end
disp(' ');

%% 10.6: General m x n compression
disp('=== Exercise 10.6: General m x n compression ===');
m = 200; n = 150; k = 30;
ratio_exact = k*(m+n+1)/(m*n);
ratio_approx = k*(m+n)/(m*n);
fprintf('m=%d, n=%d, k=%d: exact ratio=%.4f, approx ratio=%.4f\n', ...
  m, n, k, ratio_exact, ratio_approx);
fprintf('Worth when k < mn/(m+n+1) = %.4f (exact)\n', m*n/(m+n+1));
fprintf('Worth when k < mn/(m+n) = %.4f (approx)\n', m*n/(m+n));
