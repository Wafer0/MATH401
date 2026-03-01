% ============================================================
% MATLAB Code for Chapter 7 - Google PageRank Exercises
% Math 401 - Applications of Linear Algebra
% Helper functions: make_gpmatrix.m, pagerank_vec.m
% ============================================================

%% Exercise 7.1
% Two pages: P1 <-> P2
disp('=== Exercise 7.1 ===');
links = [1 2; 2 1];
n = 2;
T = make_gpmatrix(links, n);
pr = pagerank_vec(T);
fprintf('(a) By symmetry, both pages should have the same pagerank.\n');
fprintf('(b) Pageranks: P1=%.4f, P2=%.4f\n', pr(1), pr(2));
fprintf('(c) No disparity: symmetric structure => equal ranks.\n\n');

%% Exercise 7.2
% 6 pages
disp('=== Exercise 7.2 ===');
% P1->P2, P1->P3, P2->P4, P3->P4, P4->P5, P5->P6, P6->P1 (cycle with split)
links = [1 2; 1 3; 2 4; 3 4; 4 5; 5 6; 6 1];
n = 6;
T = make_gpmatrix(links, n);
pr = pagerank_vec(T);
[pr_s, idx] = sort(pr,'descend');
fprintf('(b) Pageranks:\n'); for k=1:n, fprintf('  P%d: %.4f\n',k,pr(k)); end
fprintf('Ranking order: '); fprintf('P%d ', idx); fprintf('\n\n');

%% Exercise 7.3
% Remove the 15%% random jump (use d=1.0 for existing links)
disp('=== Exercise 7.3 ===');
% (a) Internet with non-regular T and no convergence
disp('(a) Example: P1->P2, P2->P1 (two pages swap). T=[0 1;1 0], non-regular, oscillates.');
T_osc = [0 1; 1 0];
fprintf('    T^2 = I: %d\n', all(all(T_osc^2 == eye(2))));
fprintf('    T^1000 * [1;0] = [%d;%d] (returns to start, does not converge)\n', ...
    (T_osc^1000)(1,1), (T_osc^1000)(2,1));
% (b) Internet where some pages get rank 0
disp('(b) Example: P1->P2, P2->P3, P3->P2 (P3 and P2 form sink, P1 has rank 0 long-term).');
links_b = [1 2; 2 3; 3 2];
T_b = make_gpmatrix(links_b, 3, 1.0);
fprintf('    T (100/0) =\n'); disp(T_b);
pr_b = pagerank_vec(T_b);
fprintf('    Pageranks: P1=%.4f, P2=%.4f, P3=%.4f\n', pr_b(1),pr_b(2),pr_b(3));
fprintf('    P1 has zero rank: all traffic leaves P1 and never returns.\n\n');

%% Exercise 7.4
% Disconnected internet: two triangles
disp('=== Exercise 7.4 ===');
links = [1 2; 2 3; 3 1; 4 5; 5 6; 6 4];
n = 6;
T = make_gpmatrix(links, n);
pr = pagerank_vec(T);
fprintf('Pageranks (two disconnected triangles):\n');
for k=1:n, fprintf('  P%d: %.4f\n',k,pr(k)); end
fprintf('Note: 15%% random jump connects the components; all 6 pages can be reached.\n\n');

%% Exercise 7.5
% Iterative method: find k with 4-decimal agreement
disp('=== Exercise 7.5 ===');
% Re-use T from Exercise 7.4
x0 = zeros(n,1); x0(1) = 1;
pr_exact = pagerank_vec(T);
for k=1:10000
    xk = T^k * x0;
    xk_prev = T^(k-1) * x0;
    if all(abs(xk - xk_prev) < 5e-5)
        fprintf('Smallest k (T^k and T^(k-1) agree to 4 decimals): %d\n\n', k);
        break;
    end
end

