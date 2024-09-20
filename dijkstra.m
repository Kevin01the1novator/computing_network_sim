function [dist, path] = dijkstra(adjMatrix, startNode)
    numNodes = size(adjMatrix, 1);
    dist = inf(1, numNodes);
    prev = -ones(1, numNodes);
    visited = false(1, numNodes);
    dist(startNode) = 0;
    for i = 1:numNodes
        [~, u] = min(dist .* ~visited);
        visited(u) = true;
        for v = 1:numNodes
            if adjMatrix(u, v) > 0 && ~visited(v)
                alt = dist(u) + adjMatrix(u, v);
                if alt < dist(v)
                    dist(v) = alt;
                    prev(v) = u;
                end
            end
        end
    end
    path = cell(1, numNodes);
    for i = 1:numNodes
        if dist(i) < inf
            p = i;
            while prev(p) > 0
                path{i} = [prev(p), path{i}];
                p = prev(p);
            end
        end
    end
end
