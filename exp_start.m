fprintf('You are about to launch %d jobs/ %d runs.\n', ceil(nruns / group_by), nruns);
expname = input('Please name this experiment: ', 's');
expsuffix = datestr(now, 'dd-mm-yy_HH-MM-SS');

expparams = [];
for field_i = 1:numel(fields)
    expparams.(fields{field_i}) = eval(fields{field_i});
end
expparams_string = evalc('expparams');

conn = db_connect();
expname_san = strrep(expname, '''', '''''');
expparams_string_san = strrep(expparams_string, '''', '''''');
res = db_query(conn, sprintf('INSERT INTO experiments (name, njobs, nruns, suffix, params) VALUES (''%s'', %d, %d, ''%s'', ''%s'') RETURNING id;', expname_san, ceil(nruns / group_by), nruns, expsuffix, expparams_string_san));
res.next();
exp_id = res.getInt(1);
conn.close();
