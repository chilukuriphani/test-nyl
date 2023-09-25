SET SEARCH_PATH = 'public';

CREATE TABLE IF NOT EXISTS be_policy_alert(	
	policy_number  nchar(8) NOT NULL,
	triggertype  nchar(30) NOT NULL,
	triggerdisplayname	 nchar(80) NULL,
	CONSTRAINT pk_be_policy_alert PRIMARY KEY 	
(	
	policy_number,
	triggertype
)
);

DO 
$$
BEGIN
	IF NOT EXISTS(select * from information_schema.table_privileges where table_name = 'be_policy_alert' and grantee = 'berole'
				 and privilege_type = 'SELECT') THEN
		GRANT SELECT ON be_policy_alert TO berole;
	END IF;
END
$$;

DO 
$$
BEGIN
	IF has_table_privilege('berole', 'be_policy_alert', 'INSERT') THEN
		GRANT INSERT ON be_policy_alert TO berole;
	END IF;
	
	IF has_table_privilege('berole', 'be_policy_alert', 'UPDATE') THEN
		GRANT UPDATE ON be_policy_alert TO berole;
	END IF;
	
	IF has_table_privilege('berole', 'be_policy_alert', 'DELETE') THEN
		GRANT DELETE ON be_policy_alert TO berole;
	END IF;
END
$$;
