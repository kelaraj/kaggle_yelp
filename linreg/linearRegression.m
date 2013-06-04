% Regularized Linear Regression and Bias-Variance

%% Initialization
clear ; close all; clc

%% =========== Part 1: Loading and Visualizing Data =============

fprintf('Loading and Visualizing Data ...\n')

% Load train/test data
% Fields: votes_useful  r_days_active   r_length  u_avg_votes_useful  sentiment
% unused: order(created by me) r_exclamations  u_review_count
% add misspellings/grammar issues as categories?
data = csvread('train.csv');
X = data(1:1000,2:5); % UPDATE BACK TO X = data(1:170000,2:5);
y = data(1:1000,1); % UPDATE BACK TO y = data(1:170000,1); 

testdata = csvread('test.csv');
Xtest = testdata(:,2:5);
ytest = testdata(:,1);

Xval = data(213200:213435,2:5); % UPDATE BACK TO Xval = data(170001:213435,2:5);
yval = data(213200:213435,1); % UPDATE BACK TO yval = data(170001:213435,1);

% m = Number of examples
m = size(X, 1);
#{
fprintf('Press enter to show plot 1.\n');
pause;

% Plot training data
figure('Position',[100,107,1250,770]);
plot(X(:,1), y, 'bo', 'MarkerSize', 10, 'LineWidth', 1.5);
xlabel('Days active (review) (x)');
ylabel('Votes useful (y)');

fprintf('Press enter to show plot 2.\n');
pause;

figure('Position',[100,107,1250,770]);
plot(X(:,2), y, 'bo', 'MarkerSize', 10, 'LineWidth', 1.5);
xlabel('Review length (x)');
ylabel('Votes useful (y)');

fprintf('Press enter to show plot 3.\n');
pause;

figure('Position',[100,107,1250,770]);
plot(X(:,3), y, 'bo', 'MarkerSize', 10, 'LineWidth', 1.5);
xlabel('User avg votes useful (x)');
ylabel('Votes useful (y)');

fprintf('Press enter to show plot 4.\n');
pause;

figure('Position',[100,107,1250,770]);
plot(X(:,4), y, 'bo', 'MarkerSize', 10, 'LineWidth', 1.5);
xlabel('AFINN sentiment score (x)');
ylabel('Votes useful (y)');

fprintf('Program paused. Press enter to calculate cost function.\n');
pause;

%% =========== Part 2: Regularized Linear Regression Cost =============

theta = [1 ; 1 ; 1 ; 1 ; 1];
J = linearRegCostFunction([ones(m, 1) X], y, theta, 1);

fprintf(['Cost at theta (where lambda = 1) = [1 ; 1 ; 1 ; 1 ; 1]: %f \n'], J);

fprintf('Program paused. Press enter to calculate gradient.\n');
pause;

%% =========== Part 3: Regularized Linear Regression Gradient =============

theta = [1 ; 1 ; 1 ; 1 ; 1];
[J, grad] = linearRegCostFunction([ones(m, 1) X], y, theta, 1);

fprintf(['Gradient at theta (where lambda = 1) = [1 ; 1 ; 1 ; 1 ; 1]:'...
         '  [%f; %f; %f; %f; %f] \n'], ...
         grad(1), grad(2), grad(3), grad(4), grad(5));

fprintf('Program paused. Press enter to train linear regression.\n');
pause;

%% =========== Part 4: Train Linear Regression =============

lambda = 0;
[theta] = trainLinearReg([ones(m, 1) X], y, lambda);

%  Plot fit over the data
figure('Position',[100,107,1250,770]);
plot(X, y, 'bo', 'MarkerSize', 10, 'LineWidth', 1.5);
xlabel('Inputs (x)');
ylabel('Votes useful (y)');
hold on;
plot(X, [ones(m, 1) X]*theta, '--', 'LineWidth', 2)
hold off;

fprintf('Program paused. Press enter to plot learning curves.\n');
pause;

%% =========== Part 5: Learning Curve for Linear Regression =============

lambda = 0;
[error_train, error_val] = ...
    learningCurve([ones(m, 1) X], y, ...
                  [ones(size(Xval, 1), 1) Xval], yval, ...
                  lambda);

