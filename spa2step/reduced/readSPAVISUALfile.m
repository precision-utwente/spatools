
function fstrm = readSPAVISUALfile(fname,ext)
% read information from SPV-file or VISUALIZATION section in DAT-file
    
    fstrm = [];
    
    fid = fopen(sprintf('%s.%s', fname, ext),'rt');
    if fid<0
        if strcmpi(ext,'dat')
            error('SPAVISUAL:FileMissing','Unable to open %s.%s',fname,ext);
        end
        return
    end

    try
        fstrm = char(fread(fid, '*uint8')');
    catch e % the try-catch combination makes sure the file is always closed
        fclose(fid);
        error(e);
    end
    fclose(fid);

    % discard everything prior to the VISUALIZATION section
    [start_match,end_match] = regexpi(fstrm,'[\n\r]\s*visualization\s*');
    if isempty(start_match) && strcmpi(ext,'dat')
        fstrm = [];
    end
    if ~isempty(start_match)
        % NOTE: the VISUALIZATION keyword and any following whitespace is also
        % discarded
        fstrm = fstrm(end_match+1:end);
    end
    
    if ~isempty(fstrm)
        fstrm = deblank(fstrm); % remove any trailing whitespace from FSTRM
        % convert to cell array of strings, each cell contains a single line
        fstrm = regexpi(fstrm,'([^\n\r]+)[\n\r]|([^\n\r]+)$','tokens');
    end
end