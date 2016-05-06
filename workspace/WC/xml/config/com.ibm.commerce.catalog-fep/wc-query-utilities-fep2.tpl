<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2010                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->


<!-- ========================================================================= -->
<!--  Check for delta or full update from the catalog entry delta update table -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_DELTA_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE (TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
	 	    AND TI_DELTA_CATENTRY.CATENTRY_ID = ?catalogEntryId?
		    AND TI_DELTA_CATENTRY.ACTION = 'U')
	    OR (TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
		    AND TI_DELTA_CATENTRY.ACTION = 'F')			
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for only full update from the catalog entry delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATENTRY.ACTION = 'F'	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for any action from the catalog entry delta update table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_ANY_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine if indexing is being performed                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.CATENTRY_ID, TI_DELTA_CATENTRY.LASTUPDATE 
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATENTRY.ACTION = 'P'
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Delete a row into the catalog entry delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
	DELETE FROM TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Insert a row into the catalog entry delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
	INSERT INTO TI_DELTA_CATENTRY (MASTERCATALOG_ID, CATENTRY_ID, ACTION) 
	VALUES (?masterCatalogId?, ?catalogEntryId?, ?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Select a scope from search configuration table                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONF
	base_table=SRCHCONF
	sql=
	SELECT SRCHCONF.LANGUAGES,
		   SRCHCONF.CONFIG
	  FROM SRCHCONF
	 WHERE SRCHCONF.INDEXTYPE = ?indexType?
	   AND SRCHCONF.INDEXSCOPE = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Select all scopes from search configuration table                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ALL_SRCHCONF
	base_table=SRCHCONF
	sql=
	SELECT DISTINCT SRCHCONF.INDEXSCOPE
	  FROM SRCHCONF
	 WHERE SRCHCONF.INDEXTYPE = ?indexType?	
END_SQL_STATEMENT
