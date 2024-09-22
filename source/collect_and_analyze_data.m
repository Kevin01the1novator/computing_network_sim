function [convergenceTimesQoS, convergenceTimesDijkstra, convergenceTimesRecompute, ...
          routingOverheadsQoS, routingOverheadsDijkstra, routingOverheadsRecompute, ...
          convergenceTimesSDN, routingOverheadsSDN] = collect_and_analyze_data(adjMatrix, trafficLoad, topoChangeRate)

    % Initialize variables for data collection
    numNodes = size(adjMatrix, 1);
    totalIterations = 100; % Number of iterations for simulation

    % Preallocate space for each technique's performance metrics
    convergenceTimesQoS = zeros(1, totalIterations);
    routingOverheadsQoS = zeros(1, totalIterations);
    
    convergenceTimesDijkstra = zeros(1, totalIterations);
    routingOverheadsDijkstra = zeros(1, totalIterations);
    
    convergenceTimesRecompute = zeros(1, totalIterations);
    routingOverheadsRecompute = zeros(1, totalIterations);

    convergenceTimesSDN = zeros(1, totalIterations);
    routingOverheadsSDN = zeros(1, totalIterations);

    for i = 1:totalIterations
        % Simulate network conditions (QoS-aware)
        [newAdjMatrixQoS, trafficPatternQoS] = simulate_network_conditions(adjMatrix, trafficLoad, topoChangeRate);
        
        % Measure performance metrics for QoS-aware routing
        convTimeQoS = measure_convergence_time(newAdjMatrixQoS, numNodes);
        routingOverheadQoS = calculate_routing_overhead(newAdjMatrixQoS, trafficPatternQoS);
        
        convergenceTimesQoS(i) = convTimeQoS;
        routingOverheadsQoS(i) = routingOverheadQoS;

        % Simulate network conditions (Standard Dijkstra)
        [newAdjMatrixDijkstra, trafficPatternDijkstra] = simulate_network_conditions(adjMatrix, trafficLoad, topoChangeRate);
        
        % Measure performance metrics for Dijkstra routing
        convTimeDijkstra = measure_convergence_time(newAdjMatrixDijkstra, numNodes);
        routingOverheadDijkstra = calculate_routing_overhead(newAdjMatrixDijkstra, trafficPatternDijkstra);
        
        convergenceTimesDijkstra(i) = convTimeDijkstra;
        routingOverheadsDijkstra(i) = routingOverheadDijkstra;

        % Measure performance for recomputePartial
        affectedNodes = [2, 3];
        tic;
        recomputePartial(newAdjMatrixQoS, affectedNodes);
        convergenceTimesRecompute(i) = toc;
        routingOverheadsRecompute(i) = calculate_routing_overhead(newAdjMatrixQoS, trafficPatternQoS);

        % Simulate SDN Controller adjustments
        event.affectedNodes = [4, 5];
        tic;
        SDN_Controller(newAdjMatrixQoS, event);
        convergenceTimesSDN(i) = toc;
        routingOverheadsSDN(i) = calculate_routing_overhead(newAdjMatrixQoS, trafficPatternQoS);
    end

    % Call the local function to analyze performance
    analyze_performance(convergenceTimesQoS, routingOverheadsQoS, ...
                        convergenceTimesDijkstra, routingOverheadsDijkstra, ...
                        convergenceTimesRecompute, routingOverheadsRecompute, ...
                        convergenceTimesSDN, routingOverheadsSDN);
end

