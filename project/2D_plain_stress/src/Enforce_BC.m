% Enforce the displacement boundary conditions in this function
% input:
% F: the original force vector
% K: the original stiffness matrix
% boundary:
% disp:
% x_a: the coordinates of all the nodes
% output:
% F: modified force vector
% K: modified stiffness matrix
function [F,K]=Enforce_BC(F,K,boundary,disp,x_a)
  for i_deg = 1:length(boundary)
    is_constraint = boundary(i_deg);
    if is_constraint
      disp_i = disp(i_deg);
      if disp_i == 0 % constraint displacement is zero
        K(i_deg,:) = 0;
        K(:,i_deg) = 0;
        K(i_deg,i_deg) = 1;
        F(i_deg) = 0;
      else
        error("")
      end
    end
  end

end