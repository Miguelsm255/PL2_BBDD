--CREATE TABLE auditoria (
--  accion text,
--  fecha timestamp	 
--);

-- Se crea la función que se ejecutará 

CREATE OR REPLACE FUNCTION fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
  DECLARE
  --  no declaro nada porque no me hace falta...de hecho DECLARE podría haberlo omitido en éste caso
  BEGIN
  -- Se determina que acción a activado el trigger e inserta un nuevo valor en la tabla dependiendo
  -- del dicha acción
  -- Junto con la acción se escribe fecha y hora en la que se ha producido la acción
   IF TG_OP='INSERT' THEN
     INSERT INTO auditoria VALUES ('alta',current_timestamp);  -- Cuando hay una inserción
   ELSIF TG_OP='UPDATE'	THEN
     INSERT INTO auditoria VALUES ('modificación',current_timestamp); -- Cuando hay una modificación
   ELSEIF TG_OP='DELETE' THEN
     INSERT INTO auditoria VALUES ('borrado',current_timestamp); -- Cuando hay un borrado
   END IF;	 
   RETURN NULL;
  END;
$fn_auditoria$ LANGUAGE plpgsql;



-- Se crea el trigger que se dispara cuando hay una inserción, modificación o borrado en la tabla sala

CREATE TRIGGER tg_auditoria after INSERT or UPDATE or DELETE
  ON SALA FOR EACH ROW
  EXECUTE PROCEDURE fn_auditoria(); 

