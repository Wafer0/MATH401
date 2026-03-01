% ============================================================
% MATLAB Code for Chapter 6 - Markov Chains Exercises
% Math 401 - Applications of Linear Algebra
% ============================================================

%% Exercise 6.1
% 3-state system: state 1 keeps 0.80, sends 0.12->2, 0.08->3
%                 state 2 keeps 0.90, sends 0.05->1, 0.05->3
%                 state 3 keeps 0.75, sends 0.25->1
disp('=== Exercise 6.1 ===');
T = [0.80  0.05  0.25;
     0.12  0.90  0.00;
     0.08  0.05  0.75];
fprintf('(a) Transition matrix T:\n'); disp(T);
fprintf('(b) T is not symmetric. e.g., T(2,1)=%.2f but T(1,2)=%.2f.\n', T(2,1), T(1,2));
fprintf('    This means flow rate from state 1 to 2 differs from 2 to 1.\n');
x0 = [0.6; 0.2; 0.2];
x1 = T * x0; x2 = T^2 * x0;
fprintf('(c) After 1 step: [%.4f; %.4f; %.4f]\n', x1(1),x1(2),x1(3));
fprintf('    After 2 steps: [%.4f; %.4f; %.4f]\n', x2(1),x2(2),x2(3));
[V, D] = eig(T); evs = diag(D); [~, idx] = min(abs(evs - 1));
ss = real(V(:,idx)); ss = ss / sum(ss);
fprintf('(d) Steady state: [%.4f; %.4f; %.4f]\n', ss(1),ss(2),ss(3));
for k = 1:100000
    xk = T^k * x0;
    if all(abs(xk - ss) < 5e-5), fprintf('(e) Smallest k: %d\n\n', k); break; end
end

%% Exercise 6.2
% 6x6 transition matrix
disp('=== Exercise 6.2 ===');
T = [0.90  0.00  0.05  0.00  0.15  0.05;
     0.00  0.80  0.05  0.20  0.05  0.05;
     0.01  0.10  0.50  0.00  0.00  0.05;
     0.02  0.10  0.10  0.75  0.00  0.05;
     0.07  0.00  0.10  0.00  0.70  0.05;
     0.00  0.00  0.20  0.05  0.10  0.75];
fprintf('(b) Is T regular? All entries of T > 0: %s\n', mat2str(all(all(T > 0))));
fprintf('    Yes: every entry is positive, so T^1 has all positive entries.\n\n');

