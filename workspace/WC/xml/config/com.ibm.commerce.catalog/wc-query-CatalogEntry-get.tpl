BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY_BASE_ATTRS=CATENTRY:CATENTRY_ID,MFNAME
	
	<!-- ATTRIBUTE table -->
	COLS:ATTRIBUTE=ATTRIBUTE:*
	
	<!-- ATTRVALUE table -->
	COLS:ATTRVALUE=ATTRVALUE:ATTRVALUE_ID, LANGUAGE_ID, ATTRIBUTE_ID, OPERATOR_ID, SEQUENCE, CATENTRY_ID, NAME, STRINGVALUE, INTEGERVALUE, FLOATVALUE, FIELD1, IMAGE1, IMAGE2, FIELD2, FIELD3, OID, QTYUNIT_ID, ATTACHMENT_ID

	<!-- STORECENT table -->
	COLS:STORECENT=STORECENT:*
	COLS:STOREENT_ID=STORECENT:STOREENT_ID	

    <!-- ATTR table -->
	COLS:ATTR=ATTR:ATTR_ID,SEQUENCE,DISPLAYABLE,SEARCHABLE,COMPARABLE,FIELD1,FIELD2,FIELD3,IDENTIFIER
	
	COLS:CATENTREL=CATENTREL:*
    <!-- ATTRVAL table -->	
    COLS:ATTRVAL=ATTRVAL:ATTRVAL_ID,ATTR_ID,FIELD1,FIELD2,FIELD3,IDENTIFIER
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:ATTR_ID,LANGUAGE_ID,ATTRTYPE_ID, NAME,DESCRIPTION,DESCRIPTION2,FIELD1,GROUPNAME,QTYUNIT_ID,NOTEINFO

    <!-- ATTRVALDESC table -->	
	COLS:ATTRVALDESC=ATTRVALDESC:ATTRVAL_ID,LANGUAGE_ID,ATTR_ID,VALUE,STRINGVALUE,INTEGERVALUE,FLOATVALUE,SEQUENCE,QTYUNIT_ID,IMAGE1,IMAGE2,FIELD1,FIELD2,FIELD3,VALUSAGE
	
    <!-- CATENTRYATTR table -->		
    COLS:CATENTRYATTR=CATENTRYATTR:CATENTRY_ID,ATTR_ID, ATTRVAL_ID,USAGE,SEQUENCE,FIELD1,FIELD2,FIELD3
	
END_SYMBOL_DEFINITIONS
<!-- =============================================================================
     Adds classic attributes (ATTRIBUTE table) of catalog entries to the 
     resultant data graph.                                                 
     ============================================================================= -->

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

<!-- =============================================================================
     Adds classic attribute values (ATTRVALUE table) of catalog entries to the 
     resultant data graph.                                                 
     ============================================================================= -->

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

<!-- =============================================================================
     Adds the schemas of classic attributes to the resultant data graph.                                                 
     ============================================================================= -->

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


<!-- ========================================================== 
     Adds the catalog entry and of attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

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

<!-- ========================================================== 
     Adds the catalog entry and defining attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
	base_table=CATENTRYATTR
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
     Adds the catalog entry and descriptive attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		        CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		        CATENTRYATTR.USAGE <> '1' 
		         
        ORDER BY
        		CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the schema of attribute dictionary 
     attributes (ATTR table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchema
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR$
		FROM
				ATTR
				        
        WHERE
		        ATTR.ATTR_ID IN ($UNIQUE_IDS$) AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the description of attribute dictionary 
     attributes (ATTRDESC table) to the
      resultant data graph.                               
     ========================================================== -->
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
     The allowed values which are not used by valid SKU of the product are filtered out                        
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
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.ATTRVAL_ID IN 
				( 	SELECT 
						C1.ATTRVAL_ID 
					FROM 
						CATENTRYATTR C1, CATENTREL, CATENTRY 
					WHERE 
						C1.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
						CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND
						CATENTRY.MARKFORDELETE = 0 AND
						CATENTREL.CATENTRY_ID_PARENT IN ($ENTITY_PKS$)
				)
				
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


<!-- ========================================================== 
     Adds the values of attribute dictionary attributes 
     (ATTRVAL table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
        WHERE
		        ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the description for the values of attribute dictionary attributes 
     (ATTRVALDESC table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Attributes Info 	                   -->
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

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds relationships between catentries and attribute dictionary -->
<!-- attribute (CATENTRYATTR table) of catalog entry's parent       -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryParent
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY,CATENTREL		
        WHERE
	        	CATENTREL.CATENTRY_ID_CHILD IN ($ENTITY_PKS$) AND
	        	CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT

END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds relationships between catentries and attribute dictionary -->
<!-- attribute (CATENTRYATTR table) of catalog entry's parent       -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryParentBaseAttributes
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
		FROM
				CATENTRY,CATENTREL		
        WHERE
	        	CATENTREL.CATENTRY_ID_CHILD IN ($ENTITY_PKS$) AND
	        	CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT

END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This associated SQL:                                          -->
<!-- Return the child catentry id and catenttype id to a given     -->
<!-- parent catentry id and store id                               -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_GetChildCatentry
	base_table=CATENTRY
	sql=
			SELECT 
     				CATENTREL.CATENTRY_ID_CHILD,
     				CATENTRY.CATENTTYPE_ID
	     	FROM
     				CATENTREL, CATENTRY
	     	WHERE
					CATENTREL.CATENTRY_ID_PARENT IN (?UniqueID?)
					AND CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID
					AND EXISTS (SELECT STORECENT.CATENTRY_ID FROM STORECENT WHERE STOREENT_ID IN ($STOREPATH:catalog$))
			ORDER BY
					CATENTREL.SEQUENCE	
END_SQL_STATEMENT
<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front  
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry.      
  3) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  4) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  5) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  6) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  7) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  8) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  9) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  10) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  13) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
================================================================================================================================= -->
      
BEGIN_PROFILE 
	name=IBM_Store_CatalogEntryAttributes
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue	  
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      

    END_ENTITY
END_PROFILE

<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front(return catalog entry and its parent product)
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryParentBaseAttributes - returns parent catalog entry of the root catalog entry and base attributes.
  3) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry. 
  4) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  5) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  6) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  7) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  8) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  9) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  10) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  13) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  14) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
================================================================================================================================= -->

BEGIN_PROFILE 
	name=IBM_Store_CatalogEntryAttributesParent
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes	  
	  associated_sql_statement=IBM_CatalogEntryParentBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription 
      	  
    END_ENTITY
END_PROFILE

<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front without entitlement check
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry.      
  3) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  4) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  5) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  6) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  7) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  8) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  9) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  10) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  13) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
================================================================================================================================= -->
BEGIN_PROFILE 
	name=IBM_CatalogEntryAttributesWithoutEntitlementCheck
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue	  
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      

    END_ENTITY
END_PROFILE

<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front(return catalog entry and its parent product) without entitlement check
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryParentBaseAttributes - returns parent catalog entry of the root catalog entry and base attributes.
  3) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry. 
  4) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  5) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  6) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  7) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  8) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  9) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  10) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  13) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  14) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
================================================================================================================================= -->

BEGIN_PROFILE 
	name=IBM_CatalogEntryAttributesParentWithoutEntitlementCheck
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes	  
	  associated_sql_statement=IBM_CatalogEntryParentBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription 
      	  
    END_ENTITY
END_PROFILE



