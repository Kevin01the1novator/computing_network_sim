function metrics = calculatePerformance(adjMatrix, newAdjMatrix)
    % This function calculates performance metrics such as convergence time and routing overhead.
    
    % Call Dijkstra to get the paths for both the old and new adjacency matrices
    oldPaths = dijkstra(adjMatrix, 1);  % Shortest paths using the old matrix
    newPaths = dijkstra(newAdjMatrix, 1);  % Shortest paths using the new matrix
    
    % Performance metrics (simulated here)
    convergenceTime = randi([1, 10]);  % Simulated convergence time in seconds
    routingOverhead = randi([10, 100]);  % Simulated routing overhead (e.g., in bytes)
    
    % Store metrics in a struct
    metrics.convergenceTime = convergenceTime;
    metrics.routingOverhead = routingOverhead;
end
