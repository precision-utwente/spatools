function [] = getElLine(s,xp,zq,Rp,Rq,L )

%[r,~,vy,vz] = elasticLine(0,xp,xq,Rp,Rq,L,shearCoef(FlexElemNrs(i),5:6),3)
%input needed: model_name,rxyz,it,ln,x,lnp
   
    node_nrs = ln(beam_el(i),:);
   

    
    lp = x(lnp(node_nrs(2),1:4));
    lq = x(lnp(node_nrs(4),1:4));
    
    Lp = [-lp(2)  lp(1) -lp(4)  lp(3); ...
        -lp(3)  lp(4)  lp(1) -lp(2); ...
        -lp(4) -lp(3)  lp(2)  lp(1)];
    Llp = [-lp(2)  lp(1)  lp(4) -lp(3); ...
        -lp(3) -lp(4)  lp(1)  lp(2); ...
        -lp(4)  lp(3) -lp(2)  lp(1)];
    
    sc = diag(1./sqrt(diag(Rp'*Rp)));


    Lq = [-lq(2)  lq(1) -lq(4)  lq(3); ...
        -lq(3)  lq(4)  lq(1) -lq(2); ...
        -lq(4) -lq(3)  lq(2)  lq(1)];
    Llq = [-lq(2)  lq(1)  lq(4) -lq(3); ...
        -lq(3) -lq(4)  lq(1)  lq(2); ...
        -lq(4)  lq(3) -lq(2)  lq(1)];
  
    sc = diag(1./sqrt(diag(Rq'*Rq)));
   
    
    Ri = reshape(rxyz(beam_el(i),:),3,3);
    Rpg = Rp*Ri;
    Rqg = Rq*Ri;
    
    u = xp*(2*s.^3-3*s.^2+1) + l*Rpg(:,1)*(s.^3-2*s.^2+s) ...
        + xq*(-2*s.^3+3*s.^2) + l*Rqg(:,1)*(s.^3-s.^2);
    
    
end

end