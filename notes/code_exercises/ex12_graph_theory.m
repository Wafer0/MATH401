% ============================================================
% MATLAB Code for Chapter 12 - Graph Theory Exercises
% Math 401 - Applications of Linear Algebra
% Helper functions: make_adj.m, make_lap.m, fiedler_vec.m
% ============================================================

%% Exercise 12.1
% Graph: 1-2, 1-3, 2-3, 3-4 (triangle with pendant at vertex 3)
disp('=== Exercise 12.1 ===');
edges = [1 2; 1 3; 2 3; 3 4];
n = 4;
A = make_adj(edges, n);
A3 = A^3; A20 = A^20;
fprintf('(a) Walks of length 3 from v1 to v3: %d\n', A3(1,3));
fprintf('(b) Walks of length 20 from v2 to v4: %d\n', A20(2,4));
fprintf('(c) Walks of length 3 from v4 to v4: %d\n', A3(4,4));
disp('(c) Intuition: v4 has only one neighbor (v3). A walk v4->v3->?->v4');
disp('    would need to return to v4 in one step, but from neighbors of v3');
disp('    (v1,v2) we cannot reach v4. So no walk of length 3 returns to v4.');
disp('');

%% Exercise 12.2
% Cycle graph C5: 1-2-3-4-5-1
disp('=== Exercise 12.2 ===');
edges = [1 2; 2 3; 3 4; 4 5; 5 1];
n = 5;
A = make_adj(edges, n);
fprintf('(a) Walks of length 3 from v1 to v2: %d\n', (A^3)(1,2));
fprintf('(b) Walks of length 10 from v2 to v4: %d\n', (A^10)(2,4));
fprintf('(c) Walks v3->v5, even k: ');
for k = [2 4 6 8 10], fprintf('k=%d:%d  ', k, (A^k)(3,5)); end
fprintf('\n    Increasing: more paths become available as k grows.\n');
fprintf('(d) Walks v2->v4, odd k: ');
for k = [1 3 5 7 9], fprintf('k=%d:%d  ', k, (A^k)(2,4)); end
fprintf('\n    Increasing similarly.\n\n');

%% Exercise 12.3
disp('=== Exercise 12.3 ===');
disp('For triangles: the ONLY closed walk of length 3 is a triangle (no shortcuts).');
disp('For squares: a closed walk of length 4 can also be a backtrack (v->u->v->u->v)');
disp('or use triangle edges, so tr(A^4) includes non-square contributions.');
disp('For pentagons (and beyond): similar issue -- many other closed walks of that length exist.');
disp('This is why only the triangle count (length 3) works cleanly as tr(A^3)/6.');
disp('');

