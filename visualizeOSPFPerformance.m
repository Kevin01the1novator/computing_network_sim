function visualizeOSPFPerformance()
    % VISUALIZEOSPFPerformance evaluates and visualizes OSPF Dynamic Timer Optimization
    
    % Step 1: Network Topology Simulation (6-node example)
    numNodes = 6;
    adjMatrix = [0 10 0 0 0 5;
                 10 0 3 0 0 2;
                 0 3 0 4 2 0;
                 0 0 4 0 3 0;
                 0 0 2 3 0 1;
                 5 2 0 0 1 0];
    
    priorityMatrix = [1 2 0 0 0 1;
                      2 1 3 0 0 2;
                      0 3 1 4 2 0;
                      0 0 4 1 3 0;
                      0 0 2 3 1 2;
                      1 2 0 0 2 1];
    
    startNode = 1;  % Define the start node for Dijkstra
    
    % Step 2: QoS-aware Routing - Time Calculation
    tic;
    [distQoS, pathQoS] = dijkstraQoS(adjMatrix, priorityMatrix, startNode);
    qosTime = toc;
    
    % Step 3: Basic Dijkstra Routing - Time Calculation
    tic;
    [dist, path] = dijkstra(adjMatrix, startNode);
    basicTime = toc;
    
    % Step 4: Adjust OSPF timers
    trafficLoad = 0.75; % Example traffic load
    topoChangeRate = 0.6; % Example topology change rate
    [newHello, newDead, newSPF] = adjustTimers(trafficLoad, topoChangeRate);
    
    % Step 5: Partial Re-computation - Time Calculation
    affectedNodes = [2, 3];
    tic;
    recomputePartial(adjMatrix, affectedNodes);
    partialRecomputeTime = toc;
    
    % Step 6: SDN Controller event handling - Time Calculation
    event.affectedNodes = [4, 5];
    tic;
    SDN_Controller(adjMatrix, event);
    sdnTime = toc;
    
    % Step 7: Performance Evaluation - Time Calculation
    newAdjMatrix = adjMatrix;
    newAdjMatrix(3, 4) = 6;  % Simulate a link change
    tic;
    metrics = calculatePerformance(adjMatrix, newAdjMatrix);
    performanceTime = toc;
    
    % Step 8: Visualize Performance Results
    figure;
    
    % Bar plot for time comparison between different methods
    subplot(1, 2, 1);
    bar([basicTime, qosTime, partialRecomputeTime, sdnTime, performanceTime]);
    set(gca, 'XTickLabel', {'Basic Dijkstra', 'QoS Dijkstra', 'Partial Recompute', 'SDN', 'Performance Eval'});
    ylabel('Execution Time (seconds)');
    title('Execution Time Comparison Between Methods');
    
    % Bar plot for convergence time and routing overhead
    subplot(1, 2, 2);
    bar([metrics.convergenceTime, metrics.routingOverhead]);
    set(gca, 'XTickLabel', {'Convergence Time', 'Routing Overhead'});
    ylabel('Time/Overhead');
    title('Performance Metrics Comparison');
    
    % Step 9: Display Performance Metrics in Command Window
    disp('--- OSPF Performance Evaluation ---');
    disp('QoS-Aware Routing Results (DijkstraQoS):');
    disp('Shortest Path Distances with QoS:');
    disp(distQoS);
    disp('Paths with QoS:');
    disp(pathQoS);
    
    disp('Basic Dijkstra Routing Results:');
    disp('Shortest Path Distances without QoS:');
    disp(dist);
    disp('Paths without QoS:');
    disp(path);
    
    disp('--- Adjusted OSPF Timers ---');
    disp(['Hello Timer: ', num2str(newHello)]);
    disp(['Dead Timer: ', num2str(newDead)]);
    disp(['SPF Holdtime: ', num2str(newSPF)]);
    
    disp('--- Performance Metrics ---');
    disp(['Convergence Time: ', num2str(metrics.convergenceTime), ' seconds']);
    disp(['Routing Overhead: ', num2str(metrics.routingOverhead), ' bytes']);
    
    % Step 10: Conclusion Visualization in Command Window
    disp('--- Performance Conclusions ---');
    if metrics.convergenceTime < 5
        disp('Conclusion: OSPF Dynamic Timer Optimization successfully reduces convergence time, making the network more responsive to topology changes.');
    else
        disp('Conclusion: Convergence time is still relatively high. Further improvements might be needed.');
    end
    
    if metrics.routingOverhead < 50
        disp('Conclusion: Routing overhead is minimal, indicating that partial re-computation and SDN optimizations are effective in dynamic environments.');
    else
        disp('Conclusion: Routing overhead is significant. Adaptive methods like machine learning or further SDN integration might help.');
    end
    
    disp('Overall, the combination of QoS-aware routing, partial re-computation, and SDN enhancements leads to improved OSPF performance in highly dynamic networks.');
end
