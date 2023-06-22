% Set up the boundary conditions
% input:
% `x_a`: the coordinates of all the nodes
% elem: connectivity table
% output:
% boundary: boolean flag for each nodal displacement in x and y direction,
% 1 for constrained, 0 for free
% disp: prescribed nodal displacement in x and y direction
% l_area: surface area for each node
function [boundary,disp,l_area]=Boundary_conditions(x_a,elem,node_id,A,B)
    
  [boundary,disp]=displa(x_a,A,node_id);  
  [l_area]=dist(x_a,B,node_id);
end

% Set up the displacement boundary conditions in this function
% input:
% X_a: coordinates of all the nodes
% A: prescribed displacement boundary condition
% output:
% bdry: boolean flag for each nodal displacement in x and y direction, 1 for constrained, 0 for free
% disp: prescribed nodal displacement in x and y direction
function [bdry,disp]=displa(X_a,A,node_id)
  % initial variables
  n_node = size(X_a, 1);
  bdry = zeros(2*n_node, 1);
  disp     = zeros(2*n_node, 1);

  switch A(1)
    case 1 % row constraint
      node_constraint = node_id(A(2),:);
      
      for i_node = 1:n_node
        % initial bdry_i and disp_i
        bdry_i = zeros(2,1);
        disp_i = zeros(2,1);
        if ismember(i_node,node_constraint)
          switch A(3)
            case 1 % x direction constrained
              bdry_i(1) = 1; disp_i(1) = A(4);
            case 2 % y direction constrained
              bdry_i(2) = 1; disp_i(2) = A(4);
            case 3 % x,y direction constrained
              bdry_i(1) = 1; disp_i(1) = 0;
              bdry_i(2) = 1; disp_i(2) = 0;
            otherwise
              error("")
          end
        end

        bdry(2*i_node-1:2*i_node) = bdry_i;
        disp(2*i_node-1:2*i_node) = disp_i;
      end
    case 2 % column constraint
      node_constraint = node_id(:,A(2));

      for i_node = 1:n_node
        bdry_i = zeros(2,1);
        disp_i = zeros(2,1);
        if ismember(i_node,node_constraint)
          switch A(3)
            case 1 % x direction constrained
              bdry_i(1) = 1; disp_i(1) = A(4);
            case 2 % y direction constrained
              bdry_i(2) = 1; disp_i(2) = A(4);
            case 3 % x,y direction constrained
              bdry_i(1) = 1; disp_i(1) = 0;
              bdry_i(2) = 1; disp_i(2) = 0;
            otherwise
              error("")
          end
        end

        bdry(2*i_node-1:2*i_node) = bdry_i;
        disp(2*i_node-1:2*i_node) = disp_i;
      end
    otherwise
      error("")
  end
end

% Calculate the surface area associated with each node
% If the node is not a surface node and does not belong to the Neumann 
% boundary conditions, its surface area is initialized as 0
% input:
% x_a: coordinates of all the nodes
% elem: connectivity table
% B: prescribed traction boundary condition
% output:
% l_area: the surface area associated to each node
function [l_area]=dist(X_a,B,node_id)
  n_node = size(X_a,1);
  l_area = zeros(n_node,1);

  switch B(1)
    case 1 % row constraint
      node_constraint = node_id(B(2),:);
      for i_node = 1:n_node
        k = find(node_constraint==i_node, 1);
        if isempty(k)
          continue
        end

        if k == 1
          node_a = node_constraint(k);
          node_b = node_constraint(k+1);
          l_area(i_node) = X_a(node_b,1) - X_a(node_a,1);
        elseif k == length(node_constraint)
          node_a = node_constraint(k-1);
          node_b = node_constraint(k);
          l_area(i_node) = X_a(node_b,1) - X_a(node_a,1);
        else
          node_a = node_constraint(k-1);
          node_b = node_constraint(k+1);
          l_area(i_node) = X_a(node_b,1) - X_a(node_a,1);
        end
      end
    case 2 % column constraint
      node_constraint = node_id(:,B(2));
      for i_node = 1:n_node
        k = find(node_constraint==i_node, 1);
        if isempty(k)
          continue
        end

        if k == 1
          node_a = node_constraint(k);
          node_b = node_constraint(k+1);
          l_area(i_node) = X_a(node_b,2) - X_a(node_a,2);
        elseif k == length(node_constraint)
          node_a = node_constraint(k-1);
          node_b = node_constraint(k);
          l_area(i_node) = X_a(node_b,2) - X_a(node_a,2);
        else
          node_a = node_constraint(k-1);
          node_b = node_constraint(k+1);
          l_area(i_node) = X_a(node_b,2) - X_a(node_a,2);
        end
      end
    otherwise
      error("")
  end
  
  

end