BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->	
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	
	COLS:CATENTRY:ITEMSPC_ID=CATENTRY:ITEMSPC_ID
	
	COLS:CATENTRY_BASE_ATTRS=CATENTRY:CATENTRY_ID,MFNAME
	
	<!-- CATGROUP table -->
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID

	<!-- STORECGRP table -->
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID		
	
	<!-- CATENTDESC table -->
	COLS:CATENTDESC=CATENTDESC:*

	<!-- CATENTREL table -->	
	COLS:CATENTRY_ID_CHILD=CATENTREL:CATENTRY_ID_CHILD
	COLS:CATENTRY_ID_PARENT=CATENTREL:CATENTRY_ID_PARENT	
	
	COLS:CATENTREL=CATENTREL:*
	COLS:CATGPENREL=CATGPENREL:*
	
	COLS:LISTPRICE=LISTPRICE:*
	
	<!-- STORECENT table -->
	COLS:STORECENT:STOREENT_ID=STORECENT:STOREENT_ID
	COLS:STORECENT:CATENTRY_ID=STORECENT:CATENTRY_ID		
	COLS:STORECENT=STORECENT:*
		
	<!-- ATTRIBUTE table -->
    COLS:ATTRIBUTE=ATTRIBUTE:*
	
    <!-- ATTR table -->
	COLS:ATTR=ATTR:*   
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:*    
    	
    <!-- CATENTRYATTR table -->		
	COLS:CATENTRYATTR=CATENTRYATTR:*	
	
	<!-- CATENTSUBS table -->
	COLS:CATENTSUBS=CATENTSUBS:*
	
	<!-- ATTRVALUE table -->
	COLS:ATTRVALUE=ATTRVALUE:ATTRVALUE_ID, LANGUAGE_ID, ATTRIBUTE_ID, OPERATOR_ID, SEQUENCE, CATENTRY_ID, NAME, STRINGVALUE, INTEGERVALUE, FLOATVALUE, FIELD1, IMAGE1, IMAGE2, FIELD2, FIELD3, OID, QTYUNIT_ID, ATTACHMENT_ID
	
	<!-- ATTRVAL table -->	
	COLS:ATTRVAL=ATTRVAL:*
	
	<!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*
	
	<!-- FACET table -->
	COLS:FACET=FACET:*  
	
	<!-- Dynamic kit related table -->
	COLS:CATCONFINF=CATCONFINF:*
	COLS:DKPDCCATENTREL=DKPDCCATENTREL:*
	COLS:DKPREDEFCONF=DKPREDEFCONF:*
	COLS:DKPDCCOMPLIST=DKPDCCOMPLIST:*
	
	<!-- OFFER table -->
	COLS:OFFER=OFFER:*
	
	<!-- OFFERPRICE table -->
	COLS:OFFERPRICE=OFFERPRICE:*
	
	<!-- Calculation code tables -->
	COLS:CALCODE=CALCODE:*
	COLS:CATENCALCD=CATENCALCD:*
	
	<!-- CATENTDESCOVR table -->
	COLS:CATENTDESCOVR=CATENTDESCOVR:*
		
	
	
END_SYMBOL_DEFINITIONS


<!-- ===================================================================================== -->
<!-- ================================ GET CATENTRY BEGINS ================================ -->
<!-- ===================================================================================== -->



