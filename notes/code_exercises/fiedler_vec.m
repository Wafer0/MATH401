function [fv, lambda2] = fiedler_vec(L)
% Compute the Fiedler vector (eigenvector for lambda_2) of Laplacian L.
    [V, D] = eig(L);
    evs = real(diag(D));
    [~, idx] = sort(evs);
    lambda2 = evs(idx(2));
    fv = real(V(:, idx(2)));
end
