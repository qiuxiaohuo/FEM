function plot_node_number(node_id,X_a)
%plot_node plot node number text
  
  [n_node_x, n_node_y] = size(node_id);
  hold on
  for ix = 1:n_node_x
    for iy = 1:n_node_y
      idx_node = node_id(ix,iy);
      coord_node = X_a(idx_node,:);
      str_plot = strcat('node ',num2str(idx_node));
      plot(coord_node(1),coord_node(2),'ko','MarkerSize',8);
      text(coord_node(1),coord_node(2),str_plot);
    end
  end
  hold off
end