<!-- ========================================================================= -->
<!-- =============================SUB SELECT QUERIES========================== -->
<!-- ========================================================================= -->

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- given the specified search criteria for the parent catgroup.  -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The parent catgrouop unique identifier.     -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param STOREPATH:catalog- The catalog storepath               -->
<!-- @param CTX:CATALOG_ID - The catalog for which to retrieve     -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and ParentCatalogGroupIdentifier[(UniqueID=)]]
	base_table=CATENTRY
	sql=
		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		 LEFT OUTER JOIN
		CATGPENREL ON
			(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
		 LEFT OUTER JOIN
		CATGROUP ON
			(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID) 	 
	WHERE
		CATENTRY.MARKFORDELETE = 0 AND 	
		CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND
		CATGROUP.CATGROUP_ID IN (?UniqueID?) AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)				
		
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get dynamic kit configuration base information based on catentry id.
	@param UniqueId The catentry id of the dynamic kit.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitConfigInfo_Get
	base_table=CATENTRY
	param=versionable
	sql=
		SELECT 
							CATENTRY.$COLS:CATENTRY$,		
	     				CATCONFINF.$COLS:CATCONFINF$,
	     				DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	     				DKPREDEFCONF.$COLS:DKPREDEFCONF$
	     	FROM
	     	
					CATENTRY
		      	LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID) 			     	
	     			LEFT OUTER JOIN DKPDCCATENTREL ON (CATENTRY.CATENTRY_ID = DKPDCCATENTREL.CATENTRY_ID AND DKPDCCATENTREL.SEQUENCE=0)
	     			LEFT OUTER JOIN DKPREDEFCONF ON (DKPDCCATENTREL.DKPREDEFCONF_ID = DKPREDEFCONF.DKPREDEFCONF_ID) 		 						  
	     	WHERE
						CATENTRY.CATENTRY_ID in (?UniqueID?)
						
    
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get dynamic kit configuration base and component information based on catentry id.
	@param UniqueId The catentry id of the dynamic kit.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitConfigComponent_Get
	base_table=CATENTRY
	param=versionable
	sql=
		SELECT 
							CATENTRY.$COLS:CATENTRY$,		
	     				CATCONFINF.$COLS:CATCONFINF$,
	     				DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	     				DKPREDEFCONF.$COLS:DKPREDEFCONF$,
	     				DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST$,
	     				CHILD_CATENTRY.$COLS:CATENTRY$,
	     				CHILD_CATENTDESC.$COLS:CATENTDESC$,
	     				CHILD_STORECENT.$COLS:STORECENT$
	     	FROM
	     	
					CATENTRY
		      	LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID)	     	
	     			LEFT OUTER JOIN DKPDCCATENTREL ON (CATENTRY.CATENTRY_ID = DKPDCCATENTREL.CATENTRY_ID AND DKPDCCATENTREL.SEQUENCE=0)
	     			LEFT OUTER JOIN DKPREDEFCONF ON (DKPDCCATENTREL.DKPREDEFCONF_ID = DKPREDEFCONF.DKPREDEFCONF_ID) 		 		
	     			LEFT OUTER JOIN DKPDCCOMPLIST ON (DKPDCCOMPLIST.DKPREDEFCONF_ID = DKPDCCATENTREL.DKPREDEFCONF_ID)	
	     			LEFT OUTER JOIN CATENTRY CHILD_CATENTRY ON (CHILD_CATENTRY.CATENTRY_ID = DKPDCCOMPLIST.CATENTRY_ID)					 
	     			LEFT OUTER JOIN CATENTDESC CHILD_CATENTDESC ON (CHILD_CATENTDESC.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
	     			LEFT OUTER JOIN STORECENT CHILD_STORECENT ON (CHILD_STORECENT.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) )

	     	WHERE
						CATENTRY.CATENTRY_ID in (?UniqueID?)
						
    
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get dynamic kit configuration base and component information based on catentry id.
	This query will be used to retrieve information under the content version.
	@param UniqueId The catentry id of the dynamic kit.