%% Exercise 6.3
disp('=== Exercise 6.3 ===');
T_sym = [0.6 0.2 0.2; 0.2 0.6 0.2; 0.2 0.2 0.6];
fprintf('Example: each state keeps 60%%, sends 20%% to each other.\n');
fprintf('T =\n'); disp(T_sym);
fprintf('Symmetric: %d, Regular: %d\n\n', isequal(T_sym, T_sym'), all(all(T_sym > 0)));

%% Exercise 6.4
% 6-state system (specific structure based on diagram)
disp('=== Exercise 6.4 ===');
% From the diagram: states flow mostly downward (1->3, etc.)
T = [0.80  0.00  0.00  0.00  0.00  0.00;
     0.05  0.75  0.00  0.00  0.00  0.00;
     0.15  0.10  0.70  0.00  0.00  0.00;
     0.00  0.15  0.20  0.85  0.00  0.00;
     0.00  0.00  0.10  0.15  0.90  0.05;
     0.00  0.00  0.00  0.00  0.05  0.95];
fprintf('(a) T:\n'); disp(T);
T2 = T^2;
fprintf('(b.a) T(3,2) = %.4f\n', T(3,2));
fprintf('(b.b) T^2(3,2) = %.6f\n', T2(3,2));
fprintf('(b.c) T^2(1,3) = %.6f\n', T2(1,3));
for k = 1:20
    Tk = T^k;
    if Tk(5,3) > 1e-12
        fprintf('(b.d) Smallest k with T^k(5,3)>0: k=%d, value=%.8f\n', k, Tk(5,3));
        break;
    end
end
fprintf('(b.e) T^k(i,j)=0 for all k when j in {4,5,6} and i in {1,2,3}.\n');
fprintf('(b.f) Long-term: population flows into absorbing states {4,5,6} -> steady state there.\n\n');

%% Exercise 6.5
% Find T s.t. T^7 = I but T^k != I for k<7
disp('=== Exercise 6.5 ===');
% A cyclic permutation of 7 states: 1->2->3->4->5->6->7->1
% T is the permutation matrix for this cycle
T7 = zeros(7,7);
for i=1:6, T7(i+1,i)=1; end
T7(1,7) = 1;
fprintf('Cyclic permutation on 7 states (state i -> state i+1 mod 7):\n');
fprintf('T^7 == I: %d\n', all(all(T7^7 == eye(7))));
fprintf('T^k == I for k<7: ');
for k=1:6, fprintf('k=%d: %d  ', k, all(all(T7^k == eye(7)))); end
fprintf('\n\n');

%% Exercise 6.7
% 3-state system
disp('=== Exercise 6.7 ===');
T = [0.70  0.85  0.95;
     0.28  0.05  0.02;
     0.02  0.10  0.03];
x0 = [0.1; 0; 0.9];
fprintf('(b) After 1: [%.4f;%.4f;%.4f]\n', (T*x0)(1),(T*x0)(2),(T*x0)(3));
fprintf('    After 2: [%.4f;%.4f;%.4f]\n', (T^2*x0)(1),(T^2*x0)(2),(T^2*x0)(3));
fprintf('    After 5: [%.4f;%.4f;%.4f]\n', (T^5*x0)(1),(T^5*x0)(2),(T^5*x0)(3));
[V,D] = eig(T); evs = diag(D); [~,idx] = min(abs(evs-1));
ss = real(V(:,idx)); ss = ss/sum(ss);
fprintf('(c) Steady state: [%.4f;%.4f;%.4f]\n', ss(1),ss(2),ss(3));
for k=1:100000
    xk = T^k * x0;
    if all(abs(xk-ss) < 5e-5), fprintf('(d) Smallest k: %d\n\n', k); break; end
end

%% Exercise 6.8
% Eigenvalues of T = [a 0 1-c; 1-a b 0; 0 1-b c] numerically
disp('=== Exercise 6.8 ===');
disp('Characteristic polynomial analysis (numerical for a=0.8,b=0.7,c=0.9):');
a=0.8; b=0.7; c=0.9;
T8 = [a 0 1-c; 1-a b 0; 0 1-b c];
fprintf('T =\n'); disp(T8);
evs = sort(real(eig(T8)), 'descend');
fprintf('Eigenvalues: %.6f, %.6f, %.6f\n', evs(1),evs(2),evs(3));
fprintf('lambda=1 is always an eigenvalue (column sums = 1).\n');
fprintf('The other two eigenvalues depend on a,b,c.\n\n');

%% Exercise 6.9
disp('=== Exercise 6.9 ===');
% Find a 2x2 regular T and x0 where entries of T^1000*x0 still differ from x* at 1st decimal
% Use T close to [0 1;1 0] (nearly non-regular): T=[0.01 0.99; 0.99 0.01]
T = [0.01 0.99; 0.99 0.01];
evs = sort(eig(T),'descend');
fprintf('T = [0.01 0.99; 0.99 0.01]\n');
fprintf('Eigenvalues: %.4f, %.4f\n', evs(1), evs(2));
[V,D] = eig(T); ev1 = diag(D); [~,idx] = min(abs(ev1-1));
ss = real(V(:,idx)); ss = ss/sum(ss);
fprintf('Steady state: [%.4f; %.4f]\n', ss(1),ss(2));
x0 = [1; 0];
x1000 = T^1000 * x0;
fprintf('T^1000 * [1;0] = [%.6f; %.6f]\n', x1000(1), x1000(2));
fprintf('Difference from ss at 1st decimal: ss=[0.5,0.5], T^1000*x0=[%.1f,%.1f]\n', x1000(1),x1000(2));
fprintf('(The 2nd eigenvalue is -0.98 ~ close to -1, so convergence is slow)\n\n');

%% Exercise 6.10
disp('=== Exercise 6.10 ===');
T = [0.5 0.5 0.0 0.0;
     0.5 0.5 0.0 0.0;
     0.0 0.0 0.7 0.3;
     0.0 0.0 0.3 0.7];
fprintf('Example: block diagonal T with two non-connected 2-state components:\n');
disp(T);
fprintf('States {1,2} never communicate with states {3,4}.\n\n');

%% Exercise 6.11
disp('=== Exercise 6.11 ===');
% Component 1: non-regular (oscillating), Component 2: regular (has steady state)
T = [0   1   0   0;
     1   0   0   0;
     0   0   0.6 0.4;
     0   0   0.4 0.6];
fprintf('Block diagonal T:\n  Block 1 (states 1,2): T1=[0 1;1 0] -- non-regular oscillator\n');
fprintf('  Block 2 (states 3,4): T2=[0.6 0.4;0.4 0.6] -- regular, has steady state [0.5;0.5]\n');
disp(T);
disp('');

%% Exercise 6.12
disp('=== Exercise 6.12 ===');
disp('Probability vector: a vector with nonneg entries that sum to 1.');
disp('Transition matrix: a matrix whose columns are each probability vectors.');
disp('Regular transition matrix: a transition matrix T s.t. T^k has all positive entries for some k>=1.');
disp('');

%% Exercise 6.13
disp('=== Exercise 6.13 ===');
disp('Yes. Take the cyclic permutation matrix on n states: P(i+1,i)=1 and P(1,n)=1.');
disp('Then P^k(1,2) = 0 for k=1,...,n-1 but P^n = I so P^n(1,2) = 0 too... wait.');
disp('Actually: P^k(i,j)=1 iff j -> i in exactly k steps, i.e., iff k = i-j (mod n).');
disp('For entry (2,1): P^k(2,1)=0 for k=1,...,n-1, and P^n(2,1)=0 as well (since P^n=I).');
disp('So P^1(2,1)=1: this entry is nonzero at k=1. Not the example we want.');
disp('Try entry (1,2): P^k(1,2)=1 iff k = n-1 (mod n). So (1,2) is 0 for k=1,...,n-2,');
disp('and nonzero at k=n-1. Yes! For the n-cycle, T^k(1,2)=0 for k=1,...,n-2, nonzero at k=n-1.');
fprintf('Example for n=5: T^k(1,2)=0 for k=1,2,3, nonzero at k=4 (=n-1):\n');
n=5; P=zeros(n,n);
for i=1:n-1, P(i+1,i)=1; end; P(1,n)=1;
for k=1:n, fprintf('  k=%d: T^k(1,2)=%.0f\n', k, (P^k)(1,2)); end
disp('');

%% Exercise 6.14
disp('=== Exercise 6.14 ===');
disp('(a) T = [alpha, 1-beta; 1-alpha, beta]');
disp('(b) Steady state: solve T*x=x with x1+x2=1:');
disp('    (alpha-1)*x1 + (1-beta)*x2 = 0 => x1/x2 = (1-beta)/(1-alpha)');
disp('    x1 = (1-beta)/(2-alpha-beta), x2 = (1-alpha)/(2-alpha-beta)');
disp('    (Valid when alpha+beta ~= 2)');
alpha=0.3; beta=0.4;
T14 = [alpha 1-beta; 1-alpha beta];
[V,D]=eig(T14); evs=diag(D); [~,idx]=min(abs(evs-1));
ss=real(V(:,idx)); ss=ss/sum(ss);
fprintf('Numerical check (alpha=%.1f,beta=%.1f): ss=[%.4f;%.4f]\n', alpha,beta,ss(1),ss(2));
fprintf('Formula: ss=[%.4f;%.4f]\n', (1-beta)/(2-alpha-beta), (1-alpha)/(2-alpha-beta));
disp('(c) Without restrictions: if alpha=beta=1, T=I (every vector is steady state, no unique limit).');
disp('    If alpha=0,beta=0, T=[0 1;1 0] (oscillates, no limiting steady state for most x0).');
disp('');

%% Exercise 6.15
disp('=== Exercise 6.15 ===');
disp('Claim: If T^k has all positive entries, then T^j for j > k also has all positive entries.');
disp('Proof: Write j = k + m for some m >= 1. Then T^j = T^m * T^k.');
disp('Since T^k > 0 (entrywise) and T^m >= 0 (nonneg) with column sums = 1 (at least one');
disp('positive entry per column), the product T^m * T^k has all positive entries.');
disp('More explicitly: (T^j)_{ij} = sum_l (T^m)_{il} * (T^k)_{lj}.');
disp('Each term (T^k)_{lj} > 0, so the sum is positive as long as (T^m)_{il} > 0 for some l.');
disp('Since T is a transition matrix, at least one entry per column is positive, hence T^m has');
disp('at least one positive entry per column, giving (T^j)_{ij} > 0.');
