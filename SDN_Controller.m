function SDN_Controller(adjMatrix, event)
    disp('SDN Controller received an event:');
    disp(event);

    affectedNodes = event.affectedNodes;
    recomputePartial(adjMatrix, affectedNodes);
end
