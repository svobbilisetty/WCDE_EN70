<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2011                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->


<!-- ========================================================================= -->
<!--  Insert search related statistics                                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Admin_Insert_InsertSearchStatistics
    base_table=SRCHSTAT
    dbtype=any
	sql=
    INSERT INTO SRCHSTAT
           (SRCHSTAT_ID, KEYWORD, LANGUAGE_ID, STOREENT_ID, CATALOG_ID, KEYWORDCOUNT, SEARCHCOUNT, SUGGESTIONCOUNT, SUGGESTION, LOGDETAIL, LOGDATE)
    VALUES (?SRCHSTAT_ID?, ?KEYWORD?, ?LANGUAGE_ID?, ?STOREENT_ID?, ?CATALOG_ID?, ?KEYWORDCOUNT?, ?SEARCHCOUNT?, ?SUGGESTIONCOUNT?, ?SUGGESTION?, ?LOGDETAIL?, ?LOGDATE?)
	dbtype=oracle
	sql=
    INSERT INTO SRCHSTAT
           (SRCHSTAT_ID, KEYWORD, LANGUAGE_ID, STOREENT_ID, CATALOG_ID, KEYWORDCOUNT, SEARCHCOUNT, SUGGESTIONCOUNT, SUGGESTION, LOGDETAIL, LOGDATE)
    VALUES (?SRCHSTAT_ID?, ?KEYWORD?, ?LANGUAGE_ID?, ?STOREENT_ID?, ?CATALOG_ID?, ?KEYWORDCOUNT?, ?SEARCHCOUNT?, ?SUGGESTIONCOUNT?, ?SUGGESTION?, ?LOGDETAIL?, TO_TIMESTAMP(?LOGDATE?, 'YYYY-MM-DD hh24:mi:ss.ff'))
	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for delta or full update from the catalog group delta update table -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_DELTA_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE (TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
	 	    AND TI_DELTA_CATGROUP.CATGROUP_ID = ?catalogGroupId?
		    AND TI_DELTA_CATGROUP.ACTION = 'U')
	    OR (TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
		    AND TI_DELTA_CATGROUP.ACTION = 'F')			
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for only full update from the catalog group delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATGROUP.ACTION = 'F'	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for any action from the catalog group delta update table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_ANY_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Count any action from the catalog entry delta update table               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_CATENTRY_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT COUNT(*) as ROWCOUNT
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Count any action from the catalog group delta update table               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT COUNT(*) as ROWCOUNT
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine if indexing is being performed                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.CATGROUP_ID, TI_DELTA_CATGROUP.LASTUPDATE 
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATGROUP.ACTION = 'P'
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Delete a row into the catalog group delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
	DELETE FROM TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Insert a row into the catalog group delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
	INSERT INTO TI_DELTA_CATGROUP (MASTERCATALOG_ID, CATGROUP_ID, ACTION) 
	VALUES (?masterCatalogId?, ?catalogGroupId?, ?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Find catalog entry in TI_DELTA_CATENTRY table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
    SELECT ACTION FROM TI_DELTA_CATENTRY
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Find catalog group in TI_DELTA_CATGROUP table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
    SELECT ACTION FROM TI_DELTA_CATGROUP
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Update catalog entry in TI_DELTA_CATENTRY table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
    UPDATE TI_DELTA_CATENTRY
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Update catalog group in TI_DELTA_CATGROUP table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
    UPDATE TI_DELTA_CATGROUP
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine immediate parent category for cache invalidation on product    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_PARENT_CATEGORY_FOR_PRODUCT
	base_table=CATGPENREL
	sql=
	SELECT CATGROUP_ID, CATALOG_ID
	  FROM CATGPENREL
	 WHERE CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine immediate parent category for cache invalidation on category   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_PARENT_CATEGORY_FOR_CATEGORY
	base_table=CATGRPREL
	sql=
	SELECT CATGROUP_ID_PARENT, CATALOG_ID
	  FROM CATGRPREL
	 WHERE CATGROUP_ID_CHILD = ?catalogGroupId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Insert a row into the cache invalidation table                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_CACHEIVL
	base_table=CACHEIVL
	sql=
	INSERT INTO CACHEIVL (DATAID, INSERTTIME) 
	VALUES (?dataId?, ?insertTime?)
	dbtype=oracle
	sql=
    INSERT INTO CACHEIVL (DATAID, INSERTTIME)
	VALUES (?dataId?, TO_TIMESTAMP(?insertTime?, 'YYYY-MM-DD hh24:mi:ss.ff'))
END_SQL_STATEMENT
