% ============================================================
% MATLAB Code for Chapter 5 - Team Ranking (Massey's Method)
% Math 401 - Applications of Linear Algebra
% ============================================================

%% Exercise 5.1
% 4 teams: T1 beats T2 by 7, T1 beats T3 by -8, T2 beats T3 by 0,
%          T2 beats T3 by 15, T2 beats T4 by 5, T3 beats T4 by -1
% Games: T1-T2(1), T1-T3(1), T2-T3(2), T2-T4(1), T3-T4(1)
% Degrees: T1=2, T2=4, T3=4, T4=2
disp('=== Exercise 5.1 ===');
M = [2 -1 -1  0;
    -1  4 -2 -1;
    -1 -2  4 -1;
     1  1  1  1];
q = [7 + (-8);          % T1: beats T2 by 7, loses to T3 by 8
    -7 + 0 + 15 + 5;    % T2: loses to T1 by 7, ties T3, beats T3 by 15, beats T4 by 5
     8 + 0 - 15 - 1;    % T3: beats T1 by 8, ties T2, loses T2 by 15, loses T4 by 1
     0];                 % constraint: sum of rankings = 0
r = M \ q;
fprintf('Rankings: T1=%.4f, T2=%.4f, T3=%.4f, T4=%.4f\n', r(1),r(2),r(3),r(4));
fprintf('(b) T1 vs T4 expected score diff: %.4f (T1 wins if positive)\n\n', r(1)-r(4));

%% Exercise 5.2
% T1 beats T2 by 17, T1 beats T3 by 21, T2 beats T3 by 10 and 0,
% T2 beats T4 by -14, T3 beats T4 by 8
disp('=== Exercise 5.2 ===');
M = [2 -1 -1  0;
    -1  4 -2 -1;
    -1 -2  4 -1;
     1  1  1  1];
q = [17 + 21;            % T1: +17+21
    -17 + 10 + 0 - 14;  % T2: -17+10+0-14
    -21 - 10 - 0 + 8;   % T3: -21-10-0+8
     0];
r = M \ q;
fprintf('Rankings: T1=%.4f, T2=%.4f, T3=%.4f, T4=%.4f\n', r(1),r(2),r(3),r(4));
fprintf('(b) T2 vs T4 expected score diff: %.4f\n\n', r(2)-r(4));

%% Exercise 5.3
% Given Massey matrix equation - read off structural info
disp('=== Exercise 5.3 ===');
M = [3 -1 -2  0;
    -1  4 -2 -1;
    -2 -2  4  0;
     1  1  1  1];
q = [6; 2; 10; 0];
r = M \ q;
fprintf('(a) Number of teams: 4\n');
fprintf('(b) Games T4 played: 1 (only against T2, since |m_{24}|=1)\n');
fprintf('(c) T1 played 3 games: against T2(1), T3(2) [since m12=-1, m13=-2]\n');
fprintf('(d) Total games = (sum of diagonal)/2 = (%d)/2 = %d\n', 3+4+4, (3+4+4)/2);
fprintf('Rankings: T1=%.4f, T2=%.4f, T3=%.4f, T4=%.4f\n\n', r(1),r(2),r(3),r(4));

%% Exercise 5.4
% Before replacing final row: show sum of diagonal entries is even.
disp('=== Exercise 5.4 ===');
disp('Before replacing final row, M = A^T*A.');
disp('The diagonal entry m_{ii} = number of games team i played.');
disp('Sum of diagonal = sum of all teams'' game counts = 2 * (total games).');
disp('Since each game involves exactly 2 teams, it is counted twice.');
disp('Hence the sum of diagonal = 2*G (where G = total games) => always even.');
disp('');

%% Exercise 5.5
% 4 teams with home advantage.
% (a) Ignore home: T1 beats T2 by 5, T1 beats T3 by 10, T2 beats T3 by -10 and 7,
%                  T2 beats T4 by -14, T3 beats T4 by 21
disp('=== Exercise 5.5 ===');
M = [2 -1 -1  0;
    -1  4 -2 -1;
    -1 -2  4 -1;
     1  1  1  1];
q_a = [5 + 10;            % T1: +5+10
      -5 - 10 + 7 - 14;   % T2: -5-10+7-14
      -10 - 7 + 21;       % T3 (fix sign for T2 vs T3)
       0];
% T3: loses to T1 by 10 (-10), loses to T2 by 7 when T2 wins by 7 (-7), beats T4 by 21 (+21)
q_a = [5 + 10; -5 + (-10) + 7 + (-14); 10 + (-7) + 21; 0];
% Hmm: T1 beats T2 by 5, T1 beats T3 by 10, T2 beats T3 by -10 (T3 beats T2 by 10)
% T2 beats T3 by 7, T2 beats T4 by -14 (T4 beats T2 by 14), T3 beats T4 by 21
% T1: +5+10=15; T2: -5+(-10)+7-14=-22; T3: -10+10-7+21=14; T4: 14-21=-7 check:15-22+14-7=0 ok
q_a = [15; -22; 14; 0];
r_a = M \ q_a;
fprintf('(a) Rankings (no home): T1=%.4f, T2=%.4f, T3=%.4f, T4=%.4f\n', r_a(1),r_a(2),r_a(3),r_a(4));

% (b) With home advantage: home wins reduced by 25%
% T1 home, beats T2 by 5 -> 5*0.75=3.75
% T3 home, T1 beats T3 by 10 -> T3 home but loses, no reduction -> stays 10
% T2 home, T2 beats T3 by -10 -> T2 home but loses -> no reduction -> stays -10
% T3 home, T2 beats T3 by 7 -> T3 home but T2 wins -> no reduction -> stays 7
% T2 home, T2 beats T4 by -14 -> T2 home but loses -> no reduction -> stays -14
% T3 home, T3 beats T4 by 21 -> T3 wins at home -> 21*0.75=15.75
q_b = [3.75 + 10; -3.75 + (-10) + 7 + (-14); -10 - 7 + 15.75; 0];
% T1: +3.75+10=13.75; T2: -3.75-10+7-14=-20.75; T3: -10-7+15.75=-1.25; T4: 14-15.75=-1.75 check sum
fprintf('Check sum: %.2f\n', 13.75 - 20.75 - 1.25 - (-14 - 15.75));
r_b = M \ q_b;
fprintf('(b) Rankings (with home): T1=%.4f, T2=%.4f, T3=%.4f, T4=%.4f\n', r_b(1),r_b(2),r_b(3),r_b(4));
fprintf('Rankings changed from (a) to (b).\n\n');

%% Exercise 5.6
% Show T1 beats T2 by k, T2 beats T3 by k, T3 beats T1 by k => equal rankings
disp('=== Exercise 5.6 ===');
k = 7;  % arbitrary nonzero k
M = [2 -1 -1; -1 2 -1; 1 1 1];
q = [k - k; -k + k; 0];  % T1: +k (beats T2) - k (loses T3) = 0
                          % T2: -k + k = 0; T3: +k - k = 0
r = M \ q;
fprintf('With k=%d: rankings = [%.4f, %.4f, %.4f] (all equal = 0)\n\n', k, r(1),r(2),r(3));

%% Exercise 5.9 and 5.10
% Is it better to beat a team twice by 1 or once by 2?
disp('=== Exercise 5.10 ===');
% (a) T1 beats T2 by 3, T2 beats T3 by 2, T1 beats T3 by 2
M_a = [2 -1 -1; -1 2 -1; 1 1 1];
q_a = [3+2; -3+2; -2-2];
r_a = M_a \ q_a;
fprintf('(a) [T1 beats T3 once by 2]: r=[%.4f; %.4f; %.4f]\n', r_a(1),r_a(2),r_a(3));

% (b) T1 beats T2 by 3, T2 beats T3 by 2, T1 beats T3 by 1 (twice)
M_b = [3 -1 -2; -1 2 -1; 1 1 1];
q_b = [3+1+1; -3+2; -1-1-2];
r_b = M_b \ q_b;
fprintf('(b) [T1 beats T3 twice by 1]: r=[%.4f; %.4f; %.4f]\n', r_b(1),r_b(2),r_b(3));
fprintf('(c) Conclusion: Beating twice by 1 gives T1 ranking %.4f vs %.4f. %s\n\n', ...
    r_b(1), r_a(1), 'Twice by 1 gives higher T1 ranking in this example.');

%% Exercise 5.11
% T1 beats T2 by n pts, T2 beats T3 by 1, T3 beats T1 by 1. Find rankings for n=1,5,10,100.
disp('=== Exercise 5.11 ===');
fprintf('(a) Ranking as function of n (T1 beats T2 by n once):\n');
for n = [1, 5, 10, 100]
    M = [2 -1 -1; -1 2 -1; 1 1 1];
    q = [n-1; -n+1; -1+1];  % T1: +n-1; T2: -n+1; T3: +1-1=0
    r = M \ q;
    fprintf('  n=%3d: r1=%.4f, r2=%.4f, r3=%.4f\n', n, r(1),r(2),r(3));
end

fprintf('\n(b) T1 beats T2 by 1 n times, T2 beats T3 by 1, T3 beats T1 by 1:\n');
for n = [1, 5, 10, 100]
    M = [n+1 -n -1; -n n+1 -1; 1 1 1];  % T1 plays n+1 games, T2 plays n+1, T3 plays 2
    % Wait: T1-T2 (n times), T1-T3 (1 time) => T1 plays n+1; T2-T3 (1 time) => T2 plays n+1; T3 plays 2
    % Off-diag: m12=m21=-n, m13=m31=-1, m23=m32=-1
    M = [n+1 -n -1; -n n+1 -1; 1 1 1];
    q = [n*1-1; -n*1+1; -1+1];  % T1: +n-1; T2: -n+1; T3: 0
    r = M \ q;
    fprintf('  n=%3d: r1=%.4f, r2=%.4f, r3=%.4f\n', n, r(1),r(2),r(3));
end
disp('');

%% Exercise 5.12
% Three teams symbolic: T1 beats T2 by alpha, T2 beats T3 by beta, T3 beats T1 by gamma
disp('=== Exercise 5.12 ===');
% (a) For equal rankings: solve with alpha=beta=gamma=k
k = 3;
M = [2 -1 -1; -1 2 -1; 1 1 1];
q = [k-k; -k+k; 0];
r = M \ q;
fprintf('(a) With alpha=beta=gamma=%d: all rankings = 0: [%.4f,%.4f,%.4f]\n', k, r(1),r(2),r(3));
% General verification: q1=alpha-gamma, q2=-alpha+beta, q3=-beta+gamma
alpha=2; beta=3; gamma=4;
q_gen = [alpha-gamma; -alpha+beta; 0];
r_gen = M \ q_gen;
fprintf('(a) General: alpha=%d,beta=%d,gamma=%d: r=[%.4f;%.4f;%.4f]\n', alpha,beta,gamma,r_gen(1),r_gen(2),r_gen(3));
disp('');

%% Exercise 5.13
% Six teams, disconnected: {T1,T2,T3} and {T4,T5,T6}
disp('=== Exercise 5.13 ===');
% (b) Apply Massey to each subset
M_sub = [1 -1 0; -1 2 -1; 1 1 1];
q_sub1 = [2; -2+3; 0];   % T1 beats T2 by 2, T2 beats T3 by 3
r1 = M_sub \ q_sub1;
fprintf('(b) Group {T1,T2,T3}: r=[%.4f; %.4f; %.4f]\n', r1(1),r1(2),r1(3));
q_sub2 = [2; -2+3; 0];   % T4 beats T5 by 2, T5 beats T6 by 3 (same structure)
r2 = M_sub \ q_sub2;
fprintf('    Group {T4,T5,T6}: r=[%.4f; %.4f; %.4f]\n', r2(1),r2(2),r2(3));

% (c) T3 beats T4 by 1: now 6 teams connected
M6 = [1 -1  0  0  0  0;
     -1  2 -1  0  0  0;
      0 -1  2 -1  0  0;
      0  0 -1  2 -1  0;
      0  0  0 -1  2 -1;
      1  1  1  1  1  1];
q6 = [2; -2+3; -3+1; -1+2; -2+3; 0];
r6 = M6 \ q6;
fprintf('(c) All 6 teams after T3 beats T4 by 1:\n');
for i=1:6, fprintf('    T%d=%.4f\n',i,r6(i)); end
disp('');

%% Exercise 5.16
% Nontrivial examples where exact solution exists (no LS needed)
disp('=== Exercise 5.16 ===');
disp('Example: 2 teams, T1 beats T2 by k. Then r1-r2=k.');
disp('The matrix equation A*r = p is just [1,-1]*[r1;r2] = [k].');
disp('This is ONE equation with two unknowns => infinitely many solutions.');
disp('After Massey modification: M=[1,-1;1,1], q=[k;0] => unique solution.');
disp('No LS needed since M is now invertible.');
k = 5;
M = [1 -1; 1 1];
q = [k; 0];
r = M \ q;
fprintf('k=%d: r1=%.4f, r2=%.4f\n', k, r(1), r(2));
disp('The sum constraint r1+r2=0 is still necessary to get a unique solution.');
