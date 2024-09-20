function [dist, path] = dijkstraQoS(adjMatrix, priorityMatrix, startNode)
    % DIJKSTRAQOS calculates shortest path considering QoS priorities
    % adjMatrix: adjacency matrix of network topology
    % priorityMatrix: matrix with QoS priorities for each link
    % startNode: the node from which the shortest path is computed
    
    numNodes = size(adjMatrix, 1);
    dist = inf(1, numNodes);  % Distance from start node
    prev = -ones(1, numNodes);  % Previous nodes in path
    visited = false(1, numNodes);
    dist(startNode) = 0;  % Distance to the start node is 0

    for i = 1:numNodes
        % Find the unvisited node with the smallest distance
        [~, u] = min(dist .* ~visited);
        visited(u) = true;  % Mark this node as visited
        
        % Update distances to neighboring nodes
        for v = 1:numNodes
            if adjMatrix(u, v) > 0 && ~visited(v)
                % Adjust the cost using the priority matrix
                alt = dist(u) + adjMatrix(u, v) / priorityMatrix(u, v);
                if alt < dist(v)
                    dist(v) = alt;
                    prev(v) = u;
                end
            end
        end
    end

    % Generate paths for each node
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