%% Exercise 12.4
% Graph: 1-2, 1-3, 2-3, 3-4
disp('=== Exercise 12.4 ===');
edges = [1 2; 1 3; 2 3; 3 4];
n = 4;
A = make_adj(edges, n);
L = make_lap(A);
fprintf('Laplacian L:\n'); disp(L);
[fv, lam2] = fiedler_vec(L);
fprintf('Fiedler value lambda_2 = %.4f\n', lam2);
fprintf('Fiedler vector: [%.4f; %.4f; %.4f; %.4f]\n', fv(1),fv(2),fv(3),fv(4));
neg_v = find(fv < -1e-10); pos_v = find(fv > 1e-10); zer_v = find(abs(fv) <= 1e-10);
fprintf('V- = {%s}, V0 = {%s}, V+ = {%s}\n', num2str(neg_v'), num2str(zer_v'), num2str(pos_v'));
disp('(a) Intuitively: partition ({1,2},{3,4}) -- triangle group vs pendant vertex');
disp('(b) Fiedler method agrees');
disp('');

%% Exercise 12.5
% Two triangles sharing vertex 3
disp('=== Exercise 12.5 ===');
edges = [1 2; 1 3; 2 3; 3 4; 3 5; 4 5];
n = 5;
A = make_adj(edges, n);
L = make_lap(A);
[fv, lam2] = fiedler_vec(L);
fprintf('Fiedler value: %.4f\n', lam2);
fprintf('Fiedler vector: [%.4f; %.4f; %.4f; %.4f; %.4f]\n', fv(1),fv(2),fv(3),fv(4),fv(5));
neg_v = find(fv < -1e-10); pos_v = find(fv > 1e-10); zer_v = find(abs(fv) <= 1e-10);
fprintf('V- = {%s}, V0 = {%s}, V+ = {%s}\n\n', num2str(neg_v'), num2str(zer_v'), num2str(pos_v'));

%% Exercise 12.6
disp('=== Exercise 12.6 ===');
fv = [-0.195; -0.632; -0.195; 0.512; 0.512];
fprintf('Given Fiedler vector: [%.3f; %.3f; %.3f; %.3f; %.3f]\n', fv(1),fv(2),fv(3),fv(4),fv(5));
fprintf('Partition: ({1,2,3}, {4,5})\n\n');

%% Exercise 12.8
disp('=== Exercise 12.8 ===');
disp('G2 (linear chain 1-2-3-4-5-6) -> v = [-0.56,-0.41,-0.15,0.15,0.41,0.56] (monotone)');
disp('G1 (symmetric 2-wing structure) -> w = [0.46,0.46,0.26,-0.26,-0.46,-0.46]');
disp('G3 (asymmetric structure)       -> x = [0.32,0.51,0.32,-0.12,-0.51,-0.51]');
disp('');

%% Exercise 12.13
disp('=== Exercise 12.13 ===');
fprintf('Laplacian eigenvalues for K_n:\n');
for n = [3 4 5 6 7]
    A = ones(n,n) - eye(n);
    L = diag(sum(A)) - A;
    evs = sort(real(eig(L)));
    fprintf('  K_%d: ', n); fprintf('%.1f ', evs); fprintf('\n');
end
disp('Pattern: eigenvalue 0 (multiplicity 1) and n (multiplicity n-1).');
disp('');

%% Exercise 12.18 (LAN with 10 computers)
disp('=== Exercise 12.18 ===');
% C1-C8,C9,C10; C2-C5,C6; C3-C4,C9; C4-C3,C9; C5-C2,C7; C6-C2,C7,C8; C7-C5,C6; C8-C1,C6,C10; C9-C1,C3,C4; C10-C1,C8
edges = [1 8; 1 9; 1 10; 2 5; 2 6; 3 4; 3 9; 4 9; 5 7; 6 7; 6 8; 8 10];
n = 10;
A = make_adj(edges, n);
L = make_lap(A);
fprintf('(a) Laplacian:\n'); disp(L);
[fv, lam2] = fiedler_vec(L);
fprintf('Fiedler value: %.4f\n', lam2);
[fv_sorted, sort_idx] = sort(fv);
fprintf('(b) Sorted Fiedler vector:\n');
for k = 1:n, fprintf('  C%d: %8.4f\n', sort_idx(k), fv_sorted(k)); end
neg_v = find(fv < 0); pos_v = find(fv > 0);
fprintf('(c) Partition: Group1={C%s}, Group2={C%s}\n\n', strtrim(num2str(neg_v')), strtrim(num2str(pos_v')));

%% SP3 Exam: Permutation matrices and graph isomorphism
disp('=== SP3 Exam: Adjacency Matrix & Isomorphism ===');
fprintf('(a) Number of 3x3 permutation matrices = 3! = 6\n');
A1 = [0 1 1; 1 0 1; 1 1 0];  % Triangle (K3)
A2 = [0 1 0; 1 0 1; 0 1 0];  % Path on 3 nodes
perms_idx = perms([1 2 3]);
any_equal = false;
fprintf('(b) Checking P*A2*P^T == A1 for each permutation:\n');
for k = 1:size(perms_idx,1)
    P = zeros(3,3);
    for i=1:3, P(i, perms_idx(k,i)) = 1; end
    PAP = P * A2 * P';
    eq = all(all(PAP == A1));
    fprintf('  perm=[%d %d %d]: equal=%d\n', perms_idx(k,1),perms_idx(k,2),perms_idx(k,3), eq);
    if eq, any_equal = true; end
end
if ~any_equal
    disp('  => No permutation makes them equal: graphs are NOT isomorphic.');
end
t1 = trace(A1^3)/6; t2 = trace(A2^3)/6;
fprintf('(c) Triangles: Triangle-graph=%d, Path-graph=%d => Not isomorphic.\n\n', round(t1), round(t2));
