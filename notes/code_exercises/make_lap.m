function L = make_lap(A)
% Compute graph Laplacian L = D - A from adjacency matrix A.
    L = diag(sum(A)) - A;
end
