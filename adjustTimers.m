function [newHello, newDead, newSPF] = adjustTimers(trafficLoad, topoChangeRate)
    HelloTimer = 10;
    DeadTimer = 40;
    SPFHoldtime = 5;

    if trafficLoad > 0.7
        newHello = HelloTimer - 2;
    else
        newHello = HelloTimer;
    end
    
    if topoChangeRate > 0.5
        newDead = DeadTimer - 10;
        newSPF = SPFHoldtime - 1;
    else
        newDead = DeadTimer;
        newSPF = SPFHoldtime;
    end
end