figure('Position',[100,107,1250,770]);
plot(1:m, error_train, '.', "markersize", 10, 1:m, error_val, '.', "markersize", 10);
title('Learning curve for linear regression')
legend('Train', 'Cross Validation')
xlabel('Number of training examples')
ylabel('Error')
axis([0 100000 0 25])

fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
for i = 1:m
    fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
end

fprintf('Program paused. Press enter to map features for Polynomial Regression.\n');
pause;

%% =========== Part 6: Feature Mapping for Polynomial Regression =============

% polynomial degree [ADJUST AS NECESSARY]
p = 4;

% Map X onto Polynomial Features and Normalize
X_poly = polyFeatures(X(:,3), p); % Third column [ADJUST AS NECESSARY]
[X_poly, mu, sigma] = featureNormalize(X_poly);  % Normalize
X_poly = [ones(m, 1), X_poly];                   % Add Ones

% Map X_poly_test and normalize (using mu and sigma)
X_poly_test = polyFeatures(Xtest(:,3), p); % Third column [ADJUST AS NECESSARY]
X_poly_test = bsxfun(@minus, X_poly_test, mu);
X_poly_test = bsxfun(@rdivide, X_poly_test, sigma);
X_poly_test = [ones(size(X_poly_test, 1), 1), X_poly_test];         % Add Ones

% Map X_poly_val and normalize (using mu and sigma)
X_poly_val = polyFeatures(Xval(:,3), p); % Third column [ADJUST AS NECESSARY]
X_poly_val = bsxfun(@minus, X_poly_val, mu);
X_poly_val = bsxfun(@rdivide, X_poly_val, sigma);
X_poly_val = [ones(size(X_poly_val, 1), 1), X_poly_val];           % Add Ones

fprintf('Normalized Training Example 1:\n');
fprintf('  %f  \n', X_poly(1, :));
#}
fprintf('\nProgram paused. Press enter to plot learning curve for polynomial regression.\n');
pause;

%% =========== Part 7: Learning Curve for Polynomial Regression =============
%  Now, you will get to experiment with polynomial regression with multiple
%  values of lambda. The code below runs polynomial regression with 
%  lambda = 0. You should try running the code with different values of
%  lambda to see how the fit and learning curve change.
%

lambda = 1;
[theta] = trainLinearReg(X_poly, y, lambda);

% Plot training data and fit
figure(1);
plot(X, y, 'rx', 'MarkerSize', 10, 'LineWidth', 1.5);
plotFit(min(X), max(X), mu, sigma, theta, p);
xlabel('Change in water level (x)');
ylabel('Water flowing out of the dam (y)');
title (sprintf('Polynomial Regression Fit (lambda = %f)', lambda));

figure(2);
[error_train, error_val] = ...
    learningCurve(X_poly, y, X_poly_val, yval, lambda);
plot(1:m, error_train, 1:m, error_val);

title(sprintf('Polynomial Regression Learning Curve (lambda = %f)', lambda));
xlabel('Number of training examples')
ylabel('Error')
axis([0 13 0 100])
legend('Train', 'Cross Validation')

fprintf('Polynomial Regression (lambda = %f)\n\n', lambda);
fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
for i = 1:m
    fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
end

fprintf('Program paused. Press enter to continue.\n');
pause;

%% =========== Part 8: Validation for Selecting Lambda =============
%  You will now implement validationCurve to test various values of 
%  lambda on a validation set. You will then use this to select the
%  "best" lambda value.
%

[lambda_vec, error_train, error_val] = ...
    validationCurve(X_poly, y, X_poly_val, yval);

close all;
figure('Position',[100,107,1250,770]);
plot(lambda_vec, error_train, lambda_vec, error_val);
legend('Train', 'Cross Validation');
xlabel('lambda');
ylabel('Error');

fprintf('lambda\t\tTrain Error\tValidation Error\n');
for i = 1:length(lambda_vec)
	fprintf(' %f\t%f\t%f\n', ...
            lambda_vec(i), error_train(i), error_val(i));
end

fprintf('Program paused. Press enter to continue.\n');
pause;
