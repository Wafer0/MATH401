% ============================================================
% Octave: SP5 / Rieffel-Polak Ch.2 - single-qubit checks
% Math 401 - complex inner products, Born rule
% ============================================================

i = 1i;
ket0 = [1; 0];
ket1 = [0; 1];
ket_plus  = (ket0 + ket1) / sqrt(2);
ket_minus = (ket0 - ket1) / sqrt(2);
ket_i  = (ket0 + i*ket1) / sqrt(2);
ket_mi = (ket0 - i*ket1) / sqrt(2);

braket = @(a, b) a' * b;

disp('=== Rieffel 2.2: orthogonality / overlap checks ===');
psi_c = (-ket0 + i*ket1) / sqrt(2);
fprintf('|<<i|psi>>| (2.2c second): %.6f\n', abs(braket(ket_i, psi_c)));
fprintf('|<<+|psi>>|^2 for |+> vs (2.2c second): %.6f vs %.6f\n', ...
  abs(braket(ket_plus, ket_plus))^2, abs(braket(ket_plus, psi_c))^2);

disp(' ');
disp('=== Rieffel 2.3-2.4: basis expansion checks ===');
psi_d = sqrt(3)/2 * ket_plus - 1/2 * ket_minus;
fprintf('2.3(d) in standard basis = [%.6f; %.6f]\n', psi_d(1), psi_d(2));
psi_e = (ket_i - ket_mi) / sqrt(2);
fprintf('2.3(e) proportional to |1>: residual norm = %.6e\n', ...
  min(norm(psi_e - i*ket1), norm(psi_e + i*ket1)));
fprintf('|0> in Hadamard basis coeffs = [%.6f; %.6f]\n', ...
  braket(ket_plus, ket0), braket(ket_minus, ket0));
fprintf('|1> in Hadamard basis coeffs = [%.6f; %.6f]\n', ...
  braket(ket_plus, ket1), braket(ket_minus, ket1));

disp(' ');
disp('=== Rieffel 2.6: Born probabilities ===');

function print_probs(name, psi, basis)
  fprintf('%s (norm=%.6f)\n', name, norm(psi));
  for k = 1:numel(basis)
    b = basis{k};
    pk = abs(b' * psi)^2;
    fprintf('  P(%d) = %.6f\n', k, pk);
  end
end

psi_a = sqrt(3)/2 * ket0 - 1/2 * ket1;
print_probs('(a)', psi_a, {ket0, ket1});

psi_b = sqrt(3)/2 * ket1 - 1/2 * ket0;
print_probs('(b)', psi_b, {ket0, ket1});

print_probs('(c)', ket_mi, {ket0, ket1});

print_probs('(d)', ket0, {ket_plus, ket_minus});

print_probs('(e)', ket_minus, {ket_i, ket_mi});

print_probs('(f)', ket1, {ket_i, ket_mi});

ket_u = 1/2 * ket0 + sqrt(3)/2 * ket1;
ket_v = sqrt(3)/2 * ket0 - 1/2 * ket1;
print_probs('(g) |+> in {u,v}', ket_plus, {ket_u, ket_v});
fprintf('  theory P(u)=(2+sqrt(3))/4 = %.6f\n', (2+sqrt(3))/4);
fprintf('  theory P(v)=(2-sqrt(3))/4 = %.6f\n', (2-sqrt(3))/4);

disp(' ');
