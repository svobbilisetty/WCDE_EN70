BEGIN_SYMBOL_DEFINITIONS

	
	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	COLS:CATENTRY:MARKFORDELETE=CATENTRY:MARKFORDELETE
	COLS:CATENTRY:BASEITEM_ID=CATENTRY:BASEITEM_ID

	<!-- CATENTSUBS table -->
	COLS:CATENTSUBS=CATENTSUBS:*
		
	<!-- CATCONFINF table -->
	COLS:CATCONFINF=CATCONFINF:*

	<!-- CATENTSHIP table -->
	COLS:CATENTSHIP=CATENTSHIP:*
	
	<!-- Other tables -->		
	COLS:CATENTRYATTR=CATENTRYATTR:*
	COLS:ATTRVAL=ATTRVAL:*
	COLS:ATTRVALDESC=ATTRVALDESC:*
	
	<!-- Calculation code tables -->
	COLS:CALCODE=CALCODE:*
	COLS:CATENCALCD=CATENCALCD:*

	<!-- CATENTDESCOVR table -->
	COLS:CATENTDESCOVR=CATENTDESCOVR:*
		
	<!-- CATOVRGRP table -->
	COLS:CATOVRGRP=CATOVRGRP:*
		

	
END_SYMBOL_DEFINITIONS

<!-- ====================================================================== 
	Get the attribute records associated with a catalog entry, by attribute Id for all languages
	@param UniqueID The catalog entry id 
	@param attrId The dictionary attribute id
=========================================================================== -->
<!-- Get the attribute records associated with a catalog entry, by attribute Id for all languages --> 
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[AttributeIdentifier[(UniqueID=)]]]+IBM_Admin_CatalogEntryAttributeUpdate
	base_table=CATENTRYATTR
	sql=
		SELECT 
	     			CATENTRYATTR.$COLS:CATENTRYATTR$,ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$
	     	FROM
	     			CATENTRYATTR LEFT OUTER JOIN ATTRVAL ON CATENTRYATTR.ATTRVAL_ID=ATTRVAL.ATTRVAL_ID LEFT OUTER JOIN ATTRVALDESC ON ATTRVAL.ATTRVAL_ID=ATTRVALDESC.ATTRVAL_ID
	     										  
	     	WHERE
					CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND
					CATENTRYATTR.ATTR_ID IN (?attrId?)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog entry attribute relationship records associated with a catalog entry, attribute and different usage type.
	@param UniqueID The catalog entry id 
	@param attrId The dictionary attribute id
	@param usage The usage type
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[(@usage=) and AttributeIdentifier[(UniqueID=)]]]+IBM_Admin_CatalogEntryAttributeForDifferentAttributeUsage
	base_table=CATENTRYATTR
	sql=
		SELECT 
	     			CATENTRYATTR.$COLS:CATENTRYATTR$
	     	FROM
	     			CATENTRYATTR 
	     										  
	     	WHERE
					CATENTRYATTR.CATENTRY_ID=?UniqueID? AND
					CATENTRYATTR.ATTR_ID=?attrId? AND
					CATENTRYATTR.USAGE<>?usage?
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog entry attribute relationship records associated with a catalog entry, based on catentry id and attribute id.
	@param UniqueID The catalog entry id 
	@param attrId The dictionary attribute id
	
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[AttributeIdentifier[(UniqueID=)]]]+IBM_Admin_CatalogEntryAttributeRelationship
	base_table=CATENTRYATTR
	sql=
		SELECT 
	     			CATENTRYATTR.$COLS:CATENTRYATTR$
	     	FROM
	     			CATENTRYATTR 
	     										  
	     	WHERE
					CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND
					CATENTRYATTR.ATTR_ID IN (?attrId?)
					
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Find catalog entry calculation code by calculation code and store
	@param calcodeId The calculation code id
	@param storeId The store identifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntryCalculationCode[(@calcodeId=) and (@storeId=)]+IBM_Admin_IdResolve
	base_table=CATENCALCD
	sql=
		SELECT 
			CATENCALCD.$COLS:CATENCALCD$
		FROM 
			CATENCALCD 
		WHERE 
			CALCODE_ID = ?calcodeId? AND
			STORE_ID = ?storeId?
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Find calculation code identifier by code, usage type and store
	@param code The calculation code name
	@param calUsageId The calculation usage type identifier
	@param storeId The store identifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Calcode[(@code=) and (@calUsageId=) and (@storeId=)]+IBM_Admin_IdResolve
	base_table=CALCODE
	sql=
		SELECT
			CALCODE.$COLS:CALCODE$
		FROM
			CALCODE 
		WHERE
			CODE = ?code? AND
			CALUSAGE_ID = ?calUsageId? AND
			STOREENT_ID = ?storeId?
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the description override of the catalog entry based on the description
	override unique id.
	@param UniqueID The description override unique id    
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Description/Override[DescriptionOverrideIdentifier[(UniqueID=)]]+IBM_Admin_CatalogEntryDescriptionOverrideUpdate
	base_table=CATENTDESCOVR		
	sql=
		SELECT 
	     			CATENTDESCOVR.$COLS:CATENTDESCOVR$
	     	FROM
	     			CATENTDESCOVR
	     										  
	     	WHERE
				CATENTDESCOVR.CATENTDESCOVR_ID IN (?UniqueID?)
						 
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the description override of the catalog entry and related override group information
	based on the description override unique id.
	@param UniqueID The description override unique id         
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Description/Override[DescriptionOverrideIdentifier[(UniqueID=)]]+IBM_Admin_CatalogEntryDescriptionOverrideWithOverrideGroup
	base_table=CATENTDESCOVR		
	sql=
		SELECT 
	     			CATENTDESCOVR.$COLS:CATENTDESCOVR$, CATOVRGRP.$COLS:CATOVRGRP$
	     	FROM
	     			CATENTDESCOVR
	     			JOIN CATOVRGRP ON CATENTDESCOVR.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID 
	     										  
	     	WHERE
					CATENTDESCOVR.CATENTDESCOVR_ID IN (?UniqueID?)
						 
