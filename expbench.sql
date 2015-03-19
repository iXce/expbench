CREATE OR REPLACE FUNCTION update_updated_column() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated = now();
    RETURN NEW; 
END;
$$ language 'plpgsql';
CREATE TRIGGER update_experiments_modtime BEFORE UPDATE ON experiments FOR EACH ROW EXECUTE PROCEDURE  update_updated_column();
