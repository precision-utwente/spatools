clear

addpath('../sp15ex')
addpath('../spaplus');
addpath('../spascripting/');
model_name = 'strip';

init_build('3D')

force = [0 60 5];
dens = 7800;
thick = 0.5e-3;
width = 40e-3;
length = 80e-3;
emod = 200e9;
pois = 0.3;
smod = emod/(2*(1+pois));

inert = calc_inertia('rect',dens,[thick width]);
stiffn = calc_stiffness('rect',[emod smod],[thick width],1);

strip = add_beam([0 0 0],[length 0 0],2,[],{inert,stiffn},[0 0 1]);
        
add_constrdofs('fix',[],{'trans' strip(1) 'p'})
add_constrdofs('fix',[],{'rot' strip(1) 'p'})
add_constrdofs('dyne',strip)

add_nodalloads('xf',[],{'trans' strip(end) 'q'},force);

vis = [setbeamvis(strip,thick,width);];
                
build_model(model_name,[],vis)
spacar(-7,model_name)
spavisual(model_name)

s.x = x;
s.ln = ln;
s.lnp = lnp;
s.le = le;
s.rxyz = rxyz;
s.el = strip;
s.l = length;
s.w = width;
s.t = thick;
s.e = e;

% % % save('stripres','s')