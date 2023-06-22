clear
h = [1 0.5 0.2 0.05];
tri = [-0.010911 -0.018148 -0.025767 -0.028301 -0.028474];
tri_x = [0.0024477 0.0046386 0.0069098 0.0076489 0.0076989];
qua = [-0.036174 -0.029344 -0.028554 -0.028517];

tri = abs(tri(1:end-1)-tri(end));
tri_x = abs(tri_x(1:end-1)-tri_x(end));
tri = sqrt(tri.^2 + tri_x.^2);
qua = abs(qua(1:end-1)-qua(end));

h_tri = [1 0.5 0.2 0.05];
h_qua = [0.5 0.2 0.05];

fit_tri = fit(log(h_tri)',log(tri)','poly1');
fit_qua = fit(log(h_qua)',log(qua)','poly1');

f1 = figure;
f2 = figure;

figure(f1)
loglog(h_tri, exp(fit_tri.p2).*h_tri.^(fit_tri.p1),'--')
hold on
str_legend = strcat('$\alpha = ',num2str(fit_tri.p1),'$');
loglog(h_tri,tri,'*')

legend({str_legend,''},'Interpreter','latex','Box','off')
xticks(fliplr(h_tri))
xlabel('$h$','Interpreter','latex')
ylabel('$||u-u^{\star}||_2$','Interpreter','latex')

saveas(gcf,'./figs/error_tri.png')


figure(f2)
loglog(h_qua, exp(fit_qua.p2).*h_qua.^(fit_qua.p1),'--')
hold on
str_legend = strcat('$\alpha = ',num2str(fit_qua.p1),'$');
loglog(h_qua,qua,'*')

legend({str_legend,''},'Interpreter','latex','Box','off')
xticks(fliplr(h_qua))
xlabel('$h$','Interpreter','latex')
ylabel('$|u_y-u^{\star}|$','Interpreter','latex')

saveas(gcf,'./figs/error_qua.png')
