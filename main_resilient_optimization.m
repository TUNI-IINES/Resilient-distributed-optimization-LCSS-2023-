clear all
clc

tspan=[0,15];%check the suitable time
beta=150;%%%controller gain for resiliency
betaa=beta;%%gain for gradient, in virtual network based betaa=beta
alpha=1;%1-> with our virtual network, 0-> standard distributed opt protocol
%%%%%attacks
a=0;%1 -> constant attack; 0-> dynamic attacks
ap=1;%1->attack on physical; 0-> no attack on physical (only for dynamic attacks)
av=1;%1 -> attack on virtual; 0-> no attack on virtual (only for dynamic attacks)

L=[2 -1 0 -1;-1 2 -1 0;0 -1 2 -1;-1 0 -1 2];
n=length(L);
x0=[0.1622;0.7943;0.3112;0.4;0;0;0;0;0;0;0;0];
if a==1
    X0=x0;
else
    d=3*[.5;-.6;-.8;1];%initial value of d
    X0=[x0;d];%dynamics d
end

%%%design attack dynamics%%%%%
da=9*[.5;-.6;-.8;.9;.4;-.7;1;-1];
D1=-.5*eye(n);
D2=-0.3*eye(n);
B=[0.5 1 0.9 0.4;0.4 1 0.9 1.2;0.8 1.1 0.3 1;-0.5 1 0.6 -0.8];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%solve the ODE
[tt,Y]=ode45(@resilience_optimization,tspan,X0,[],n,beta,betaa,alpha,ap,av,L,D1,D2,B,da,a);

%%%%%%attack identification on link (2,1) by node 1 (information from node 2 that affects link (2,1)) 
porx=1;%portion of d injected from node 2 on link(2,1)
porz=1;
y1tilde_21=Y(:,2)+(porx*Y(:,9));
y2tilde_21=beta*Y(:,6)+(porx*Y(:,9));
y3tilde_21=Y(:,6)+(beta*Y(:,2))+(porz*Y(:,13));

xhat21=(1/beta)*(y3tilde_21-(y2tilde_21/beta));

abs_er_21=abs(xhat21-y1tilde_21);%compute absolute error of (18)

%%%%%%attack identification on link (3,1) by node 1 (information from node 3 that affects link (3,1)) 
porx=0;%portion of d injected from node 2 on link(2,1)
porz=0;
y1tilde_31=Y(:,3)+(porx*Y(:,9));
y2tilde_31=beta*Y(:,7)+(porx*Y(:,9));
y3tilde_31=Y(:,7)+(beta*Y(:,3))+(porz*Y(:,13));

xhat31=(1/beta)*(y3tilde_31-(y2tilde_31/beta));

abs_er_31=abs(xhat31-y1tilde_31);%compute absolute error of(18)

%%%attack identification by node 1
figure(3)
subplot(2,1,1)
plot(tt, abs_er_21,'r-','linewidth',1.5);
ylabel('$|\hat{x}_2^1(t)-y_{12,1}^a(t)|$', 'Interpreter','latex','FontSize',16)
subplot(2,1,2)
plot(tt, abs_er_31,'r-','linewidth',1.5);
ylabel('$|\hat{x}_3^1(t)-y_{13,1}^a(t)|$', 'Interpreter','latex','FontSize',16)
ylim([-1 1])
xlabel('Time (Seconds)','FontSize',16);
%%%%%%%%%%%%%%%%%%%plotting all the results%%%%%%%%%%%%%%%%%%%%%%%
figure(1)%%plot x
plot(tt, Y(:,1),'k-','linewidth',1.5);
hold on
plot(tt, Y(:,2),'b-','linewidth',1.5);
plot(tt, Y(:,3),'m-','linewidth',1.5);
plot(tt, Y(:,4),'r-','linewidth',1.5);
hold off 
ylabel('$x_i$', 'Interpreter','latex','FontSize',16);
xlabel('Time (Seconds)','FontSize',16);
