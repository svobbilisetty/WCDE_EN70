BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	
	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID

	<!-- CATTOGRP Table -->
	COLS:CATTOGRP=CATTOGRP:*		
		
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	
	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID
	
	<!-- CATGRPDESC Table -->
	COLS:CATGRPDESC=CATGRPDESC:*
	COLS:CATGRPDESC:NAME=CATGRPDESC:NAME
	COLS:CATGRPDESC:CATGROUP_ID=CATGRPDESC:CATGROUP_ID
	COLS:CATGRPDESC:LANGUAGE_ID=CATGRPDESC:LANGUAGE_ID
	COLS:CATGRPDESC:SHORTDESCRIPTION=CATGRPDESC:SHORTDESCRIPTION	
	COLS:CATGRPDESC:THUMBNAIL=CATGRPDESC:THUMBNAIL
	
	<!-- CATGRPREL Table -->
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATGROUP_ID_PARENT=CATGRPREL:CATGROUP_ID_PARENT
	COLS:CATGROUP_ID_CHILD=CATGRPREL:CATGROUP_ID_CHILD
	COLS:CATGRPREL:SEQUENCE=CATGRPREL:SEQUENCE		
	
	COLS:MASSOCGPGP=MASSOCGPGP:*
	COLS:STORECENT=STORECENT:*
	
	<!-- CATENTDESC table -->
	COLS:CATENTDESC=CATENTDESC:*
	COLS:CATENTDESC:CATENTRY_ID=CATENTDESC:CATENTRY_ID
	COLS:CATENTDESC:LANGUAGE_ID=CATENTDESC:LANGUAGE_ID
	COLS:CATENTDESC:NAME=CATENTDESC:NAME
	
	<!-- CATGPENREL table -->
	COLS:CATGPENREL=CATGPENREL:*
	COLS:CATGPENREL:CATENTRY_ID=CATGPENREL:CATENTRY_ID
	COLS:CATGPENREL:SEQUENCE=CATGPENREL:SEQUENCE
	COLS:CATGPENREL:CATGROUP_ID=CATGPENREL:CATGROUP_ID
	
	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHREL:ATCHTGT_ID=ATCHREL:ATCHTGT_ID
	COLS:ATCHREL:SEQUENCE=ATCHREL:SEQUENCE
	
	<!-- ATCHRLUS table -->
	COLS:ATCHRLUS=ATCHRLUS:*
	COLS:ATCHRLUS:IDENTIFIER=ATCHRLUS:IDENTIFIER
	
	<!-- ATCHRELDSC table -->
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRELDSC:NAME=ATCHRELDSC:NAME
	COLS:ATCHRELDSC:SHORTDESCRIPTION=ATCHRELDSC:SHORTDESCRIPTION
	COLS:ATCHRELDSC:LONGDESCRIPTION=ATCHRELDSC:LONGDESCRIPTION
	
	<!-- Calculation code tables -->
	COLS:CATGPCALCD=CATGPCALCD:*
	COLS:CALCODE=CALCODE:*
	
END_SYMBOL_DEFINITIONS

<!-- ===================================================================================== -->
<!-- ================================ GET CATGROUP BEGINS ================================ -->
<!-- ===================================================================================== -->


<!-- ========================================================================= -->
<!-- =============================SUB SELECT QUERIES========================== -->
<!-- ========================================================================= -->

