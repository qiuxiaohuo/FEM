% Calculate the B matrix for all the elements in this function
%
% input:
% x_a  : coordinates of all the nodes
% elem : connectivity table
% xg   : barycenters of all the elements
% Area : surface areas of all the elements
% flag : 1 for linear shape function or triangular elements; 
%        2 for bilinear shape function or quadrilateral elements
%
% output:
% B: the B matrix for all the elements
% p: values of the shape function at the barycenter of each element
function [B,p]=B_matrix(x_a,elem,xg,Area,flag)
        
    [~,sp]=size(x_a); % dimension of nodal freedom

     if flag==1
         [dp,p]=linear_interpolation(elem,xg,Area,x_a);
     elseif flag==2
         [dp,p]=bilinear_interpolation(elem,xg,Area,x_a);
     end
     
    [B]=bm(dp,elem,sp);

end

% This function calculates the value of a linear shape function and the derivative of
% the linear shape function at the barycenters of triangular elements
% input:
% elem : connectivity table
% xg   : barycenters of all the elements
% Area : surface areas of all the elements
% x_a  : coordinates of all the nodes
% output:
% p    : values of the linear shape function at the barycenters of the elements
% dp   : derivatives of the linear shape function at the barycenters of the elements
function [dp,p]=linear_interpolation(elem,xg,Area,X_a)

  [elements,~]=size(elem);

  for i=1:elements
    x1=X_a(elem(i,1),1);
    x2=X_a(elem(i,2),1);
    x3=X_a(elem(i,3),1);
    y1=X_a(elem(i,1),2);
    y2=X_a(elem(i,2),2);
    y3=X_a(elem(i,3),2);
    
    N(1,1)=xg(i,1)*(y2-y3)+xg(i,2)*(x3-x2)+(x2*y3-x3*y2);
    N(2,1)=xg(i,1)*(y3-y1)+xg(i,2)*(x1-x3)+(x3*y1-x1*y3);
    N(3,1)=xg(i,1)*(y1-y2)+xg(i,2)*(x2-x1)+(x1*y2-x2*y1);
    
    p(i)={N/2/Area(i)};
    
    dN(1,1)=y2-y3;
    dN(1,2)=x3-x2;
    dN(2,1)=y3-y1;
    dN(2,2)=x1-x3;
    dN(3,1)=y1-y2;
    dN(3,2)=x2-x1;
           
    dp(i)={dN/2/Area(i)};
  end

end

% This function calculates the value of a bilinear shape function and the derivative of
% the bilinear shape function at the barycenters of quadrilateral elements
% input:
% elem : connectivity table
% xg   : barycenters of all the elements
% Area : surface areas of all the elements
% x_a  : coordinates of all the nodes
% output:
% p    : values of the bilinear shape function at the barycenters of the elements
% dp   : derivatives of the bilinear shape function at the barycenters of the elements
function [dp,p]=bilinear_interpolation(elem,xg,Area,X_a)

  [n_elem,n_node_of_elem]=size(elem);
  [~,sp]=size(X_a);

  for i=1:n_elem        
    N(1)=0.25;
    N(2)=0.25;
    N(3)=0.25;
    N(4)=0.25;
    
    p(i)={N};

    z=[0. 0.];

    for j=1:n_node_of_elem
      for k=1:sp
        xx(j,k)=X_a(elem(i,j),k);
      end
    end
    
    % Ni derivatives respect natural coordinates "z1" & "z2":
    dN_i = [(z(2)-1)  (-z(2)+1)  (1+z(2))  (-1-z(2));
            (z(1)-1)  (-z(1)-1)  (1+z(1))  (1-z(1))]/4;
    % Jacobian Matrix:
    J = dN_i*xx;
    detJ = det(J);

    dN = J\dN_i;
           
    dp(i)={dN'};
  end

end

% This function forms the B matrix for each element
% input:
% dp   : derivatives of the shape functions of each node evaluated at the
%        barycenters of the elements
% elem : connectivity table
% sp   : dimension of the problem
% output:
% B: the B matrix of all the elements
function [B]=bm(dp,elem,sp)
  [n_elem,n_node_elem]=size(elem);

  for i_elem = 1:n_elem
    dp_i = dp{i_elem};
    pNpx = dp_i(:,1);
    pNpy = dp_i(:,2);
    
    B_i = [];
    for i_node = 1:n_node_elem
      pnpx = pNpx(i_node);
      pnpy = pNpy(i_node);
      B_node = [pnpx    0;
                   0 pnpy;
                pnpy pnpx];
      B_i = [B_i,B_node];
    end

    B(i_elem) = {B_i};
  end

end