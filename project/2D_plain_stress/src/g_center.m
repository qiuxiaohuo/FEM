% Calculate the barycenter and surface area of each element
%
% input:
% x_a  : coordinates of all the nodes
% elem : connectivity table
%
% output:
% xg   : barycenters of all the elements
% Area : surface areas of all the elements
function [xg,Area]=g_center(x_a,elem)
  % state variables
  n_elem = size(elem, 1);
  xg     = zeros(n_elem, 2);
  Area   = zeros(n_elem, 1);

  for i_elem = 1:n_elem
    elem_coord = x_a(elem(i_elem,:), :);
    elem_pgon = polyshape(elem_coord);
    [xg(i_elem,1),xg(i_elem,2)] = centroid(elem_pgon);
    Area(i_elem) = area(elem_pgon);
  end
end