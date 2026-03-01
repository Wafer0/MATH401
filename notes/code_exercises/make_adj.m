function A = make_adj(edges, n)
% Build symmetric adjacency matrix from edge list.
% edges: Nx2 matrix of [v1, v2] pairs; n: total vertices
    A = zeros(n, n);
    for k = 1:size(edges,1)
        i = edges(k,1); j = edges(k,2);
        A(i,j) = 1; A(j,i) = 1;
    end
end
