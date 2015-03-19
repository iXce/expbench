function res = db_query(conn, query)
    prepared = conn.prepareStatement(query);
    if nargout == 1
        res = prepared.executeQuery();
    else
        prepared.execute();
    end
end
