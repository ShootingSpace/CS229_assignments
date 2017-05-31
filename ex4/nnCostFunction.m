function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

      
Y=y;
%YY = eye(num_labels)(y,:); 
y=zeros(m, num_labels);

for i = 1: m
  for c = 1:num_labels
    if Y(i) == c
       y(i,c)=1;
    endif;
  end;
end;

X1 = [ones(m, 1) X];
X2 = [ones(m, 1) sigmoid(X1*Theta1')];
h=sigmoid(X2*Theta2');
for c = 1:num_labels
    J = J  -1/m* ( y(:,c)'*log(h(:,c)) + (1-y(:,c))'*log(1-h(:,c)) ) ;
end;
t1=Theta1;
t1(:,1)=0;
t1=t1(:);
t2=Theta2;
t2(:,1)=0;
t2=t2(:);
J=J+lambda*0.5/m *((t1'*t1)+(t2'*t2));
%grad = 1/m* X'*( g - y) + lambda/m*t;

%for i=1:m
 % a1=X1(i,:);
  %a2=X2(i,:);
  %a3=h(i,:);
  %delta3=a3-y(i,:);
  %delta2=delta3*Theta2(:,2:end).* sigmoidGradient(a1*Theta1');
  %delta2=delta2(:,2:end);
  %Theta2_grad =Theta2_grad+ (delta3'*a2);
  %Theta1_grad =Theta1_grad+ (delta2'*a1);
%end;
a1=[ones(m, 1) X];
a2=[ones(m, 1) sigmoid(a1*Theta1')];
a3=h;
delta3=a3-y;
delta2=delta3*Theta2(:,2:end).* sigmoidGradient(a1*Theta1');
%%最后整理！！！
Theta2_grad = (delta3'*a2)/m;
Theta1_grad = (delta2'*a1)/m;
Theta2_grad(:,2:end) = Theta2_grad(:,2:end)+((lambda/m)*Theta2(:,2:end));
Theta1_grad(:,2:end) = Theta1_grad(:,2:end)+((lambda/m)*Theta1(:,2:end));

%size(Theta2_grad)
%size(Theta1_grad)

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
