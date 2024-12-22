function Y=resilience_optimization(t,x,n,beta,betaa,alpha,ap,av,L,D1,D2,B,d,a)

if a==1
A=[-L ((-1)^(alpha+1))*beta*L;((-1)^(alpha))*beta*L -alpha*((L)+(eye(n)))];%resilient
Y=A*x-[(betaa)*(0.8*x(1)-4);(betaa)*(1.2*x(2)+2);(betaa)*(0.4*x(3)+3);(betaa)*(1.6*x(4)-5);0;0;0;0]+([eye(n) zeros(n);zeros(n) eye(n)]*d);%resilient with d and d'
else
A=[-L ((-1)^(alpha+1))*beta*L ap*eye(n) zeros(n);((-1)^(alpha))*beta*L -alpha*((L)+(eye(n))) zeros(n) av*eye(n);B zeros(n) D1 zeros(n);B zeros(n) zeros(n) D2];%resilient
Y=A*x-[(betaa)*(0.8*x(1)-4);(betaa)*(1.2*x(2)+2);(betaa)*(0.4*x(3)+3);(betaa)*(1.6*x(4)-5);0;0;0;0;0;0;0;0;0;0;0;0];%resilient with dynamics d and d'
end
