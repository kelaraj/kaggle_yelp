function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% linear hypothesis calc
h_theta = X * theta;

% cost function
J = 1 / (2 * m) * sum((h_theta - y) .^ 2);

% the bias can't be regularizated... because it's a regularizator!
theta1 = [0 ; theta(2:size(theta), :)];

% penalty (regularization)
Reg = lambda * sum(theta1 .^ 2) / (2 * m);

J = J + Reg;

grad =  ( X' * (h_theta - y) + lambda*theta1 ) / m;

end