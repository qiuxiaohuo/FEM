function plot_elem_number(X_a,elem)
%plot_elem_number
  [n_elem, ~] = size(elem);
  hold on
  for i_elem = 1:n_elem
    idx_node_elem = elem(i_elem,:);
    coord_elem = X_a(idx_node_elem,:);
    coord_plot = mean(coord_elem,1); % average of column
    str_plot = strcat('elem ',num2str(i_elem));
    text(coord_plot(1),coord_plot(2),str_plot);
  end
  hold off
end