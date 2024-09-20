% Main Script for Running OSPF Dynamic Timer Optimization

% Step 1: Network Topology Simulation
numNodes = 6;
adjMatrix = [0 10 0 0 0 5;
             10 0 3 0 0 2;
             0 3 0 4 2 0;
             0 0 4 0 3 0;
             0 0 2 3 0 1;
             5 2 0 0 1 0];

G = graph(adjMatrix, 'upper');
figure;
plot(G);

% Step 2: Define priorityMatrix for QoS (example)
priorityMatrix = [1 2 0 0 0 1;
                  2 1 3 0 0 2;
                  0 3 1 4 2 0;
                  0 0 4 1 3 0;
                  0 0 2 3 1 2;
                  1 2 0 0 2 1];

% Step 3: Define the start node
startNode = 1;

% Step 4: Call the dijkstraQoS function to calculate the shortest path with QoS
[distQoS, pathQoS] = dijkstraQoS(adjMatrix, priorityMatrix, startNode);

% Step 5: Display the QoS-aware results
disp('Shortest Path Distances with QoS:');
disp(distQoS);
disp('Paths:');
disp(pathQoS);

% Step 6: Call the dijkstra function (without QoS)
[dist, path] = dijkstra(adjMatrix, startNode);

% Step 7: Display the standard shortest path results
disp('Shortest Path Distances:');
disp(dist);
disp('Paths:');
disp(path);

% Step 8: Adjust OSPF timers based on traffic load and topology changes
trafficLoad = 0.75; % Example traffic load
topoChangeRate = 0.6; % Example topology change rate
[newHello, newDead, newSPF] = adjustTimers(trafficLoad, topoChangeRate);

% Display adjusted timers
disp('Adjusted Hello Timer:');
disp(newHello);
disp('Adjusted Dead Timer:');
disp(newDead);
disp('Adjusted SPF Holdtime:');
disp(newSPF);

% Step 9: Call the recomputePartial function (recomputing for affected nodes)
affectedNodes = [2, 3]; % Nodes affected by topology changes
recomputePartial(adjMatrix, affectedNodes);

% Step 10: Call SDN_Controller to simulate real-time network adjustments
event.affectedNodes = [4, 5]; % Nodes affected by an event
SDN_Controller(adjMatrix, event);

% Step 11: Call the calculatePerformance function to evaluate performance
newAdjMatrix = adjMatrix;
newAdjMatrix(3, 4) = 6; % Simulate a link change
metrics = calculatePerformance(adjMatrix, newAdjMatrix);

% Display performance metrics
disp('Convergence Time:');
disp(metrics.convergenceTime);
disp('Routing Overhead:');
disp(metrics.routingOverhead);

% Call visualizeOSPFPerformance to evaluate and visualize the performance
visualizeOSPFPerformance;