=========================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitConfigComponent_Get_Version
	base_table=CATENTRY
	param=versionable
	sql=
	SELECT 
					$VERSION$.CATENTRY.$COLS:CATENTRY$,		
	     				$VERSION$.CATCONFINF.$COLS:CATCONFINF$,
	     				$VERSION$.DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	     				$VERSION$.DKPREDEFCONF.$COLS:DKPREDEFCONF$,
	     				$VERSION$.DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST$,
	     				CHILD_CATENTRY.$COLS:CATENTRY$,
	     				CHILD_CATENTDESC.$COLS:CATENTDESC$,
	     				CHILD_STORECENT.$COLS:STORECENT$

	     	FROM
	     	
					$VERSION$.CATENTRY
					
		      	LEFT OUTER JOIN $VERSION$.CATCONFINF ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.CATCONFINF.CMVERSNINFO_ID AND $VERSION$.CATENTRY.CATENTRY_ID = $VERSION$.CATCONFINF.CATENTRY_ID)	     	
	     			LEFT OUTER JOIN $VERSION$.DKPDCCATENTREL ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.DKPDCCATENTREL.CMVERSNINFO_ID AND $VERSION$.CATENTRY.CATENTRY_ID = $VERSION$.DKPDCCATENTREL.CATENTRY_ID AND $VERSION$.DKPDCCATENTREL.SEQUENCE=0)
	     			LEFT OUTER JOIN $VERSION$.DKPREDEFCONF ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.DKPREDEFCONF.CMVERSNINFO_ID AND $VERSION$.DKPDCCATENTREL.DKPREDEFCONF_ID = $VERSION$.DKPREDEFCONF.DKPREDEFCONF_ID) 		 		
	     			LEFT OUTER JOIN $VERSION$.DKPDCCOMPLIST ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.DKPDCCOMPLIST.CMVERSNINFO_ID AND  $VERSION$.DKPDCCOMPLIST.DKPREDEFCONF_ID =  $VERSION$.DKPDCCATENTREL.DKPREDEFCONF_ID)	
	     			LEFT OUTER JOIN CATENTRY CHILD_CATENTRY ON (CHILD_CATENTRY.CATENTRY_ID = $VERSION$.DKPDCCOMPLIST.CATENTRY_ID)					 
	     			LEFT OUTER JOIN CATENTDESC CHILD_CATENTDESC ON (CHILD_CATENTDESC.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
	     			LEFT OUTER JOIN STORECENT CHILD_STORECENT ON (CHILD_STORECENT.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) )
	     			
	     	WHERE
						$VERSION$.CATENTRY.CATENTRY_ID in (?UniqueID?) AND $VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION_ID$

    
END_XPATH_TO_SQL_STATEMENT



