CREATE OR REPLACE FUNCTION cool_event()
  RETURNS event_trigger
 LANGUAGE plpgsql
  AS $$
BEGIN
  RAISE EXCEPTION 'Hello, world!';
END;
$$;

CREATE EVENT TRIGGER cool_trigger ON ddl_command_start
   EXECUTE PROCEDURE cool_event();