<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2012, 2013                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->


<!-- ========================================================================= -->
<!--  Get the max key id from table SRCHPROPRELV                              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_MAX_KEY_ID_SRCHPROPRELV
	base_table=SRCHPROPRELV
	sql=
	SELECT MAX(SRCHPROPRELV_ID) AS MAXID
	  FROM SRCHPROPRELV
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the index field and relevancy value from table SRCHPROPRELV         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_INDEXFIELD_INFORMATION_QUERY
	base_table=SRCHPROPRELV
	sql=
	SELECT INDEXFIELD, RELVALUE
	FROM SRCHPROPRELV
	WHERE CATALOG_ID=?catalogId? AND CATGROUP_ID=?catgroupId? AND STOREENT_ID=?storeentId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the SRCHPROPRELV id from table SRCHPROPRELV                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHPROPRELV_ID_QUERY
	base_table=SRCHPROPRELV
	sql=
	SELECT SRCHPROPRELV_ID
	FROM SRCHPROPRELV
	WHERE CATALOG_ID=?catalogId? AND CATGROUP_ID=?catgroupId? AND STOREENT_ID=?storeId? AND INDEXFIELD=?srchfieldName?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a record into SRCHPROPRELV                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_SRCHPROPRELV
	base_table=SRCHPROPRELV
	sql=
	INSERT INTO SRCHPROPRELV
	(SRCHPROPRELV_ID, CATGROUP_ID, CATALOG_ID, STOREENT_ID, RELVALUE, INDEXFIELD)
	VALUES
	(?srchproprelvId?, ?catgroupId?, ?catalogId?, ?storeId?, ?relValue?, ?srchfieldName?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a record for SRCHPROPRELV                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_SRCHPROPRELV
	base_table=SRCHPROPRELV
	sql=
	DELETE FROM SRCHPROPRELV
	WHERE INDEXFIELD = ?srchfieldName?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Resolve FFMCENTER_ID from STLFFMREL table giving STLOC_ID       		   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STLFFMREL
	base_table=STLFFMREL
	sql=
	SELECT FFMCENTER_ID
	  FROM STLFFMREL
	 WHERE STLOC_ID = ?stloc_id?
END_SQL_STATEMENT

<!-- ======================================================================================= -->
<!--  Retrieve search configuration for given master catalog by all store's default language -->
<!-- ======================================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONF_DEFAULT
	base_table=SRCHCONF
	dbtype=any
	sql=
	SELECT STORECAT.CATALOG_ID,
	       STORE.LANGUAGE_ID,
	       SRCHCONF.INDEXSCOPE,
		   SRCHCONF.CONFIG
	  FROM STORECAT, STORE, SRCHCONF
	 WHERE STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STORE.STORE_ID
	   AND STORE.STATUS = 1
	   AND CHAR(STORECAT.CATALOG_ID) = SRCHCONF.INDEXSCOPE
	   AND SRCHCONF.INDEXTYPE = ?indexType?
	dbtype=oracle
	sql=
	SELECT STORECAT.CATALOG_ID,
	       STORE.LANGUAGE_ID,
	       SRCHCONF.INDEXSCOPE,
		   SRCHCONF.CONFIG
	  FROM STORECAT, STORE, SRCHCONF
	 WHERE STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STORE.STORE_ID
	   AND STORE.STATUS = 1
	   AND TO_CHAR(STORECAT.CATALOG_ID) = SRCHCONF.INDEXSCOPE
	   AND SRCHCONF.INDEXTYPE = ?indexType?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable, searchable, or merchandisable       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, IDENTIFIER
	FROM ATTR
	WHERE ATTR_ID = ?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable, searchable, or merchandisable       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_WORKSPACE
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, IDENTIFIER
	FROM $SCHEMA$.ATTR
	WHERE ATTR_ID = ?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable or searchable or merchandisable      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_IDENTIFIER
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, ATTR_ID
	FROM ATTR
	WHERE IDENTIFIER = ?identifier?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable or searchable or merchandisable      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_IDENTIFIER_WORKSPACE
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, ATTR_ID
	FROM $SCHEMA$.ATTR
	WHERE IDENTIFIER = ?identifier?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the catalog entry delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATALOGENTRY_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATENTRY.ACTION = 'F' OR TI_DELTA_CATENTRY.ACTION = 'B'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the catalog group delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATALOGGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATGROUP.ACTION = 'F' OR TI_DELTA_CATGROUP.ACTION = 'B'	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Restart cache invalidation                                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=RESTART_CACHEIVL
	base_table=CACHEIVL
	sql=
	INSERT INTO CACHEIVL (TEMPLATE, DATAID, INSERTTIME) 
	VALUES ('restart:', ?dataId?, ?insertTime?)
	dbtype=oracle
	sql=
    INSERT INTO CACHEIVL (TEMPLATE, DATAID, INSERTTIME)
	VALUES ('restart:', ?dataId?, TO_TIMESTAMP(?insertTime?, 'YYYY-MM-DD hh24:mi:ss.ff'))
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve search configuration table                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONFEXT
	base_table=SRCHCONFEXT
	sql=
	SELECT CONFIG,
		   INDEXSUBTYPE
	  FROM SRCHCONFEXT
	 WHERE INDEXTYPE = ?indexType?
	   AND (LANGUAGE_ID = ?langId? OR LANGUAGE_ID is null)
	   AND INDEXSCOPE = ?masterCatalogId?	
END_SQL_STATEMENT