<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) in the store.                                         -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_DataExtract					   					   -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]]]
	base_table=CATENTRY
	className=com.ibm.commerce.catalogentry.facade.server.services.dataaccess.db.jdbc.CatalogEntryDataExtractSQLComposer
	sql=
			SELECT 
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY 
					JOIN
					STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID)
					
			WHERE
					CATENTRY.CATENTTYPE_ID != 'ItemBean' AND CATENTRY.CATENTTYPE_ID != 'BundleBean'
					AND CATENTRY.BUYABLE=1 AND 
					CATENTRY.MARKFORDELETE=0 AND
					STORECENT.STOREENT_ID IN (?UniqueID?)		
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which refer to the given catalog entry (unique        -->
<!-- identifier) through a Bundle/Kit association.                 -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- dkMark: The token used to replace the dynamic kit related SQLs.  -->
<!-- @param catalogEntryTypeCode - The catentry type for which     -->
<!--        to retrieve. Can be 'BundleBean' or 'DynamicKitBean'   -->
<!--        for bundle and kits respectively.                      -->     
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and KitComponent[CatalogEntryReference[CatalogEntryIdentifier[(UniqueID=)]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor	
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.KitComponentReferenceSQLComposer 
	base_table=CATENTRY
	param=dkMark_AddDynamikKitRelatedQuery	
	sql=
	
	SELECT CATENTRY_ID FROM
  (

		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY
				JOIN 
				CATENTREL ON
					(CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT)
		WHERE
               CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?) AND
               CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AddDynamikKitRelatedQuery
	) T1 ORDER BY T1.CATENTRY_ID               
         
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) including the category level SKUs in the store.                                         -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_DataExtract					   					   -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] and IncludeCategoryLevelSKU]
	base_table=CATENTRY
	className=com.ibm.commerce.catalogentry.facade.server.services.dataaccess.db.jdbc.CatalogEntryDataExtractSQLComposer
	sql=
                   SELECT 
                         CATENTRY.$COLS:CATENTRY_ID$
                   FROM
                         CATENTRY 
                   JOIN
                         STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN (?UniqueID?))
                                        
                   WHERE NOT EXISTS 
                         (SELECT 1 FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM') AND 
                         CATENTRY.CATENTTYPE_ID != 'BundleBean' AND 
                         CATENTRY.BUYABLE=1 AND 
                         CATENTRY.MARKFORDELETE=0       	
END_XPATH_TO_SQL_STATEMENT

<!-- ==================================

<!-- ========================================================================= -->
<!-- =============================ASSOCIATION QUERIES========================= -->
<!-- ========================================================================= -->

<!-- =============================================================================
     Adds store identifier (STORECENT table) of catalog entry to the 
     resultant data graph.                                                 
     ============================================================================= -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryStoreIdentifier
	base_table=STORECENT
	param=versionable
	sql=

		SELECT 
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			STORECENT 
		WHERE 
			STORECENT.CATENTRY_ID IN ($UNIQUE_IDS$) AND
			STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT			
<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$
		FROM
				CATENTRY
		WHERE
                CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry descrition Info 				               -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescription
	base_table=CATENTDESC
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTDESC
				        	
		WHERE
                CATENTDESC.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry description Info (all languages)            -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptionAllLanguages
	base_table=CATENTDESC
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTDESC
				        	
		WHERE
                CATENTDESC.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT 

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds parent catgroup info                                 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryToCatalogGroupRelationship
	base_table=CATGPENREL
	param=versionable
	sql=
		SELECT 
				CATGPENREL.$COLS:CATGPENREL$
		FROM
				CATGPENREL
        WHERE
        		CATGPENREL.CATENTRY_ID IN ($UNIQUE_IDS$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds identifiers (CATGROUP, STORECGRP) of catalog groups 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT     
    name=IBM_CatalogGroupIdentifier
	base_table=CATGROUP
	param=versionable
	sql=
	
		SELECT 
			CATGROUP.$COLS:CATGROUP_ID$,
			CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
			CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM 
			CATGROUP,STORECGRP 
		WHERE 
			CATGROUP.CATGROUP_ID IN ($UNIQUE_IDS$) AND CATGROUP.MARKFORDELETE = 0 AND 
			CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds parent product info of a SKU (PRODUCT_ITEM relationship)  -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_ParentCatalogEntryForRootRelationships
	base_table=CATENTREL
	param=versionable
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTREL$
		FROM
				CATENTREL
		WHERE
				CATENTREL.CATENTRY_ID_CHILD IN ($UNIQUE_IDS$) AND
				CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM'
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds identifiers (CATENTRY, STORECENT) of catalog entries 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryIdentifier
	base_table=CATENTRY
	sql=

		SELECT 
			CATENTRY.$COLS:CATENTRY_ID$,
			CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
			CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
			CATENTRY.$COLS:CATENTRY:ITEMSPC_ID$,
			CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,			
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			CATENTRY, STORECENT 
		WHERE 
			CATENTRY.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTRY.MARKFORDELETE = 0 AND 
			CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds list price (LISTPRICE) of catalog entries 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryListPrice
	base_table=LISTPRICE
	param=versionable
	sql=

		SELECT 
			LISTPRICE.$COLS:LISTPRICE$
		FROM 
			LISTPRICE 
		WHERE 
			LISTPRICE.CATENTRY_ID IN ($UNIQUE_IDS$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentsubs Info 				               							 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntrySubscription
	base_table=CATENTSUBS
	param=versionable
	sql=
		SELECT 
				CATENTSUBS.$COLS:CATENTSUBS$
		FROM 
				CATENTSUBS 
		WHERE 
        CATENTSUBS.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Adds base attributes information of catalog entry         -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
       name=IBM_CatalogEntryBaseAttributes
       base_table=CATENTRY
       additional_entity_objects=false
       sql=
              SELECT 
                            CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
              FROM
                            CATENTRY
              WHERE
                            CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds base attributes information of catalog entry's        -->
<!-- parent to the resultant data graph.                        -->
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
       name=IBM_ExistingCatalogEntryParentBaseAttributes
       base_table=CATENTRY
       additional_entity_objects=false
       sql=
              SELECT 
                            CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
              FROM
                            CATENTRY,CATENTREL              
              WHERE
							CATENTREL.CATENTRY_ID_CHILD IN ($ENTITY_PKS$) AND
							CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT AND
							CATENTRY.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds base attributes information of catalog entry's        -->
<!-- children to the resultant data graph.                      -->
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
       name=IBM_ExistingCatalogEntryChildBaseAttributes
       base_table=CATENTRY
       additional_entity_objects=false
       sql=
              SELECT 
                            CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
              FROM
                            CATENTRY,CATENTREL              
			  WHERE
							CATENTREL.CATENTRY_ID_PARENT IN ($ENTITY_PKS$) AND
							CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
							CATENTRY.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds classic attributes (ATTRIBUTE table) of               -->
<!-- catalog entries to the resultant data graph.               -->
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_CatalogEntryAttributeSchema
		base_table=ATTRIBUTE
		sql=	
			  SELECT 
							ATTRIBUTE.$COLS:ATTRIBUTE$
			  FROM
							ATTRIBUTE
			  WHERE
							ATTRIBUTE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
							ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
			  ORDER BY
							ATTRIBUTE.SEQUENCE        	
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================
     Adds allowed values of classic attributes (ATTRVALUE table) to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeAllowedValue
	base_table=ATTRVALUE
	param=versionable
	sql=
		SELECT 
			ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM 
			ATTRVALUE  
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			ATTRVALUE.CATENTRY_ID = 0 AND
			ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRVALUE.SEQUENCE
				
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds the catalog entry and attribute dictionary            -->
<!-- attribute relationship (CATENTRYATTR table)                -->                                
<!-- to the resultant data graph.                               --> 
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_CatalogEntryAttributeDictionaryAttribute
		base_table=CATENTRYATTR
		sql=
			  SELECT 
							CATENTRYATTR.$COLS:CATENTRYATTR$
			  FROM
							CATENTRYATTR
			  WHERE
							CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$)
			  ORDER BY
							CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================== --> 
<!-- Adds the base information of attribute dictionary           -->
<!-- attributes (ATTR table) to the resultant data graph.        -->                    
<!-- =========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_AttributeDictionaryAttributeSchema
		base_table=ATTR
		sql=
			  SELECT 
							ATTR.$COLS:ATTR$, FACET.$COLS:FACET$
			  FROM
							ATTR
							LEFT OUTER JOIN FACET ON ATTR.ATTR_ID=FACET.ATTR_ID
			  WHERE
							ATTR.ATTR_ID IN ($UNIQUE_IDS$) AND 
							ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================== --> 
<!-- Adds the description of attribute dictionary attributes     -->   
<!-- (ATTRDESC table) to the resultant data graph.               -->           
<!-- =========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_AttributeDictionaryAttributeSchemaDescription
		base_table=ATTRDESC
		sql=
			  SELECT 
							ATTRDESC.$COLS:ATTRDESC$
			  FROM
							ATTRDESC
			  WHERE		
							ATTRDESC.ATTR_ID IN ($UNIQUE_IDS$) AND
							ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the allowed values of attribute dictionary 
     attributes (ATTRVAL table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$							
		FROM
				ATTRVAL 
        WHERE
				ATTRVAL.ATTR_ID IN ($UNIQUE_IDS$) AND
				ATTRVAL.VALUSAGE is NOT NULL AND
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the description of the allowed values of attribute dictionary 
     attributes (ATTRVALDESC table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
							
		FROM
				ATTRVALDESC
		WHERE
	        	ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
			    ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
				ATTRVALDESC.SEQUENCE				
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds classic attribute values (ATTRVALUE table) of catalog entries     -->
<!-- to the resultant data graph.                                           -->
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeValue
	base_table=ATTRVALUE
	sql=
		SELECT 
				ATTRVALUE.$COLS:ATTRVALUE$
		FROM
				ATTRVALUE 
        WHERE
                ATTRVALUE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
                ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the schemas of classic attributes to the resultant data graph.    -->
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeSchema
	base_table=ATTRIBUTE
	sql=
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$ 
		FROM 
			ATTRIBUTE  
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the values of attribute dictionary attributes 					-->
<!-- (ATTRVAL table) to the resultant data graph.             				-->                  
<!-- ====================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValue
	base_table=ATTRVAL
	param=versionable
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
        WHERE
		        ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND 
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the description for the values of attribute dictionary attributes -->
<!-- (ATTRVALDESC table) to the resultant data graph.                       -->       
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValueDescription
	base_table=ATTRVALDESC
	param=versionable
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the values of attribute dictionary attributes 					-->
<!-- (ATTRVAL table) to the resultant data graph.             				-->                  
<!-- ====================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAllowedValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
    WHERE
		    ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND 
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.VALUSAGE IS NOT NULL

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the values of attribute dictionary attributes 					-->
<!-- (ATTRVAL table) to the resultant data graph.             				-->                  
<!-- ====================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAssignedValue
	base_table=ATTRVAL
	param=versionable
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
    WHERE
		    ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND 
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.VALUSAGE IS NULL
				
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the description for the values of attribute dictionary attributes -->
<!-- (ATTRVALDESC table) to the resultant data graph.                       -->       
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAllowedValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
				ATTRVALDESC.VALUSAGE IS NOT NULL

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the description for the values of attribute dictionary attributes -->
<!-- (ATTRVALDESC table) to the resultant data graph.                       -->       
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAssignedValueDescription
	base_table=ATTRVALDESC
	param=versionable
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
				ATTRVALDESC.VALUSAGE IS NULL 

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry and of attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
	base_table=CATENTRYATTR
	param=versionable
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
				CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		        CATENTRYATTR.ATTR_ID IN ($SUBENTITY_PKS$)
        ORDER BY
        		CATENTRYATTR.SEQUENCE, CATENTRYATTR.ATTR_ID
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL: -->
<!-- Adds list price for a given currency -->
<!-- to the resultant data graph. -->
<!-- #### Asociated SQL to DataExtract the listprice #### -->
<!-- ========================================================= -->    
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryListPriceForCurrency
	base_table=LISTPRICE
	param=versionable
	sql=

		SELECT 
			LISTPRICE.$COLS:LISTPRICE$
		FROM 
			LISTPRICE 
		WHERE 
			LISTPRICE.CATENTRY_ID IN ($UNIQUE_IDS$) AND LISTPRICE.CURRENCY IN ($CTX:CURRENCY$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL: -->
<!-- Adds offer price for a given currency -->
<!-- to the resultant data graph. -->
<!-- #### Asociated SQL to DataExtract the offerprice #### -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryOfferPriceForCurrency
	base_table=OFFER
	param=versionable
	sql=
		SELECT 
				OFFER.$COLS:OFFER$,OFFERPRICE.$COLS:OFFERPRICE$
		FROM
				OFFER,OFFERPRICE
		WHERE
        		OFFER.CATENTRY_ID IN ($UNIQUE_IDS$) AND OFFER.OFFER_ID = OFFERPRICE.OFFER_ID AND OFFERPRICE.CURRENCY IN ($CTX:CURRENCY$) AND 
			OFFER.TRADEPOSCN_ID IN (
				SELECT CATGRPTPC.TRADEPOSCN_ID 
				FROM CATGRPTPC 
				WHERE CATGRPTPC.CATALOG_ID = $CTX:CATALOG_ID$ AND CATGRPTPC.CATGROUP_ID = 0 AND 
				( CATGRPTPC.STORE_ID IN ($STOREPATH:catalog$) OR CATGRPTPC.STORE_ID = 0 ))

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry of attribute dictionary defining attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
	base_table=CATENTRYATTR
	param=versionable
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		          	CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		          	CATENTRYATTR.USAGE = '1'
        	ORDER BY
        			CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- ==========================================================
     Adds calculation codes (CATENCALCD) of catalog entries
     to the resultant data graph.
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryCalculationCode
	base_table=CATENCALCD
	sql=
		SELECT
			CATENCALCD.$COLS:CATENCALCD$, CALCODE.$COLS:CALCODE$
		FROM
			CATENCALCD, CALCODE
		WHERE
			CALCODE.CALCODE_ID = CATENCALCD.CALCODE_ID AND
			CATENCALCD.STORE_ID = $CTX:STORE_ID$ AND
			CATENCALCD.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry descrition Override Info 				               -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptionOverride
	base_table=CATENTDESCOVR
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESCOVR.$COLS:CATENTDESCOVR$
		FROM
				CATENTDESCOVR
				JOIN CATOVRGRP ON CATENTDESCOVR.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID 
							AND CATOVRGRP.STOREENT_ID=$CTX:STORE_ID$ 		        	
		WHERE
                CATENTDESCOVR.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTDESCOVR.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
END_ASSOCIATION_SQL_STATEMENT




<!-- ========================================================================= -->
<!-- 						PROFILE DEFINITIONS								   -->
<!-- ========================================================================= -->

<!-- ========================================================= -->
<!-- Catalog Entry Summary Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description summary.             -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Summary
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
      associated_sql_statement=IBM_CatalogEntryDescription      
      associated_sql_statement=IBM_CatalogEntryListPrice  
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription
      associated_sql_statement=IBM_CatalogEntryCalculationCode
      associated_sql_statement=IBM_CatalogEntryDescriptionOverride
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription
      associated_sql_statement=IBM_CatalogEntryListPrice       
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription
      associated_sql_statement=IBM_CatalogEntryCalculationCode
      associated_sql_statement=IBM_CatalogEntryDescriptionOverride
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- ==== Catalog Entry SKUs Access Profile      			   ===== -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                    	 -->
<!-- 	2) Catalog Entry price.                              		 -->
<!-- 	3) Catalog Entry Attribute Values.                       -->
<!-- 	4) Catalog Entry Attributes.                             -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntrySKUs
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier      
      associated_sql_statement=IBM_CatalogEntryListPrice 
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription
      associated_sql_statement=IBM_CatalogEntryCalculationCode
<!-- === Following SQL statements retrieves classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictonary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription

    END_ENTITY
END_PROFILE

<!-- ====================================================================================================================================================== 
  Catalog Entry Attributes Access Profile for promotion validation (returns the attribute names of product, its parent and children.)
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_ExistingCatalogEntryParentBaseAttributes - returns parent catalog entry of the root catalog entry and base attributes.
  3) IBM_ExistingCatalogEntryChildBaseAttributes - returns children catalog entries of the root catalog entry and base attributes.
  4) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry.         
  5) IBM_CatalogEntryAttributeDictionaryAttribute - returns relationship between catalog entry and attribute dictionary attribute. 
  6) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute.                                  
  7) IBM_AttributeDictionaryAttributeSchemaDescription  - returns description of attribute dictionary attribute.
  8) IBM_CatalogEntryAttributeValue - returns the values of the classic attribute of a catalog entry.
  9) IBM_AttributeSchema = returns the attribute dictionary attribute schema (definition) of the catalong entry.
 10) IBM_AttributeDictionaryAttributeValue - returns the attribute dictionary attribute values of a catalog entry.
 11) IBM_AttributeDictionaryAttributeValueDescription - returns the attribute dictionary attribute value description of a catalog entry.
