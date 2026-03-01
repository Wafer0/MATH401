% ============================================================
% MATLAB Code for Chapter 4 - Curve Fitting Exercises
% Math 401 - Applications of Linear Algebra
% ============================================================

%% Exercise 4.1
% Points (-1,0), (1,2), (2,2). Find the least-squares line f(x) = mx + b.
disp('=== Exercise 4.1 ===');
pts = [-1 0; 1 2; 2 2];
A = [pts(:,1), ones(size(pts,1),1)];
b = pts(:,2);
x_hat = inv(A'*A) * A'*b;
fprintf('Least-squares line: y = %.6f*x + %.6f\n', x_hat(1), x_hat(2));
fprintf('(Slope m = %.4f, intercept b = %.4f)\n\n', x_hat(1), x_hat(2));

%% Exercise 4.2
% Points (1,1),(5,2),(6,2),(8,3). Find LS line and estimate y at x=20.
disp('=== Exercise 4.2 ===');
pts = [1 1; 5 2; 6 2; 8 3];
A = [pts(:,1), ones(size(pts,1),1)];
b = pts(:,2);
x_hat = inv(A'*A) * A'*b;
fprintf('Least-squares line: y = %.6f*x + %.6f\n', x_hat(1), x_hat(2));
fprintf('Estimate at x=20: y = %.6f\n\n', x_hat(1)*20 + x_hat(2));

%% Exercise 4.3
% Points (-1,3),(0,1),(1,2),(3,9). Find LS parabola f(x) = ax^2 + bx + c.
disp('=== Exercise 4.3 ===');
pts = [-1 3; 0 1; 1 2; 3 9];
A = [pts(:,1).^2, pts(:,1), ones(size(pts,1),1)];
b = pts(:,2);
x_hat = inv(A'*A) * A'*b;
a = x_hat(1); bc = x_hat(2); c = x_hat(3);
fprintf('Least-squares parabola: f(x) = %.6f*x^2 + %.6f*x + %.6f\n', a, bc, c);
% Solve f(x) = 10 => ax^2 + bx + (c-10) = 0
disc = bc^2 - 4*a*(c - 10);
x1 = (-bc + sqrt(disc)) / (2*a);
x2 = (-bc - sqrt(disc)) / (2*a);
fprintf('Roots of f(x) = 10: x = %.4f or x = %.4f\n\n', x1, x2);

%% Exercise 4.4
% Points (-2,0),(0,3),(4,4). Find LS exponential f(x) = a*e^x + b.
disp('=== Exercise 4.4 ===');
pts = [-2 0; 0 3; 4 4];
A = [exp(pts(:,1)), ones(size(pts,1),1)];
b = pts(:,2);
x_hat = inv(A'*A) * A'*b;
a = x_hat(1); bval = x_hat(2);
fprintf('Least-squares exponential: f(x) = %.6f*e^x + %.6f\n', a, bval);
% f'(x) = a*e^x, so f'(1) = a*e
fprintf('Estimate f''(1) = a*e = %.6f\n\n', a*exp(1));

%% Exercise 4.5
% Points (-2,6.3),(3,1.2),(5,7.1),(8,-2.8),(9,-0.05).
% Find LS f(x) = a + b*sin(x).
disp('=== Exercise 4.5 ===');
pts = [-2 6.3; 3 1.2; 5 7.1; 8 -2.8; 9 -0.05];
A = [ones(size(pts,1),1), sin(pts(:,1))];
b = pts(:,2);
x_hat = inv(A'*A) * A'*b;
a = x_hat(1); bval = x_hat(2);
fprintf('Least-squares: f(x) = %.6f + %.6f*sin(x)\n', a, bval);
fprintf('Estimate f(pi/2) = %.6f\n\n', a + bval*sin(pi/2));

%% Exercise 4.6
% Points (-3,-2,45),(2,-2,30),(0,1,6),(-2,3,55),(6,5,230).
% Find LS paraboloid f(x,y) = a*x^2 + b*y^2.
disp('=== Exercise 4.6 ===');
pts = [-3 -2 45; 2 -2 30; 0 1 6; -2 3 55; 6 5 230];
A = [pts(:,1).^2, pts(:,2).^2];
b = pts(:,3);
x_hat = inv(A'*A) * A'*b;
a = x_hat(1); bval = x_hat(2);
fprintf('Least-squares paraboloid: f(x,y) = %.6f*x^2 + %.6f*y^2\n', a, bval);
fprintf('Estimate f(3,5) = %.4f\n\n', a*9 + bval*25);

%% Exercise 4.7
% Points (0,0),(0,1),(1,1). Find best-fit line y=mx+b AND x=ny+c.
disp('=== Exercise 4.7 ===');
pts = [0 0; 0 1; 1 1];
% Line y = mx + b
A1 = [pts(:,1), ones(3,1)];
b1 = pts(:,2);
x1 = inv(A1'*A1) * A1'*b1;
fprintf('LS line y=mx+b: y = %.4f*x + %.4f\n', x1(1), x1(2));
% Line x = ny + c  (swap x and y roles)
A2 = [pts(:,2), ones(3,1)];
b2 = pts(:,1);
x2 = inv(A2'*A2) * A2'*b2;
fprintf('LS line x=ny+c: x = %.4f*y + %.4f\n', x2(1), x2(2));
% Rewrite as y = (1/n)*x - c/n
fprintf('Rewritten as y=... : y = %.4f*x + (%.4f)\n', 1/x2(1), -x2(2)/x2(1));
fprintf('(The two lines differ because different distances are minimized)\n\n');

%% Exercise 4.8
% Ellipse fitting in polar: Ar^2*cos^2(theta) + Br^2*sin^2(theta) = 1
% Data: (23,152),(50,135),(100,102),(110,110),(152,137) [degrees, millions of miles]
disp('=== Exercise 4.8 ===');
data = [23 152; 50 135; 100 102; 110 110; 152 137];
theta_rad = data(:,1) * pi / 180;
r = data(:,2);
% Equation: A*(r*cos(theta))^2 + B*(r*sin(theta))^2 = 1
A = [(r.*cos(theta_rad)).^2, (r.*sin(theta_rad)).^2];
b_vec = ones(5,1);
x_hat = inv(A'*A) * A'*b_vec;
Aval = x_hat(1); Bval = x_hat(2);
fprintf('Best-fit ellipse: A=%.8f, B=%.8f\n', Aval, Bval);
% (b) Predict r at theta=225 degrees
theta_pred = 225 * pi/180;
% A*r^2*cos^2 + B*r^2*sin^2 = 1 => r^2*(A*cos^2+B*sin^2) = 1
r_pred = sqrt(1 / (Aval*cos(theta_pred)^2 + Bval*sin(theta_pred)^2));
fprintf('(b) Predicted distance at theta=225 deg: r = %.4f million miles\n', r_pred);
% (c) Maximum distance: r is maximized when (A*cos^2+B*sin^2) is minimized
% If A < B, minimum is at cos^2=1 (theta=0 or 180), r_max = 1/sqrt(A)
% If A > B, minimum is at sin^2=1 (theta=90 or 270), r_max = 1/sqrt(B)
r_at_0 = sqrt(1/Aval);
r_at_90 = sqrt(1/Bval);
fprintf('(c) r at theta=0: %.4f, r at theta=90: %.4f\n', r_at_0, r_at_90);
fprintf('    Maximum distance from origin: %.4f million miles\n\n', max(r_at_0, r_at_90));

%% Exercise 4.10
% Points (1,1),(2,1),(3,2),(3,2),...,(3,2) [n times]. Fit y=mx+b.
% (a)-(d) analytical, but verify numerically for specific n
disp('=== Exercise 4.10 (numerical verification for n=5) ===');
n = 5;
pts = [1 1; 2 1; repmat([3 2], n, 1)];
A = [pts(:,1), ones(size(pts,1),1)];
b_vec = pts(:,2);
x_hat = inv(A'*A) * A'*b_vec;
fprintf('n=%d: m=%.6f, b=%.6f\n', n, x_hat(1), x_hat(2));
% As n->inf, line passes through (3,2) with some slope
n_large = 10000;
pts_l = [1 1; 2 1; repmat([3 2], n_large, 1)];
A_l = [pts_l(:,1), ones(size(pts_l,1),1)];
b_l = pts_l(:,2);
x_large = inv(A_l'*A_l) * A_l'*b_l;
fprintf('n=%d (approx limit): m=%.6f, b=%.6f\n\n', n_large, x_large(1), x_large(2));

%% Exercise 4.13
% For which templates does LS work?
% (a) f(x)=ax^2+bx^c  -- NO (c appears nonlinearly)
% (b) f(x)=ae^x+bx    -- YES (linear in a,b)
% (c) f(x)=e^(ax)+bx  -- NO (a appears nonlinearly)
% (d) f(x)=a*sin(x)+b*cos(x)+c -- YES (linear in a,b,c)
% (e) f(x)=a*sin(bx)+c -- NO (b appears nonlinearly)
disp('=== Exercise 4.13 ===');
disp('(a) f(x)=ax^2+bx^c: NO - exponent c makes it nonlinear in unknowns');
disp('(b) f(x)=ae^x+bx:   YES - linear in a and b');
disp('(c) f(x)=e^(ax)+bx: NO - a appears in exponent (nonlinear)');
disp('(d) f(x)=a*sin(x)+b*cos(x)+c: YES - linear in a,b,c');
disp('(e) f(x)=a*sin(bx)+c: NO - b appears inside sin (nonlinear)');
disp('');
disp('Example for (c): 3 points, e.g. (0,1),(1,3),(2,10):');
disp('e^(a*0)+b*0=1 => 1=1 (trivial), so system is underdetermined/nonlinear');
disp('Cannot write as matrix equation Ax=b with fixed A.');
