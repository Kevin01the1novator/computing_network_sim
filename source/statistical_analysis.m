function statistical_analysis(convergenceTimesQoS, convergenceTimesDijkstra, ...
                              convergenceTimesRecompute, convergenceTimesSDN, ...
                              routingOverheadsQoS, routingOverheadsDijkstra, ...
                              routingOverheadsRecompute, routingOverheadsSDN)
    % Perform statistical analysis on the convergence time and routing overhead data
    % for each technique (QoS, Dijkstra, Recompute Partial, SDN Controller)
    
    % Call descriptive statistics for each technique
    fprintf('Descriptive Statistics:\n');
    descriptive_stats('QoS', convergenceTimesQoS, routingOverheadsQoS);
    descriptive_stats('Dijkstra', convergenceTimesDijkstra, routingOverheadsDijkstra);
    descriptive_stats('Recompute Partial', convergenceTimesRecompute, routingOverheadsRecompute);
    descriptive_stats('SDN Controller', convergenceTimesSDN, routingOverheadsSDN);

    % Perform inferential statistics (e.g., t-test, ANOVA)
    fprintf('\nInferential Statistics:\n');
    inferential_stats(convergenceTimesQoS, convergenceTimesDijkstra, ...
                      convergenceTimesRecompute, convergenceTimesSDN);
    
    % Perform regression analysis (linear and multivariate)
    fprintf('\nRegression Analysis:\n');
    regression_analysis(convergenceTimesQoS, convergenceTimesDijkstra, ...
                        convergenceTimesRecompute, convergenceTimesSDN, ...
                        routingOverheadsQoS, routingOverheadsDijkstra, ...
                        routingOverheadsRecompute, routingOverheadsSDN);
end

%% Descriptive Statistics
function descriptive_stats(methodName, convergenceTimesQoS, routingOverheadsQoS)
    % Compute and display descriptive statistics for the given technique
    fprintf('--- %s ---\n', methodName);
    
    % Measures of Central Tendency
    meanConvergence = mean(convergenceTimesQoS);
    medianConvergence = median(convergenceTimesQoS);
    modeConvergence = mode(convergenceTimesQoS);
    
    meanOverhead = mean(routingOverheadsQoS);
    medianOverhead = median(routingOverheadsQoS);
    modeOverhead = mode(routingOverheadsQoS);
    
    % Variability
    stdConvergence = std(convergenceTimesQoS);
    varConvergence = var(convergenceTimesQoS);
    
    stdOverhead = std(routingOverheadsQoS);
    varOverhead = var(routingOverheadsQoS);
    
    % Print Results
    fprintf('Convergence Time - Mean: %.2f, Median: %.2f, Mode: %.2f, Std: %.2f, Var: %.2f\n', ...
        meanConvergence, medianConvergence, modeConvergence, stdConvergence, varConvergence);
    fprintf('Routing Overhead - Mean: %.2f, Median: %.2f, Mode: %.2f, Std: %.2f, Var: %.2f\n', ...
        meanOverhead, medianOverhead, modeOverhead, stdOverhead, varOverhead);
end

%% Inferential Statistics
function inferential_stats(convergenceTimesQoS, convergenceTimesDijkstra, ...
                           convergenceTimesRecompute, convergenceTimesSDN)
    % Perform statistical hypothesis tests (ANOVA) to compare means between methods
    
    % One-way ANOVA to compare the means of all methods
    allConvergenceTimes = [convergenceTimesQoS, convergenceTimesDijkstra, ...
                           convergenceTimesRecompute, convergenceTimesSDN];
    groupLabels = [ones(1, length(convergenceTimesQoS)), ...
                   2 * ones(1, length(convergenceTimesDijkstra)), ...
                   3 * ones(1, length(convergenceTimesRecompute)), ...
                   4 * ones(1, length(convergenceTimesSDN))];

    % One-way ANOVA to compare the means between groups
    [p, tbl, stats] = anova1(allConvergenceTimes, groupLabels, 'off');
    fprintf('ANOVA p-value (Convergence Times): %.5f\n', p);
    
    % Post-hoc comparison (if p-value is significant)
    if p < 0.05
        c = multcompare(stats, 'Display', 'off');
        disp('Post-hoc comparison of convergence times:');
        disp(c);
    end
end

%% Regression Analysis
function regression_analysis(convergenceTimesQoS, convergenceTimesDijkstra, ...
                             convergenceTimesRecompute, convergenceTimesSDN, ...
                             routingOverheadsQoS, routingOverheadsDijkstra, ...
                             routingOverheadsRecompute, routingOverheadsSDN)
    % Perform linear and multivariate regression analysis on the data
    
    % Combine all data for multivariate regression
    allConvergenceTimes = [convergenceTimesQoS, convergenceTimesDijkstra, ...
                           convergenceTimesRecompute, convergenceTimesSDN];
    allRoutingOverheads = [routingOverheadsQoS, routingOverheadsDijkstra, ...
                           routingOverheadsRecompute, routingOverheadsSDN];
    
    % Perform linear regression between convergence times and routing overheads
    fprintf('Linear Regression (Convergence vs. Routing Overhead)\n');
    lm = fitlm(allConvergenceTimes, allRoutingOverheads);
    disp(lm);
    
    % Prepare data for multivariate regression
    % Ensure all convergence times have the same length
    minLength = min([length(convergenceTimesQoS), length(convergenceTimesDijkstra), ...
                     length(convergenceTimesRecompute), length(convergenceTimesSDN)]);
    
    % Truncate all vectors to the same length
    X = [convergenceTimesQoS(1:minLength)', convergenceTimesDijkstra(1:minLength)', ...
         convergenceTimesRecompute(1:minLength)', convergenceTimesSDN(1:minLength)'];
    
    % Truncate routing overheads to match the length of the predictors
    y = allRoutingOverheads(1:minLength)';
    
    % Perform multivariate regression
    fprintf('Multivariate Regression (Routing Overhead vs. Convergence Times)\n');
    mdl = fitlm(X, y);
    disp(mdl);
    
    % Multivariate Regression
    fprintf('Multivariate Regression (Routing Overhead vs. Convergence Times)\n');
    mdl = fitlm(X, y);
    disp(mdl);
end

    