============================================================================================================================================================ -->

BEGIN_PROFILE 
       name=IBM_Admin_CatalogEntryAttributeNameValues
       BEGIN_ENTITY 
       base_table=CATENTRY 
			className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
					associated_sql_statement=IBM_CatalogEntryBaseAttributes
					associated_sql_statement=IBM_ExistingCatalogEntryParentBaseAttributes
					associated_sql_statement=IBM_ExistingCatalogEntryChildBaseAttributes       
					associated_sql_statement=IBM_CatalogEntryAttributeSchema                    		 
					associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
					associated_sql_statement=IBM_AttributeDictionaryAttributeSchema          
					associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription               
					associated_sql_statement=IBM_CatalogEntryAttributeValue
					associated_sql_statement=IBM_AttributeSchema
					associated_sql_statement=IBM_AttributeDictionaryAttributeValue
					associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription		 
	   END_ENTITY
END_PROFILE

<!-- === Following access profile returns the attribute dictionary descriptive attributes of a catalog entry. Allowed values are not returned-->
BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryAttrDictDescriptiveAttributesWithoutAllowedValue_Paging
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
    END_ENTITY
END_PROFILE

BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryAttrDictDescriptiveAttributesWithoutAllowedValue_Paging_Version
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryVersionGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeAssignedValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeAllowedValueDescription      
	  associated_sql_statement=IBM_AttributeDictionaryAttributeAssignedValueDescription      
    END_ENTITY
