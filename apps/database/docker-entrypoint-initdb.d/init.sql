CREATE FUNCTION createdbs( names TEXT[] ) RETURNS void as $$

DECLARE
    name TEXT;

BEGIN
    FOREACH name IN ARRAY names LOOP
        raise notice 'name: %', name;
    END LOOP;
END;

$$ language plpgsql;

SELECT createdbs( array['authservice','userdatastore','accesscontrol','wagtail_1','wagtail_2'] );
