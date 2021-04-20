% Test algorithms on all test problems

% close all figures, clear all variables from workspace and clear command
% window
close all
clear
clc

%% set problem (minimal requirement: name of problem)
x0_string = ["x0 = 20*rand(10,1)-10","x0 = 20*rand(10,1)-10",...
             "x0 = 20*rand(1000,1)-10","x0 = 20*rand(1000,1)-10",...
             "x0 = [cos(70) sin(70) cos(70) sin(70)]'", "x0 = [cos(70) sin(70) cos(70) sin(70)]'",...
             "x0 = [-1.2; 1]", "x0 = [-1.2;ones(99,1)]", "x0 = [1; 1]", "x0 = [1; zeros(9,1)]",...
             "x0 = [1; zeros(99,1)]", "x0 = 506.2*[-1;ones(4,1)]"];
problems = cell(1,12);
for i=1:12
    rng(0);
    eval(x0_string(i));
    problems{i} = struct("name","P"+string(i),"x0", x0);
end
clc

methods = {'GradientDescent', 'GradientDescentW', 'Newton', 'NewtonW', 'BFGS', 'BFGSW', 'DFP', 'DFPW','TRNewtonCG', 'TRSR1CG'};


results = [];
f_trajectory = {};
count = 1;
for i=1:12
    % set options
    options.term_tol = 1e-6;
    options.max_iterations = 1e3;
    for j=1:length(methods)
        method.name = methods{j};
        disp("solving problem " + i + " with algorithm " + method.name)
        problem.name = problems{i}.name;
        problem.x0 = problems{i}.x0;

        [x, F, k, k1, k2, time] = optSolver_trajectory(problem,method,options);
        results = [results; [k, k1, k2, time]];
        f_trajectory{count} = F;
        count = count + 1;
    end
end

need_k = zeros(12,10);
for i=1:10
    need_k(:,i) = results(i:10:end, 1);
end

profile = zeros(1000,10);
for i=1:1000
    profile(i,:) = sum(need_k < i);
end

plot(1:1000, profile'/12, 'linewidth',2)
title('Performance Profile')
xlabel('iterations(k)')
ylabel('ratio of problems solved')
legend('GradientDescent', 'GradientDescentW', 'Newton', 'NewtonW', 'BFGS', 'BFGSW', 'DFP', 'DFPW','TRNewtonCG', 'TRSR1CG','Location','southeast')