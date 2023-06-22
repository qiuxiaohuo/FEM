% This function assembles the global stiffness matrix
% input:
% B: the B matrix for all the elements
% elem: connectivity table
% x_a: coordinates of all the nodes
% jacobians: determinant of jacobians for all the elements
% properties: material property vector
% output:
% K: the global stiffness matrix
function [K]=K_matrix(B,elem,X_a,area,properties)
  %% get parameters
  n_node = size(X_a,1);
  [n_elem,n_node_elem] = size(elem);
  E = properties(1);
  nu = properties(2);

  %% construct stiffness matrix for 2D plane stress problem
  % plane stress
  D = E/(1-nu^2).*[1  nu 0;
                   nu 1  0;
                   0  0  (1-nu)/2];
  % plane strain
  % G=E/2/(1+nu);
  % lam=2*G/(1-2*nu);
  % D=[lam*(1-nu)     lam*nu         0;
  %     lam*nu        lam*(1-nu)     0;
  %     0                   0        G];

  %% assembly K matrix of system
  K = zeros(2*n_node,2*n_node);
  for i_elem = 1:n_elem
    K_e = B{i_elem}.'*D*B{i_elem}.*area(i_elem);
    map_node_loc2glb = elem(i_elem,:);
    for i_loc = 1:n_node_elem
      for j_loc = 1:n_node_elem
        i_glb = map_node_loc2glb(i_loc);
        j_glb = map_node_loc2glb(j_loc);
        entry = K_e(2*i_loc-1:2*i_loc, 2*j_loc-1:2*j_loc);
        K(2*i_glb-1:2*i_glb, 2*j_glb-1:2*j_glb)...
        = K(2*i_glb-1:2*i_glb, 2*j_glb-1:2*j_glb) + entry;
      end
    end
  end

end

