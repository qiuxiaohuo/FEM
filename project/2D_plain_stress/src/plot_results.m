function plot_results(X_a,elem,P,d,h,N,flag,node_id,x_seed_e,y_seed_e)

  [elements,NNE]=size(elem);
  [nodes,sp]=size(X_a);
  
  x=zeros(nodes,1);
  y=zeros(nodes,1);
  x1=zeros(nodes,1);
  y1=zeros(nodes,1);
  
  for i=1:nodes
    x(i,1)=X_a(i,1);
    y(i,1)=X_a(i,2);
    
    % Deformed coordinates
    x1(i)=x(i)+h*d(i*sp-1);
    y1(i)=y(i)+h*d(i*sp);
  end

  % plot v_A
  idx_A = node_id(1,end);
  x_A(idx_A,1)=X_a(idx_A,1);
  y_A(idx_A,1)=X_a(idx_A,2);
  v_A = d(2*idx_A);
  u_A = d(2*idx_A-1);
  
  DDD=max(x(:));
  HHH=max(y(:));
  
%1.  Deformed shape
  
  figure
  if flag==1
    triplot(elem,x,y,'b')
    hold on
    triplot(elem,x1,y1,'r')
    str_plot = strcat('$u_A=(',num2str(u_A),',',num2str(v_A),')$');
    plot(x_A,y_A,'o')
    text(x_A-0.5,y_A+0.1,str_plot,'Interpreter','latex');
    axis equal
    str_fig_name = strcat('./figs/disp_',num2str(x_seed_e),'_',num2str(y_seed_e),'_tri.png');
    saveas(gcf,str_fig_name)
  elseif flag==2
    quadplot(elem,x,y,'b'), 
    hold on
    quadplot(elem,x1,y1,'r')
    str_plot = strcat('$u_A=(',num2str(u_A),',',num2str(v_A),')$');
    plot(x_A,y_A,'o')
    text(x_A-0.5,y_A+0.1,str_plot,'Interpreter','latex');
    axis equal
    str_fig_name = strcat('./figs/disp_',num2str(x_seed_e),'_',num2str(y_seed_e),'_qua.png');
    saveas(gcf,str_fig_name)
  end
  
%2.  Pressure

  % Pressure in nodes
  PP=zeros(nodes,1);
  for i=1:elements
    p=N{i};
    for j=1:NNE
      PP(elem(i,j))=PP(elem(i,j))+P(i)*p(j);
    end                     
  end
    
    
    [xg1,yg1]=meshgrid(0:0.1:DDD,0:0.1:HHH);

    figure
    Pr=griddata(x,y,PP(:)/9800,xg1,yg1,'cubic'); % Hydrostatic Pressure [m]
    surf(xg1,yg1,Pr)
    view(0,90)
    p_bar = colorbar;
    ylabel(p_bar,'Hydrostatic Pressure (m)','FontSize',10,'Rotation',270);
    axis([0,DDD,0,HHH])
    axis equal
    drawnow
    switch flag
      case 1
        str_fig_name = strcat('./figs/pres_',num2str(x_seed_e),'_',num2str(y_seed_e),'_tri.png');
        saveas(gcf,str_fig_name)
      case 2
        str_fig_name = strcat('./figs/pres_',num2str(x_seed_e),'_',num2str(y_seed_e),'_qua.png');
        saveas(gcf,str_fig_name)
    end

end