END_PROFILE

<!-- === The IBM_Admin_Minimal returns the basic CatalogEntry information (Id, partnumber, owner) -->
BEGIN_PROFILE 
	name=IBM_Admin_Minimal
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	        
	  associated_sql_statement=IBM_CatalogEntryStoreIdentifier	        
	  associated_sql_statement=IBM_CatalogEntrySubscription
    END_ENTITY
END_PROFILE


<!-- === The IBM_Admin_SEO returns the basic CatalogEntry information (Id, partnumber, owner) PLUS SEO information -->
BEGIN_PROFILE 
	name=IBM_Admin_SEO
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	        
	  associated_sql_statement=IBM_CatalogEntryStoreIdentifier	
        associated_sql_statement=IBM_CatalogEntryDescription           
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Data Extract Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DataExtract
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
      associated_sql_statement=IBM_CatalogEntryDescription      
      associated_sql_statement=IBM_CatalogEntryListPriceForCurrency
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription
      associated_sql_statement=IBM_CatalogEntryOfferPriceForCurrency
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Data Extract Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!--    1) Catalog Entry with description.                     -->
<!--    2) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
        name=IBM_Admin_DataExtract_With_Review_Support
        BEGIN_ENTITY
          base_table=CATENTRY
          className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposerForReview
          associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryDescriptionAllLanguages
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Entry Data Extract Access Profile with price rule.-->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry parent catalog group.                 -->
<!-- 	3) Catalog Entry with offer price from price rules.    -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DataExtract_with_PriceRule
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
      associated_sql_statement=IBM_CatalogEntryDescription      
      associated_sql_statement=IBM_CatalogEntryListPriceForCurrency
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription
    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the attribute dictionary defining attributes, without allowed values for a product or SKU  -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAttrDictDefiningAttributesWithoutAllowedValues
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!--      Catalog Entry SKUs Access Profile                    -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry Classic Attribute Values.             -->
<!-- 	4) Catalog Entry Attributes.                           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntrySKUsWithoutADAllowedValues
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryListPrice 
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription
<!-- === Following SQL statements retrieves classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictonary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema
            
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription

    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Entry Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with descriptions for languages.      -->
<!-- 	   passes in the control parameter 'LANGUAGES'.        -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryDescription
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
    associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
	  associated_sql_statement=IBM_CatalogEntryListPrice
    associated_sql_statement=IBM_CatalogEntryDescriptionOverride	  
    END_ENTITY
END_PROFILE