%% Exercise 7.6
% n pages all linking to each other: uniform pagerank
disp('=== Exercise 7.6 ===');
n = 5;
links = [];
for i=1:n, for j=1:n, if i~=j, links=[links;i j]; end; end; end
T = make_gpmatrix(links, n);
pr = pagerank_vec(T);
fprintf('For K_%d (fully connected): pageranks = ', n); fprintf('%.4f ', pr); fprintf('\n');
uniform = ones(n,1)/n;
fprintf('T * [1/n,...,1/n]: max deviation = %.2e\n', max(abs(T*uniform - uniform)));
fprintf('The uniform vector is an eigenvector for lambda=1 because:\n');
fprintf('  T = (0.15/n)*J + 0.85*(1/(n-1))*(J-I)  (all links equally distributed)\n');
fprintf('  T*(1/n)*1 = (0.15/n + 0.85/(n-1)*(n-1)/n)*1 = (1/n)*1.\n\n');

%% Exercise 7.7
% Effect of damping factor on ranking order
disp('=== Exercise 7.7 ===');
links = [1 2; 1 3; 2 3; 3 1];
n = 3;
T85 = make_gpmatrix(links, n, 0.85);
T60 = make_gpmatrix(links, n, 0.60);
T100 = make_gpmatrix(links, n, 1.00);
pr85 = pagerank_vec(T85); pr60 = pagerank_vec(T60); pr100 = pagerank_vec(T100);
fprintf('(b) 85/15: P1=%.4f P2=%.4f P3=%.4f\n', pr85(1),pr85(2),pr85(3));
fprintf('    60/40: P1=%.4f P2=%.4f P3=%.4f\n', pr60(1),pr60(2),pr60(3));
[~,o85]=sort(pr85,'descend'); [~,o60]=sort(pr60,'descend');
fprintf('    Ranking 85/15: P%d>P%d>P%d; Ranking 60/40: P%d>P%d>P%d\n', o85(1),o85(2),o85(3),o60(1),o60(2),o60(3));
fprintf('(c) 100/0 split: P1=%.4f P2=%.4f P3=%.4f\n\n', pr100(1),pr100(2),pr100(3));

%% Exercise 7.8
% 10-page internet
disp('=== Exercise 7.8 ===');
links = [1 2; 1 3; 2 4; 3 4; 3 5; 4 5; 4 6; 5 7; 6 7; 6 8; 7 9; 7 10; 8 10; 9 1; 10 1];
n = 10;
T = make_gpmatrix(links, n);
pr = pagerank_vec(T);
[pr_s, idx] = sort(pr,'descend');
fprintf('Pageranks:\n'); for k=1:n, fprintf('  P%d: %.4f\n',k,pr(k)); end
fprintf('Ranking order: '); fprintf('P%d ', idx); fprintf('\n\n');

%% Exercise 7.9
disp('=== Exercise 7.9 ===');
disp('PageRank is determined by who links TO your page, not where your page links to.');
disp('Outbound links determine where traffic flows OUT of your page.');
disp('They have no effect on how much traffic flows INTO your page.');
disp('Hence, adding or removing outbound links does not change your PageRank.');
disp('');

%% Exercise 7.10
% Chain internet P1->P2->...->Pn
disp('=== Exercise 7.10 ===');
n = 5;
links_chain = [(1:n-1)', (2:n)'];
T_chain = make_gpmatrix(links_chain, n);
fprintf('Transition matrix for chain P1->P2->...->P%d:\n', n);
disp(T_chain);
disp('Note: P_n is a dangling node (no outbound links), so it links randomly to all pages.');
disp('');

%% Exercise 7.11
disp('=== Exercise 7.11 ===');
disp('Simply counting inbound links ignores page quality:');
disp('  - A spam site might have 1000 inbound links from low-quality pages.');
disp('  - A reference paper might have 50 inbound links from high-impact journals.');
disp('Google PageRank is more reasonable because:');
disp('  1. It weights inbound links by the PageRank of the linking page.');
disp('  2. Being linked by an important page transfers more PageRank to you.');
disp('  3. This recursive definition captures the notion of "importance by association".');
disp('  4. The steady-state of the random surfer model naturally reflects this weighting.');