<!-- ==============================================================	-->
<!-- This SQL will return the elements of the Catalog Group			-->
<!-- noun(s) in the store.											-->
<!-- The access profiles that apply to this SQL are:				-->
<!-- IBM_Admin_DataExtract											-->
<!-- @param UniqueID - The store for which to retrieve the			-->
<!--        catalog group.											-->
<!-- ==============================================================	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]]]
	base_table=CATGROUP
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.CatalogGroupDataExtractSQLComposer
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP_ID$
		FROM
				(
				SELECT 
						CATGROUP.$COLS:CATGROUP_ID$
				FROM 
						CATGROUP
						JOIN
						CATTOGRP ON (CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$ AND CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID)
				WHERE  
						CATGROUP.MARKFORDELETE=0
				UNION
				SELECT
						CATGROUP.$COLS:CATGROUP_ID$ 
				FROM
						CATGROUP
						JOIN
						CATGRPREL ON (CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ AND CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID)
				WHERE
						CATGROUP.MARKFORDELETE=0
				)CATGROUP
				JOIN
				STORECGRP ON (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN (?UniqueID?))
	     				
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
	name=IBM_CatalogGroupStoreIdentifier
	base_table=STORECGRP
	param=versionable
	sql=

		SELECT 
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM 
			STORECGRP 
		WHERE 
			STORECGRP.CATGROUP_ID IN ($UNIQUE_IDS$) AND
			STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT			

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with summary                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithSummary
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$, CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
				CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
				CATGRPDESC.$COLS:CATGRPDESC:NAME$, CATGRPDESC.$COLS:CATGRPDESC:THUMBNAIL$,
				CATGRPDESC.$COLS:CATGRPDESC:SHORTDESCRIPTION$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)) 
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catgroup Children Relations                          -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupChildrenRelationShips
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATGROUP_CHILD.$COLS:CATGROUP_ID$, CATGROUP_CHILD.$COLS:CATGROUP:MEMBER_ID$, 
				CATGROUP_CHILD.$COLS:CATGROUP:IDENTIFIER$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATGRPDESC.$COLS:CATGRPDESC:NAME$,CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$,
				CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
				STORECGRP.$COLS:STORECGRP$
		FROM
				CATGROUP,
				CATGROUP CATGROUP_CHILD
				 JOIN
				CATGRPREL ON
				 	 (CATGROUP_CHILD.CATGROUP_ID = CATGRPREL.CATGROUP_ID_CHILD AND 
				 	  CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$) 
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP_CHILD.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))   
				 JOIN
                            	STORECGRP ON
                            		(CATGROUP_CHILD.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	 	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))					  
					  
		WHERE
				CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) AND
                		CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID AND
				CATGROUP.MARKFORDELETE = 0 AND
				CATGROUP_CHILD.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry Children Relations                          -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryChildrenRelationShips
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATENTRY.$COLS:CATENTRY_ID$, CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
				CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$, CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
				CATGPENREL.$COLS:CATGPENREL$,
				CATENTDESC.$COLS:CATENTDESC:CATENTRY_ID$, CATENTDESC.$COLS:CATENTDESC:LANGUAGE_ID$,
				CATENTDESC.$COLS:CATENTDESC:NAME$,
				STORECENT.$COLS:STORECENT$
		FROM
				CATGROUP
				 JOIN
				CATGPENREL ON 
					(CATGROUP.CATGROUP_ID = CATGPENREL.CATGROUP_ID AND
					 CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$)
				 JOIN 
				CATENTRY ON 
					(CATENTRY.CATENTRY_ID = CATGPENREL.CATENTRY_ID)
				 LEFT OUTER JOIN 
				CATENTDESC ON
					(CATENTRY.CATENTRY_ID = CATENTDESC.CATENTRY_ID AND
					 CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATENTREL ON
					(CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND
					 CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM')	
				 JOIN
				STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
  					      STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))										 
		WHERE
				CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) AND
                		CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
				CATENTRY.MARKFORDELETE = 0 AND
				NOT 
					(
						CATENTRY.CATENTTYPE_ID = 'ItemBean' AND
						CATENTREL.CATENTRY_ID_CHILD IS NOT NULL
					)				
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds merchandising associations info                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupMerchandisingAssociations
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
			CATGROUP.$COLS:CATGROUP$,
			CATGRPDESC.$COLS:CATGRPDESC$,
			MASSOCGPGP.$COLS:MASSOCGPGP$,
			CATGROUP_TO.$COLS:CATGROUP$,
			STORECGRP.$COLS:STORECGRP$
		FROM
			CATGROUP,
			MASSOCGPGP
  		         LEFT OUTER JOIN
  		        CATGRPDESC ON
  		        	(CATGRPDESC.CATGROUP_ID = MASSOCGPGP.CATGROUP_ID_TO AND
  		         	 CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
			 JOIN
			CATGROUP CATGROUP_TO ON
				(CATGROUP_TO.CATGROUP_ID = MASSOCGPGP.CATGROUP_ID_TO)
			 JOIN
                       	STORECGRP ON
                       		(CATGROUP_TO.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                       	 	 STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))				
        	WHERE
        		CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) AND
               		MASSOCGPGP.CATGROUP_ID_FROM = CATGROUP.CATGROUP_ID AND
               		MASSOCGPGP.STORE_ID IN ($STOREPATH:catalog$) AND
               		CATGROUP.MARKFORDELETE = 0 AND
               		CATGROUP_TO.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT




<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with top catgroup                 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 (CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$ OR CATTOGRP.CATALOG_ID_LINK IS NULL))
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with summary                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP_ID$, CATGROUP.$COLS:CATGROUP:MEMBER_ID$, CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
				CATGRPDESC.$COLS:CATGRPDESC:CATGROUP_ID$, CATGRPDESC.$COLS:CATGRPDESC:LANGUAGE_ID$,
				CATGRPDESC.$COLS:CATGRPDESC:NAME$, CATGRPDESC.$COLS:CATGRPDESC:THUMBNAIL$,
				CATGRPDESC.$COLS:CATGRPDESC:SHORTDESCRIPTION$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)	
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================ -->
<!-- This associated SQL:                                         -->
<!-- Adds Attachment Reference Description Info                   -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupAttachmentReferenceDescription
	base_table=CATGROUP
	additional_entity_objects=true	
	param=versionable
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP_ID$, ATCHREL.$COLS:ATCHREL$, ATCHRLUS.$COLS:ATCHRLUS$, ATCHRELDSC.$COLS:ATCHRELDSC$
		FROM
				CATGROUP
				JOIN STORECGRP ON (CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
                            	   STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$))
				JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATGROUP.CATGROUP_ID
				JOIN ATCHRLUS ON ATCHREL.ATCHRLUS_ID = ATCHRLUS.ATCHRLUS_ID
				JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATGROUP')
				LEFT OUTER JOIN ATCHRELDSC ON (ATCHREL.ATCHREL_ID = ATCHRELDSC.ATCHREL_ID AND ATCHRELDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
        CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$) 
         
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithAllDescriptions
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID)
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)					 
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)					  
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithDescriptions
	base_table=CATGROUP
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)					  
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
        name=IBM_RootCatalogGroupWithDescriptionsAllLanguages
        base_table=CATGROUP
        additional_entity_objects=true
        param=versionable
        sql=
                SELECT
                                CATGROUP.$COLS:CATGROUP$,
                                CATGRPDESC.$COLS:CATGRPDESC$,
                                CATTOGRP.$COLS:CATTOGRP$
                FROM
                                CATGROUP
                                 LEFT OUTER JOIN
                                CATGRPDESC ON
                                         (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID)
                                 LEFT OUTER JOIN
                                CATTOGRP ON
                                        (CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
                                         CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$)

                WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catgroup Parent Relations                            -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupParentRelationShips
	base_table=CATGRPREL
	param=versionable
	sql=
		SELECT 
				CATGRPREL.$COLS:CATGRPREL$
		FROM
				CATGRPREL
		WHERE
				CATGRPREL.CATGROUP_ID_CHILD IN ($UNIQUE_IDS$) AND
				(CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ OR CATALOG_ID_LINK IS NULL)

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds identifiers (CATGROUP, STORECGRP) of catalog groups 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT     
    name=IBM_CatalogGroupIdentifier
	base_table=CATGROUP
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

