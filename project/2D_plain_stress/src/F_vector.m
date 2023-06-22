% Assemble the force vector in this function
% input:
% X_a    : nodal vector
% Load   : traction on each node
% l_area : surface area associated with each node
% output:
% F      : the global force vector
function [F]=F_vector(X_a,Load,l_area)
  n_node = length(l_area);
  F = zeros(2*n_node,1);
  for i_node = 1:n_node
    area_i = l_area(i_node);
    if area_i ~= 0
      F(2*i_node-1) = 0; % x direction with no traction
      F(2*i_node  ) = -0.5*Load*area_i;
    end
  end
    
end



    