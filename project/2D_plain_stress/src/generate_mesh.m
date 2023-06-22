function [x_a,elem,node_id]=generate_mesh(flag, x_seed_e, y_seed_e, ledge, redge, height)
%generate_mesh Mesh generation
% Initialize the nodal position and construct the connectivity table
  
  %% generate node, use same node for two type meshes
  % seed number of element -> seed number of node
  x_seed_n = x_seed_e + 1;
  y_seed_n = y_seed_e + 1;

  % seed left and right edge
  node_x = linspace(height(1),height(2),x_seed_n)';
  ledge_seed = linspace(ledge(2), ledge(1), y_seed_n)';
  redge_seed = linspace(redge(2), redge(1), y_seed_n)';
  
  % assembly coordinate matrix {x_a} and id matrix {node_id}
  x_a     = [];
  % {node_id} is a [x_seed_n,y_seed_n] matrix, x_seed_n is seed number of
  % x axis, y_seed_n is seed number of y axis. {node_id} stores geometry
  % distribution of nodal points
  node_id = zeros(y_seed_n,x_seed_n);
  c_node  = 0; % node counter

  for idx_seed = 1:y_seed_n
    node_y = linspace(ledge_seed(idx_seed),redge_seed(idx_seed),x_seed_n)';
    x_a = [x_a; 
           node_x, node_y];

    c_node_0 = c_node + 1; % start index of node
    c_node = c_node + length(node_y); % end index of node
    node_id(idx_seed,:) = c_node_0:1:c_node;
  end

  %% generate element
  switch flag
    case 1 % triangular element
      n_elem = 0;
      % number element row by row
      for idx_y = 1:y_seed_e
        for idx_x = 1:x_seed_e
          n_elem = n_elem + 1;
          elem(n_elem, :) = [node_id(idx_y  , idx_x);
                             node_id(idx_y+1, idx_x);
                             node_id(idx_y+1, idx_x+1);]';
          n_elem = n_elem + 1;
          elem(n_elem, :) = [node_id(idx_y  , idx_x);
                             node_id(idx_y+1, idx_x+1);
                             node_id(idx_y  , idx_x+1);]';
        end
      end
    case 2 % quadrilateral element
      n_elem = 0;
      % number element row by row
      for idx_y = 1:y_seed_e
        for idx_x = 1:x_seed_e
          n_elem = n_elem + 1;
          elem(n_elem, :) = [node_id(idx_y+1, idx_x);
                             node_id(idx_y+1, idx_x+1);
                             node_id(idx_y  , idx_x+1);
                             node_id(idx_y  , idx_x);]';
          % elem(n_elem, :) = [node_id(idx_y+1, idx_x);
          %          node_id(idx_y, idx_x);
          %          node_id(idx_y  , idx_x+1);
          %          node_id(idx_y+1  , idx_x+1);]';
        end
      end
    otherwise
      error('Unexpected mesh type. No mesh created.')
  end


    
end