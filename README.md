
# OSPF Dynamic Timer Optimization Simulation

## Project Overview
This project implements a MATLAB simulation to study and optimize the performance of the **Open Shortest Path First (OSPF)** routing protocol in dynamic networks. The focus is on reducing overhead and convergence time by dynamically adjusting OSPF timers based on network conditions, such as traffic load and topology changes. The project incorporates advanced techniques like partial forwarding table re-computation, Software-Defined Networking (SDN) integration, and Machine Learning-based timer prediction.

---

## Key Features
- **Network Topology Simulation**: A dynamically changing network topology represented using an adjacency matrix.
- **Dijkstra’s Algorithm**: Computes shortest paths between routers based on link costs.
- **Adaptive Timer Adjustment**: Dynamically adjusts OSPF timers (Hello, Dead, SPF Holdtime) in response to traffic load and topology changes.
- **Partial Forwarding Table Re-computation**: Updates only the affected sections of the forwarding table to reduce overhead.
- **SDN Simulation**: Decouples control and data planes, allowing real-time routing optimizations.
- **Machine Learning Integration**: Predicts optimal OSPF timer values based on historical data using a feedforward neural network.
- **Quality of Service (QoS) Routing**: Incorporates traffic priority into shortest path calculations.
- **Performance Metrics**: Calculates convergence time and routing overhead to evaluate the efficiency of the dynamic OSPF optimization.

---

## Project Structure
The project consists of the following MATLAB files:

- `main.m`: The main script that orchestrates the entire simulation, calling various functions to simulate network behavior, perform computations, and visualize results.
- `dijkstra.m`: Function to compute the shortest path between nodes using the Dijkstra algorithm.
- `adjustTimers.m`: Function that adjusts the OSPF Hello, Dead, and SPF Holdtime timers based on real-time traffic conditions and topology change rate.
- `recomputePartial.m`: Function that handles partial forwarding table re-computation for only the affected nodes.
- `SDN_Controller.m`: Simulates a Software-Defined Networking (SDN) controller that manages routing updates.
- `dijkstraQoS.m`: Performs QoS-aware routing by considering traffic priority in shortest path calculations.
- `calculatePerformance.m`: Function to compute performance metrics like convergence time and routing overhead.

---

## How to Run the Project

### Requirements
- MATLAB (any version with basic support for matrix operations, graphs, and neural networks).
  
### Steps to Run the Simulation

1. **Clone or Download the Project**:
   - Download all the MATLAB files from this repository or place them in a local directory.
   
2. **Open MATLAB**:
   - Navigate to the directory containing the project files.

3. **Run the Simulation**:
   - Open the `main.m` script and run it. This script will execute all the necessary computations and visualizations for the simulation.
   - You can modify the adjacency matrix in `main.m` to simulate different network topologies.

### Example Run
When the script runs, it will:
1. Simulate a dynamic network topology using an adjacency matrix.
2. Calculate the shortest paths between routers using the Dijkstra algorithm.
3. Dynamically adjust OSPF timers based on random traffic load and topology changes.
4. Recompute the forwarding tables for affected nodes after a topology change.
5. Simulate the actions of an SDN controller for real-time routing updates.
6. Use machine learning to predict optimal timer settings.
7. Visualize performance metrics such as convergence time and overhead.

---

## Performance Evaluation
- **Convergence Time**: The time it takes for the network to stabilize after a change in topology.
- **Routing Overhead**: The amount of control information exchanged in the network to update routing tables.

---

## Customization
You can modify the following:
- **Network Topology**: Adjust the `adjMatrix` in `mainOSPF.m` to simulate different network topologies.
- **Traffic Conditions**: Adjust `trafficLoad` and `topoChangeRate` in the `adjustTimers.m` function to simulate various network conditions.
- **Machine Learning**: Modify the neural network architecture or training data for predictive OSPF timer optimization.

---

## Future Improvements
- Implementing more advanced machine learning models for OSPF timer predictions.
- Expanding SDN functionalities for finer-grained control of routing policies.
- Incorporating real-time network traffic data for more accurate simulation of dynamic network environments.

---

## License
This project is open-source and free to use. Feel free to modify, distribute, or improve the project.

---

## Contact
khoile0251@gmail.com

