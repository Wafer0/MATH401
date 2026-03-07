% Exercises 10.1, 10.2, 10.5, 10.6: Image compression via SVD
% SP4: Image compression

disp('=== Exercise 10.1: 4x4 image ===');
A = [1 0 1 1; 1 1 0 1; 0 1 0 1; 0 1 1 0];
[U,S,V] = svd(A);
svals = diag(S);
fprintf('Singular values: '); disp(svals');
for k = [3 2 1]
  var_pres = sum(svals(1:k).^2) / sum(svals.^2);
  fprintf('  k=%d: variance preserved = %.4f (%.2f%%)\n', k, var_pres, 100*var_pres);
end
disp(' ');

disp('=== Exercise 10.2: 5x5 image ===');
A = [1 0.5 0 1 1; 0.5 1 0.5 0 1; 0 0.5 1 0.5 0; 1 0 0.5 1 0.5; 1 1 0 0.5 1];
[U,S,V] = svd(A);
svals = diag(S);
fprintf('Singular values: '); disp(svals');
for k = [4 3 2 1]
  var_pres = sum(svals(1:k).^2) / sum(svals.^2);
  fprintf('  k=%d: variance preserved = %.4f\n', k, var_pres);
end
disp(' ');

disp('=== Exercise 10.5: Min k for 99.9%% quality ===');
% (a)
s = [80.2608 63.3520 20.5871 8.4696 2.8841 1.6763 0.7962 0.6926 0.6553 0.6520];
cum = cumsum(s.^2); k = find(cum/cum(end) >= 0.999, 1);
fprintf('(a) k=%d, compression ratio=%.2f\n', k, 2*k/10);
% (b)
s = [138.5481 49.5181 16.5869 4.9396 3.2379 1.5248 1.1992 1.0277 1.0208 0.9786];
cum = cumsum(s.^2); k = find(cum/cum(end) >= 0.999, 1);
fprintf('(b) k=%d, compression ratio=%.2f\n', k, 2*k/10);
% (c)
s = [446.1649 163.4218 43.8892 13.7979 4.7417 1.3437 1.0500 0.6422 0.4532 0.4484];
cum = cumsum(s.^2); k = find(cum/cum(end) >= 0.999, 1);
fprintf('(c) k=%d, compression ratio=%.2f\n', k, 2*k/10);
% (d)
s = [209.4851 28.1916 22.8720 11.8304 6.3254 2.7847 1.2043 0.9255 0.8765 0.8722];
cum = cumsum(s.^2); k = find(cum/cum(end) >= 0.999, 1);
fprintf('(d) k=%d, compression ratio=%.2f\n', k, 2*k/10);
disp(' ');

disp('=== Exercise 10.6: General m x n compression ===');
m = 200; n = 150; k = 30;
ratio = k*(m+n)/(m*n);
fprintf('m=%d, n=%d, k=%d: ratio=%.4f\n', m, n, k, ratio);
fprintf('Worth when k < mn/(m+n) = %.1f\n', m*n/(m+n));
