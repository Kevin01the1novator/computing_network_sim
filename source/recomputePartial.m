function recomputePartial(adjMatrix, affectedNodes)
    for i = affectedNodes
        [dist, path] = dijkstra(adjMatrix, i);
        fprintf('Recomputed paths for node %d: \n', i);
        disp(path);
    end
end
