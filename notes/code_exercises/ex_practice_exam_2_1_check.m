% ============================================================
% Octave verification for Practice Exam 2.1 solutions
% Math 401 - Spectral Theorem / SVD / Image Compression / Quantum
% ============================================================

format short g
i = 1i;
tol = 1e-10;

function ok = approx_equal(a, b, tol)
  ok = norm(a - b) < tol;
end

function report_check(label, value)
  if value
    fprintf('[OK]   %s\n', label);
  else
    fprintf('[FAIL] %s\n', label);
  end
end

function report_scalar(label, value)
  fprintf('  %s: %.10f\n', label, value);
end

function report_vector(label, v)
  fprintf('  %s = [', label);
  fprintf(' %.6f', v(:));
  fprintf(' ]\n');
end

function check_svd(label, A, Uc, Sc, Vc, sv_expected, tol)
  fprintf('\n=== %s ===\n', label);
  [U, S, V] = svd(A);
  sv_actual = diag(S);

  report_vector('expected singular values', sv_expected);
  report_vector('actual singular values', sv_actual);
  report_check('singular values match', approx_equal(sv_actual, sv_expected, tol));
  report_check('candidate U orthogonal', approx_equal(Uc' * Uc, eye(columns(Uc)), tol));
  report_check('candidate V orthogonal', approx_equal(Vc' * Vc, eye(columns(Vc)), tol));
  report_check('candidate decomposition reconstructs A', approx_equal(Uc * Sc * Vc', A, tol));
end

ket0 = [1; 0];
ket1 = [0; 1];
ket_plus = (ket0 + ket1) / sqrt(2);
ket_minus = (ket0 - ket1) / sqrt(2);
ket_i = (ket0 + i * ket1) / sqrt(2);
ket_mi = (ket0 - i * ket1) / sqrt(2);
braket = @(a, b) a' * b;
same_state = @(a, b) (norm(a) > 0 && norm(b) > 0 && ...
  abs(abs(a' * b) / (norm(a) * norm(b)) - 1) < 1e-8);

disp('=== Spectral Theorem spot checks ===');
v = [2; 1];
P_bad = v * v';
report_check('2.1.29 corrected: vv^T is not idempotent for non-unit v', ...
  !approx_equal(P_bad * P_bad, P_bad, tol));
u = v / norm(v);
P_good = u * u';
report_check('unit-vector version gives a projection matrix', ...
  approx_equal(P_good * P_good, P_good, tol));

A_sym = [2 1; 1 5];
B = [1 2 0; -1 3 4];
report_check('2.1.34: B^T A B is symmetric', ...
  approx_equal((B' * A_sym * B)', B' * A_sym * B, tol));
report_check('2.1.34: B^T B is symmetric', ...
  approx_equal((B' * B)', B' * B, tol));
report_check('2.1.34: B B^T is symmetric', ...
  approx_equal((B * B')', B * B', tol));

disp(' ');
disp('=== SVD exercises 5-12 ===');

check_svd('Exercise 5', ...
  [-2 0; 0 0], ...
  [-1 0; 0 1], ...
  [2 0; 0 0], ...
  eye(2), ...
  [2; 0], tol);

check_svd('Exercise 6', ...
  [-3 0; 0 -2], ...
  [-1 0; 0 -1], ...
  [3 0; 0 2], ...
  eye(2), ...
  [3; 2], tol);

check_svd('Exercise 7', ...
  [2 -1; 2 2], ...
  [1/sqrt(5) 2/sqrt(5); 2/sqrt(5) -1/sqrt(5)], ...
  [3 0; 0 2], ...
  [2/sqrt(5) 1/sqrt(5); 1/sqrt(5) -2/sqrt(5)], ...
  [3; 2], tol);

check_svd('Exercise 8', ...
  [4 6; 0 4], ...
  [2/sqrt(5) -1/sqrt(5); 1/sqrt(5) 2/sqrt(5)], ...
  [8 0; 0 2], ...
  [1/sqrt(5) -2/sqrt(5); 2/sqrt(5) 1/sqrt(5)], ...
  [8; 2], tol);

check_svd('Exercise 9', ...
  [3 -3; 0 0; 1 1], ...
  [1 0 0; 0 0 1; 0 1 0], ...
  [3 * sqrt(2) 0; 0 sqrt(2); 0 0], ...
  [1/sqrt(2) 1/sqrt(2); -1/sqrt(2) 1/sqrt(2)], ...
  [3 * sqrt(2); sqrt(2)], tol);

check_svd('Exercise 10', ...
  [7 1; 5 5; 0 0], ...
  [1/sqrt(2) 1/sqrt(2) 0; 1/sqrt(2) -1/sqrt(2) 0; 0 0 1], ...
  [3 * sqrt(10) 0; 0 sqrt(10); 0 0], ...
  [2/sqrt(5) 1/sqrt(5); 1/sqrt(5) -2/sqrt(5)], ...
  [3 * sqrt(10); sqrt(10)], tol);

check_svd('Exercise 11', ...
  [-3 1; 6 -2; 6 -2], ...
  [-1/3 2/3 2/3; 2/3 -1/3 2/3; 2/3 2/3 -1/3], ...
  [3 * sqrt(10) 0; 0 0; 0 0], ...
  [3/sqrt(10) 1/sqrt(10); -1/sqrt(10) 3/sqrt(10)], ...
  [3 * sqrt(10); 0], tol);

check_svd('Exercise 12', ...
  [1 1; 0 1; -1 1], ...
  [1/sqrt(3) 1/sqrt(2) 1/sqrt(6); 1/sqrt(3) 0 -2/sqrt(6); 1/sqrt(3) -1/sqrt(2) 1/sqrt(6)], ...
  [sqrt(3) 0; 0 sqrt(2); 0 0], ...
  [0 1; 1 0], ...
  [sqrt(3); sqrt(2)], tol);

disp(' ');
disp('=== Exercise 14 ===');
A7 = [2 -1; 2 2];
x = [2; 1] / sqrt(5);
report_scalar('||x||', norm(x));
report_scalar('||A7*x||', norm(A7 * x));
report_check('Exercise 14 maximum length equals sigma_1 = 3', ...
  approx_equal(norm(A7 * x), 3, tol));

disp(' ');
disp('=== Exercise 15 ===');
U15 = [0.40 -0.78 0.47; 0.37 -0.33 -0.87; -0.84 -0.52 -0.16];
S15 = diag([7.10 3.10 0]);
VT15 = [0.30 -0.51 -0.81; 0.76 0.64 -0.12; 0.58 -0.58 0.58];
V15 = VT15';
A15 = U15 * S15 * VT15;
v3 = V15(:, 3);
report_check('U columns are approximately orthonormal', approx_equal(U15' * U15, eye(3), 2e-2));
report_check('V columns are approximately orthonormal', approx_equal(V15' * V15, eye(3), 2e-2));
report_check('rank(A) from singular values is 2', rank(A15, 1e-8) == 2);
report_check('listed null-space basis vector is in Nul(A)', norm(A15 * v3) < 2e-2);

disp(' ');
disp('=== Image Compression 10.1 and 10.6 ===');
Aimg = [1 0.5 1 0; 0.5 1 0 1; 0.5 0.5 1 1; 1 0 0 0.5];
simg = svd(Aimg);
report_vector('10.1 singular values', simg);
q3 = sum(simg(1:3).^2) / sum(simg.^2);
q2 = sum(simg(1:2).^2) / sum(simg.^2);
q1 = sum(simg(1:1).^2) / sum(simg.^2);
report_scalar('quality k=3', q3);
report_scalar('quality k=2', q2);
report_scalar('quality k=1', q1);
report_check('10.1 quality values match LaTeX rounded values', ...
  abs(q3 - 0.9638) < 5e-4 && abs(q2 - 0.8793) < 5e-4 && abs(q1 - 0.7278) < 5e-4);

m = 200; n = 150; k = 30;
ratio_exact = k * (m + n + 1) / (m * n);
ratio_approx = k * (m + n) / (m * n);
report_scalar('10.6 exact ratio for m=200, n=150, k=30', ratio_exact);
report_scalar('10.6 approximate ratio for m=200, n=150, k=30', ratio_approx);
report_check('10.6 worthwhile criterion holds for k=30', k < m * n / (m + n + 1));

disp(' ');
disp('=== Quantum Information 2.2 ===');
psi_c = (-ket0 + i * ket1) / sqrt(2);
psi_d1 = ket_plus;
psi_d2 = ket_minus;
psi_f = (-ket0 + i * ket1) / sqrt(2);
psi_g = (ket_plus + ket_minus) / sqrt(2);
psi_h = (ket_i - ket_mi) / sqrt(2);
psi_i1 = (ket_i + ket_mi) / sqrt(2);
psi_i2 = (ket_minus + ket_plus) / sqrt(2);
psi_j1 = (ket0 + exp(i * pi / 4) * ket1) / sqrt(2);
psi_j2 = (exp(-i * pi / 4) * ket0 + ket1) / sqrt(2);

report_check('2.2(a) same state', same_state(ket0, -ket0));
report_check('2.2(b) same state', same_state(ket1, i * ket1));
report_check('2.2(c) different state', !same_state(ket_plus, psi_c));
report_check('2.2(d) different state', !same_state(psi_d1, psi_d2));
report_check('2.2(e) same state', same_state((ket0 - ket1) / sqrt(2), (ket1 - ket0) / sqrt(2)));
report_check('2.2(f) different state', !same_state(ket_i, psi_f));
report_check('2.2(g) same state', same_state(psi_g, ket0));
report_check('2.2(h) same state', same_state(psi_h, ket1));
report_check('2.2(i) same state', same_state(psi_i1, psi_i2));
report_check('2.2(j) same state', same_state(psi_j1, psi_j2));
report_scalar('2.2(c) P(+ | second state)', abs(braket(ket_plus, psi_c))^2);

disp(' ');
disp('=== Quantum Information 2.3 and 2.4 ===');
psi_23d = sqrt(3) / 2 * ket_plus - 1 / 2 * ket_minus;
report_vector('2.3(d) standard-basis coefficients', psi_23d);
report_check('2.3(e) equals i|1>', same_state((ket_i - ket_mi) / sqrt(2), i * ket1));
report_scalar('2.4(b) coeff of |+> in |0>', abs(braket(ket_plus, ket0)));
report_scalar('2.4(c) coeff of |-> in |1>', abs(braket(ket_minus, ket1)));

disp(' ');
disp('=== Quantum Information 2.6 ===');
psi_a = sqrt(3) / 2 * ket0 - 1 / 2 * ket1;
psi_b = sqrt(3) / 2 * ket1 - 1 / 2 * ket0;
ket_u = 1 / 2 * ket0 + sqrt(3) / 2 * ket1;
ket_v = sqrt(3) / 2 * ket0 - 1 / 2 * ket1;

report_scalar('2.6(a) P(|0>)', abs(braket(ket0, psi_a))^2);
report_scalar('2.6(a) P(|1>)', abs(braket(ket1, psi_a))^2);
report_scalar('2.6(b) P(|0>)', abs(braket(ket0, psi_b))^2);
report_scalar('2.6(b) P(|1>)', abs(braket(ket1, psi_b))^2);
report_scalar('2.6(c) P(|0>)', abs(braket(ket0, ket_mi))^2);
report_scalar('2.6(c) P(|1>)', abs(braket(ket1, ket_mi))^2);
report_scalar('2.6(d) P(|+>)', abs(braket(ket_plus, ket0))^2);
report_scalar('2.6(d) P(|->)', abs(braket(ket_minus, ket0))^2);
report_scalar('2.6(e) P(|i>)', abs(braket(ket_i, ket_minus))^2);
report_scalar('2.6(e) P(|-i>)', abs(braket(ket_mi, ket_minus))^2);
report_scalar('2.6(f) P(|i>)', abs(braket(ket_i, ket1))^2);
report_scalar('2.6(f) P(|-i>)', abs(braket(ket_mi, ket1))^2);
report_scalar('2.6(g) P(u)', abs(braket(ket_u, ket_plus))^2);
report_scalar('2.6(g) P(v)', abs(braket(ket_v, ket_plus))^2);
report_check('2.6(g) exact formulas match', ...
  abs(abs(braket(ket_u, ket_plus))^2 - (2 + sqrt(3)) / 4) < tol && ...
  abs(abs(braket(ket_v, ket_plus))^2 - (2 - sqrt(3)) / 4) < tol);

disp(' ');
disp('Verification complete.');