<!-- ==========================================================
     Adds calculation codes (CATGPCALCD) of catalog groups
     to the resultant data graph.
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupCalculationCode
	base_table=CATGPCALCD
	sql=
		SELECT
			CATGPCALCD.$COLS:CATGPCALCD$, CALCODE.$COLS:CALCODE$
		FROM
			CATGPCALCD, CALCODE
		WHERE
			CALCODE.CALCODE_ID = CATGPCALCD.CALCODE_ID AND
			CATGPCALCD.STORE_ID = $CTX:STORE_ID$ AND
			CATGPCALCD.CATGROUP_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- =============================PROFILE DEFINITIONS========================= -->
<!-- ========================================================================= -->

BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupFacets
	BEGIN_ENTITY 
	  base_table=CATGROUP 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
    END_ENTITY
END_PROFILE

BEGIN_PROFILE 
	name=IBM_Admin_SEO
	BEGIN_ENTITY 
	  base_table=CATGROUP 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier   
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DataExtract
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier  
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!--    1) Catalog Group with description.                     -->
<!--    2) Catalog Group top catalog group.                    -->
<!--    3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
        name=IBM_Admin_DataExtract_With_Review_Support
        BEGIN_ENTITY
          base_table=CATGROUP
          className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionsAllLanguages
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Summary Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description summary.             -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Summary
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier       
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
	  associated_sql_statement=IBM_CatalogGroupIdentifier
	  associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Merchandising Associations Access Profile.  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group merchandising associations.           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupMerchandisingAssociations		 
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier 
      associated_sql_statement=IBM_CatalogGroupMerchandisingAssociations
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group NavRel Catalog Group Access Profile.        -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog groups.              -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupNavRelCatalogGroup
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogGroupChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group NavRel Catalog Entry Access Profile.        -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog entries.             -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupNavRelCatalogEntry
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogEntryChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group NavRel All Access Profile.                  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog groups.              -->
<!-- 	5) Catalog Group children catalog entries.             -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupNavRelAll
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogGroupChildrenRelationShips
      associated_sql_statement=IBM_CatalogEntryChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group All Details Access Profile.                 -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- 	4) Catalog Group children catalog groups.              -->
<!-- 	5) Catalog Group children catalog entries.             -->
<!-- 	6) Catalog Group merchandising associations.           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_All
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogGroupChildrenRelationShips
      associated_sql_statement=IBM_CatalogEntryChildrenRelationShips
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupMerchandisingAssociations
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Sales Catalog References Access Profile.    -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description summary.             -->
<!-- 	2) Catalog Group sales catalog references.             -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupSalesCatalogReference
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer	  
      associated_sql_statement=IBM_RootCatalogGroupWithSummaryWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with all descriptions.                -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupAllDescriptions
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer	  
      associated_sql_statement=IBM_RootCatalogGroupWithAllDescriptions
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with descriptions for languages.      -->
<!-- 	   passes in the control parameter 'LANGUAGES'.        -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupDescription
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer	  
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptions
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Group Parent Details Access Profile.              -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description.                     -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog groups in all catalogs.-->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupAllParentsDetails
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier      
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogGroupCalculationCode
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Group Attachment References Access Profile.       -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with attachment reference.              -->
<!-- 	2) Catalog Group with attachment reference description.  -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogGroupAttachmentReference
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer	  
      associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup 
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier   
      associated_sql_statement=IBM_CatalogGroupAttachmentReferenceDescription
      associated_sql_statement=IBM_CatalogGroupCalculationCode
	  associated_sql_statement=IBM_CatalogGroupParentRelationShips
      associated_sql_statement=IBM_CatalogGroupIdentifier
    END_ENTITY
END_PROFILE

