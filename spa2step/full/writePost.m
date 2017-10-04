function writePost(fid)

    postcode = fileread('step-post.txt');
    fprintf(fid,'\n%s',postcode);
    
end