END_XPATH_TO_SQL_STATEMENT



<!-- ====================================================================== 
	Get the description override of the catalog entry based on the catalog entry id, language id and the override group id.
	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
	@param massocTypeId The association type id
	@param massocId The semantic specifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/Description[(@languageID=)]/Override+IBM_Admin_IdResolve
	base_table=CATENTDESCOVR
	sql=
			SELECT 
	     				CATENTDESCOVR.$COLS:CATENTDESCOVR$, CATOVRGRP.$COLS:CATOVRGRP$
	     	FROM
	     				CATENTDESCOVR
							JOIN CATOVRGRP ON CATENTDESCOVR.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID 
								AND CATOVRGRP.STOREENT_ID=$CTX:STORE_ID$ 			     				
	     	WHERE
						CATENTDESCOVR.CATENTRY_ID = ?UniqueID? 
						AND CATENTDESCOVR.LANGUAGE_ID =?languageID?

						
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				CATENTSUBS.$COLS:CATENTSUBS$,
				CATCONFINF.$COLS:CATCONFINF$
		FROM
		    CATENTRY
		      LEFT OUTER JOIN CATENTSUBS ON (CATENTRY.CATENTRY_ID = CATENTSUBS.CATENTRY_ID)
					LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID) 		      
		WHERE
		    CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithShipment
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				CATENTSHIP.$COLS:CATENTSHIP$
		FROM
		    CATENTRY
		      LEFT OUTER JOIN CATENTSHIP ON (CATENTRY.CATENTRY_ID = CATENTSHIP.CATENTRY_ID) 
		WHERE
		    CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithCalculationCode
	base_table=CATENTRY
	sql=
		SELECT
			CATENTRY.$COLS:CATENTRY$, CATENCALCD.$COLS:CATENCALCD$, CALCODE.$COLS:CALCODE$
		FROM
			CATENTRY, CATENCALCD, CALCODE
		WHERE
			CATENTRY.CATENTRY_ID = CATENCALCD.CATENTRY_ID AND
			CALCODE.CALCODE_ID = CATENCALCD.CALCODE_ID AND
			CATENCALCD.STORE_ID = $CTX:STORE_ID$ AND
			CATENCALCD.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== 
	Get the basic information of the catalog entry (CATENTRY and CATENTSUBS 
	table) based on the catalog entry id 
=========================================================================== -->

BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryUpdate
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_RootCatalogEntryWithShipment
      associated_sql_statement=IBM_RootCatalogEntryWithCalculationCode
    END_ENTITY
END_PROFILE