function analyze_performance(convergenceTimesQoS, routingOverheadsQoS, ...
                             convergenceTimesDijkstra, routingOverheadsDijkstra, ...
                             convergenceTimesRecompute, routingOverheadsRecompute, ...
                             convergenceTimesSDN, routingOverheadsSDN)
    % Step 1: Statistical analysis for each technique
    avgConvergenceQoS = mean(convergenceTimesQoS);
    avgConvergenceDijkstra = mean(convergenceTimesDijkstra);
    avgConvergenceRecompute = mean(convergenceTimesRecompute);
    avgConvergenceSDN = mean(convergenceTimesSDN);

    % Print out the results
    fprintf('QoS Routing - Average Convergence Time: %.2f seconds\n', avgConvergenceQoS);
    fprintf('Dijkstra Routing - Average Convergence Time: %.2f seconds\n', avgConvergenceDijkstra);
    fprintf('Recompute Partial - Average Convergence Time: %.2f seconds\n', avgConvergenceRecompute);
    fprintf('SDN Controller - Average Convergence Time: %.2f seconds\n', avgConvergenceSDN);

    % Step 2: Visualize the results
    figure;
    subplot(2, 1, 1);
    plot(convergenceTimesQoS, 'b'); hold on;
    plot(convergenceTimesDijkstra, 'r');
    plot(convergenceTimesRecompute, 'g');
    plot(convergenceTimesSDN, 'm');
    xlabel('Iteration');
    ylabel('Convergence Time (s)');
    title('Comparison of Convergence Times');
    legend('QoS', 'Dijkstra', 'Recompute Partial', 'SDN');

    subplot(2, 1, 2);
    plot(routingOverheadsQoS, 'b'); hold on;
    plot(routingOverheadsDijkstra, 'r');
    plot(routingOverheadsRecompute, 'g');
    plot(routingOverheadsSDN, 'm');
    xlabel('Iteration');
    ylabel('Routing Overhead');
    title('Comparison of Routing Overheads');
    legend('QoS', 'Dijkstra', 'Recompute Partial', 'SDN');
end


function [newAdjMatrix, trafficPattern] = simulate_network_conditions(adjMatrix, trafficLoad, topoChangeRate)
    % Simulate network conditions such as changes in traffic load and topology
    % Input:
    % adjMatrix: Initial adjacency matrix of the network
    % trafficLoad: Load on the network, from 0 (no load) to 1 (maximum load)
    % topoChangeRate: Rate of topology changes, from 0 (no changes) to 1 (maximum changes)
    
    % Output:
    % newAdjMatrix: Updated adjacency matrix after simulating topology changes
    % trafficPattern: Simulated traffic load over the network

    % Simulate topology changes by randomly adjusting link weights
    % Multiply original adjacency matrix by a random factor based on topoChangeRate
    changeFactor = 1 + (topoChangeRate * rand(size(adjMatrix)));
    newAdjMatrix = adjMatrix .* changeFactor;  % Adjust link weights
    
    % Simulate traffic load: random traffic on each link, scaled by the trafficLoad parameter
    trafficPattern = trafficLoad * rand(size(adjMatrix));  % Traffic matrix
end

function convTime = measure_convergence_time(adjMatrix, numNodes)
    % Measures the convergence time of OSPF by calculating the shortest paths
    % across all nodes using Dijkstra's algorithm
    
    convTime = 0; % Initialize total convergence time
    
    % Loop through all nodes to compute shortest paths
    for i = 1:numNodes
        tic; % Start the timer
        [~, ~] = dijkstra(adjMatrix, i); % Perform Dijkstra's algorithm for each node
        convTime = convTime + toc; % Accumulate the time taken for convergence
    end
end

function routingOverhead = calculate_routing_overhead(adjMatrix, trafficPattern)
    % Calculate routing overhead in terms of control packets and bandwidth used
    % Input:
    % adjMatrix: Updated adjacency matrix representing the network topology
    % trafficPattern: Traffic pattern matrix representing the traffic load on the network
    
    % Output:
    % routingOverhead: Total routing overhead
    
    % Assume that control messages are proportional to traffic and topology changes
    overheadFactor = 0.1; % Control traffic as a fraction of data traffic
    routingOverhead = overheadFactor * sum(trafficPattern(:)) * sum(adjMatrix(:));
end

