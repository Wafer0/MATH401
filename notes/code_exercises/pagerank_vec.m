function pr = pagerank_vec(T)
% Find pagerank probability vector (eigenvector for eigenvalue 1).
    [V, D] = eig(T);
    evs = real(diag(D));
    [~, idx] = max(evs);
    pr = real(V(:, idx));
    pr = abs(pr) / sum(abs(pr));
end
