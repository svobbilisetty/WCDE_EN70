BEGIN_SYMBOL_DEFINITIONS
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	<!-- CATALOGDSC Table -->
	COLS:CATALOGDSC=CATALOGDSC:*

END_SYMBOL_DEFINITIONS

<!-- 
	========================================================== 
     Search the attribute dictionary attribute that matches the specified search
	 criteria. 
	 1: attribute is searchable and can be indexed to search engine.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[search()]
	base_table=CATALOG
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=Description/Name:254
	param=CatalogIdentifier/ExternalIdentifier/Identifier:254

	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$
		
		FROM
				CATALOG, STORECAT, $ATTR_TBLS$
				        	
        WHERE
        		STORECAT.CATALOG_ID=CATALOG.CATALOG_ID AND
        		STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
              	CATALOG.$ATTR_CNDS$
		ORDER BY 
              	CATALOG.CATALOG_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry and of attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogDetail
	base_table=CATALOG
	sql=

		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		
		FROM
				CATALOG
					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
						AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
			        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
			        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				        	
        WHERE
              	CATALOG.CATALOG_ID IN ($ENTITY_PKS$)
		ORDER BY 
              	CATALOG.CATALOG_ID				

END_ASSOCIATION_SQL_STATEMENT

BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=CATALOG
	  associated_sql_statement=IBM_CatalogDetail
    END_ENTITY
END_PROFILE
