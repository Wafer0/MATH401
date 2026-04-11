% ============================================================
% Octave: SP6 - Justin Ch.13 stream cipher + recursive keys
% Math 401
% ============================================================

% --- helpers as script blocks (no nested functions for Octave compatibility) ---

disp('=== Justin 13.1: ciphertext ===');
p1 = [1 0 1 1 0 1 0 0 0 1 0 1 0 0 1 0 1];
k1 = [1 0 1 1 1];
L1 = numel(p1);
krep1 = k1(mod((0:L1-1), numel(k1)) + 1);
c1 = mod(p1 + krep1, 2);
fprintf('Plaintext:  '); fprintf('%d', p1); fprintf('\n');
fprintf('Key (rep):  '); fprintf('%d', krep1); fprintf('\n');
fprintf('Ciphertext: '); fprintf('%d', c1); fprintf('\n');

disp(' ');
disp('=== Justin 13.2: ciphertext ===');
p2 = [1 1 0 1 1 0 1 0 0 1 0 0 0 0 0 1 0 1 1 0 0 1 0 1];
k2 = [1 1 0 1 0 1];
L2 = numel(p2);
krep2 = k2(mod((0:L2-1), numel(k2)) + 1);
c2 = mod(p2 + krep2, 2);
fprintf('Ciphertext: '); fprintf('%d', c2); fprintf('\n');

disp(' ');
disp('=== Recursive key (Justin Def 13.5.0.1): x_n = x_{n-i} + sum c_j x_{n-i+j-1} ===');
% i=4: x_n = x_{n-4} + c2*x_{n-3} + c3*x_{n-2} + c4*x_{n-1}
s3 = [1 1 0 0];
c3 = [1 0 0 1];
i = numel(s3);
nbits = 200;
bits3 = zeros(1, nbits);
bits3(1:i) = s3;
for n = i+1:nbits
  bits3(n) = mod(bits3(n-i) + c3(2:end) * bits3(n-i+1:n-1)', 2);
end
fprintf('13.3 first 30: '); fprintf('%d', bits3(1:30)); fprintf('\n');
% period
for T = 1:100
  if all(bits3(1:nbits-T) == bits3(T+1:nbits))
    fprintf('13.3 period T=%d (from first 200 bits)\n', T);
    break;
  end
end

s4 = [1 0 1 1];
c4 = [1 0 0 1];
bits4 = zeros(1, nbits);
bits4(1:4) = s4;
for n = 5:nbits
  bits4(n) = mod(bits4(n-4) + c4(2:end) * bits4(n-3:n-1)', 2);
end
fprintf('13.4 first 30: '); fprintf('%d', bits4(1:30)); fprintf('\n');
for T = 1:100
  if all(bits4(1:nbits-T) == bits4(T+1:nbits))
    fprintf('13.4 period T=%d\n', T);
    break;
  end
end

disp(' ');
disp('=== Brute-force shortest linear recursion (quiz 13.5) ===');
f5 = [1 0 1 1 1 0 0 1 0 1];
L = numel(f5);
found = false;
for i = 2:min(L-1, 12)
  for mask = 0:(2^(i-1)-1)
    c = zeros(1, i);
    c(1) = 1;
    for t = 2:i
      c(t) = bitget(mask, t-1);
    end
    ok = true;
    for n = i+1:L
      pred = mod(f5(n-i) + c(2:i) * f5(n-i+1:n-1)', 2);
      if pred ~= f5(n)
        ok = false;
        break;
      end
    end
    if ok
      fprintf('13.5: length i=%d, c=[', i);
      fprintf('%d ', c);
      fprintf(']\n');
      found = true;
      break;
    end
  end
  if found
    break;
  end
end

disp('=== Brute force 13.6 ===');
f6 = [0 0 1 1 1 0 1 0 0 1];
L = numel(f6);
found = false;
for i = 2:min(L-1, 12)
  for mask = 0:(2^(i-1)-1)
    c = zeros(1, i);
    c(1) = 1;
    for t = 2:i
      c(t) = bitget(mask, t-1);
    end
    ok = true;
    for n = i+1:L
      pred = mod(f6(n-i) + c(2:i) * f6(n-i+1:n-1)', 2);
      if pred ~= f6(n)
        ok = false;
        break;
      end
    end
    if ok
      fprintf('13.6: length i=%d, c=[', i);
      fprintf('%d ', c);
      fprintf(']\n');
      found = true;
      break;
    end
  end
  if found
    break;
  end
end

disp(' ');
disp('=== Rieffel 3.5: (|0>|+> + |1>|->)/sqrt(2) in comp. basis |00>,|01>,|10>,|11> ===');
psi = [1/2; 1/2; 1/2; -1/2];
fprintf('Coeffs: %.4f %.4f %.4f %.4f  (norm^2=%.6f)\n', psi, sum(psi.^2));

disp(' ');
disp('Done.');
