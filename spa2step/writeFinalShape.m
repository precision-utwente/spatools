function writeFinalShape(manifolds,axisref,geomref,c,fid)

    shells_str = sprintf('#%i,',manifolds);
    shells_str(end) = [];
    fprintf(fid,'#%i = ADVANCED_BREP_SHAPE_REPRESENTATION('''',(%s,#%i),#%i);\n', ...
        c,shells_str,axisref,geomref);

end