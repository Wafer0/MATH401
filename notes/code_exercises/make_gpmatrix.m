function T = make_gpmatrix(links, n, d)
% Build Google PageRank transition matrix.
% links: Nx2 matrix [from_page, to_page]; n: number of pages; d: damping (default 0.85)
    if nargin < 3, d = 0.85; end
    part2 = zeros(n, n);
    for k = 1:size(links,1)
        from_p = links(k,1); to_p = links(k,2);
        part2(to_p, from_p) = 1;
    end
    for i = 1:n
        if sum(part2(:,i)) > 0
            part2(:,i) = part2(:,i) / sum(part2(:,i));
        else
            part2(:,i) = ones(n,1) / n;
        end
    end
    T = (1-d)/n * ones(n,n) + d * part2;
end
