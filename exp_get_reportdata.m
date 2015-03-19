function report = exp_get_reportdata(exp_id)
    conn = db_connect();
    res = db_query(conn, sprintf('SELECT encode(reportdata, ''hex'') FROM experiments WHERE id = %d;', exp_id));
    res.next();
    rawdata = char(res.getString(1));
    report = getArrayFromByteStream(uint8(hex2dec(reshape(rawdata, 2, numel(rawdata)/2)')));
    conn.close();
end
