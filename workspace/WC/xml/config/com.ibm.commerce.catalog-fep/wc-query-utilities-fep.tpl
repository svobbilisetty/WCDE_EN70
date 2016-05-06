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
BEGIN_SYMBOL_DEFINITIONS


	
	<!-- CATOVRGRP table -->
	COLS:CATOVRGRP=CATOVRGRP:*

	COLS:CATENTDESC=CATENTDESC:*	
		
		
	<!-- CATENTDESCOVR table -->
	<!-- COLS:CATENTDESCOVR=CATENTDESCOVR:CATENTDESCOVR_ID, NAME, SHORTDESCRIPTION, LONGDESCRIPTION, THUMBNAIL, FULLIMAGE, KEYWORD -->
	COLS:CATENTDESCOVR=CATENTDESCOVR:*
	
	
END_SYMBOL_DEFINITIONS

<!-- ====================================================================== 
	Select parent catalog entries based on the product catentry ID
	@param catalogEntryId The child catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ParentCatalogEntry
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_CHILD=?catalogEntryId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Selects the language column from the store table which holds the store
	default language.
	@param storeId The ID of the store 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_StoreDefaultLang
	base_table=STORE
	sql=
		select LANGUAGE_ID from STORE where STORE_ID=?storeId?  
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select all the catalog entry templates in the seopagedef table for a given
	store path.
	@param pageName The page name of the record to retrieve.
	@param objectId The ID of the object to retrieve.
	@param objectType The object type to return. For example Product or Category.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForTemplate
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:view$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName?	and objecttype=?objectType?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select the seopagedef entry for a specific catalog entry in a store path.
	@param objectId The unique ID of the catalog entry.
	@param objectType The object type to return. For example Product or Category.
	@param pageName The page name of the record to retrieve .
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForCatentry
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName? and objecttype=?objectType?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given catalog entry or catalog group.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURL
	base_table=seourl
	sql=
		select * from seourl left join seourlkeyword on seourl.seourl_id = seourlkeyword.seourl_id where status=1 and tokenvalue=?tokenValue? and tokenname=?tokenName? and language_id=?languageId? and storeent_id=?storeId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select all columns from the seopagedefovr table given a catalog entry ID.
	@param objectId The ID of a catalog entry or catalog group to retrieve.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Catentry_SEOPageDefOvr
	base_table=SEOPAGEDEFEXT
	sql=
		select * from SEOPAGEDEFOVR where object_id=?objectId? 
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select all columns from the seopagedefdesc table given a seopagedef ID 
	and a set of languages.
	@param seopagedefId The ID from the seopagedef table.
	@param langIds A list of language IDs.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefDesc
	base_table=SEOPAGEDEFDESC
	sql=
		select * from SEOPAGEDEFDESC where SEOPAGEDEF_ID=?seopagedefId? and language_id in (?langIds?)  
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select the seopagedef entry for a specific catalog group in a store path.
	@param catgroupId The unique ID of the catalog group. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForCatgroup
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and objecttype= ?objectType? and object_id = ?catgroupId? 
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select parent catalog group based on the child catgroup ID
	@param catalogGroupId The child catalog group id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ParentCatalogGroup
	base_table=CATENTREL
	sql=
		SELECT CATGROUP_ID_PARENT FROM CATGRPREL WHERE CATGROUP_ID_CHILD=?catalogGroupId? AND CATALOG_ID=?catalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select catalog entry ID by part numbers and store path.
	@param partNumberList The part numbers 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntry_By_PartNumbers
	base_table=CATENTRY
	sql=
			SELECT CATENTRY.CATENTRY_ID,  CATENTRY.PARTNUMBER, STORECENT.STOREENT_ID
			FROM 
			CATENTRY LEFT OUTER JOIN STORECENT
			ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID) 
		WHERE
			CATENTRY.PARTNUMBER IN (?partNumberList?) AND  		
			CATENTRY.MARKFORDELETE = 0 AND
			STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ )
END_SQL_STATEMENT


<!-- ====================================================================== 
	Delete dynamic kit preconfiguration.
	@param catalogEntryId The catalog entry id of the dynamic kit.
	@param sequence The sequence of the preconfigruation.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_DynamicKitPreConfiguration
	base_table=DKPREDEFCONF
	sql=
		DELETE FROM
	     	DKPREDEFCONF
	     	WHERE DKPREDEFCONF_ID IN (
	     		SELECT DKPREDEFCONF_ID FROM DKPDCCATENTREL
	     				WHERE CATENTRY_ID=?catalogEntryId? AND
	     				SEQUENCE=?sequence? 
	     				)
END_SQL_STATEMENT



<!-- ====================================================================== 
	Add a new dynamic kit preconfiguration
	@param dkPreDefConfId The dynamic kit predefined  configuration id.
	@param completeFlag The flag to indicate whether the configuration is complete.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_DynamicKitPreConfiguration
	base_table=DKPREDEFCONF
	sql=
		INSERT INTO 
	     	DKPREDEFCONF
	     				(DKPREDEFCONF_ID, COMPLETE)
	     	VALUES
					(?dkPreDefConfId?, ?completeFlag?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Add a new dynamic kit preconfiguration component
	@param dkPreDefCompListId The dynamic kit predefined  configuration component id.
	@param dkPreDefConfId The dynamic kit predefined  configuration id.
	@param catalogEntryId The catalog entry ID of the component.
	@param groupName The group name of the component.
	@param quantity The quantity.
	@param quantityUnitId The quantity unit.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_DynamicKitPreConfigurationComponent
	base_table=DKPDCCOMPLIST
	sql=
		INSERT INTO 
	     	DKPDCCOMPLIST
	     				(DKPDCCOMPLIST_ID, DKPREDEFCONF_ID, CATENTRY_ID, GROUPNAME, QUANTITY, QTYUNIT_ID)
	     	VALUES
					(?dkPreDefCompListId?, ?dkPreDefConfId?, ?catalogEntryId?, ?groupName?, ?quantity?, ?quantityUnitId?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Add a new dynamic kit preconfiguration to catalog entry relationship
	@param dkPreDefConfId The dynamic kit predefined  configuration id.
	@param catalogEntryId The catalog entry id of the dynamic kit.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_DynamicKitPreConfigurationCatalogEntryRelation
	base_table=DKPDCCATENTREL
	sql=
		INSERT INTO 
	     	DKPDCCATENTREL
	     				(DKPREDEFCONF_ID, CATENTRY_ID)
	     	VALUES
					(?dkPreDefConfId?, ?catalogEntryId?)
END_SQL_STATEMENT
<!-- ====================================================================== 
	Looks for seo url records matching a certain keyword value in a given language
	@param keyword The keyword to look for.
	@param languageId The language ID to look for.
	@param storeentId The storeent ID to look for.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURLKEYWORD_BY_KEYWORD
	base_table=seourlkeyword
	sql=
		select seourlkeyword.seourlkeyword_id from seourlkeyword where urlkeyword = ?keyword? and storeent_id = ?storeentId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete TMD information from seopagedef for a catgroup or a catentry
	@param objecttype The type of object (CatalogGroup or CatalogEntry)
	@param catalogObjectList List of IDs of the object (catgroup ids or catentry ids)
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_DELETE_SEO_TMD
	base_table=seopagedef
	sql=
		delete from seopagedef where seopagedef_id in (select seopagedef_id from seopagedefovr where objecttype=?objecttype? and object_id in (?catalogObjectList?))
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update status of a URL for a catgroup or a catentry
	@param status The status to set
	@param catalogObjectList List of IDs of the object (catgroup ids or catentry ids)
	@param tokenname indicates if it is for a catgroup or catentry (CategoryToken or ProductToken)
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_SET_STATUS_SEO_URL
	base_table=seourlkeyword
	sql=
		update seourlkeyword
		set status=?status?
		where seourl_id in 
			(select seourl.seourl_id
			from seourl
			where seourl.seourl_id = seourlkeyword.seourl_id
				and tokenvalue in (?catalogObjectList?) and tokenname=?tokenname?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given urlkeyword and store id.
	@param urlKeyword Url keyword mapped to the token value.
	@param storeId Store identifier of the url keyword.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOUrlKeyword_KeywordAndStoreId
	base_table=seourlkeyword
	sql=
		SELECT * FROM SEOURLKEYWORD WHERE URLKEYWORD=?urlKeyword? AND STOREENT_ID=?storeId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given token name and token value.
	@param storeId Store identifier of the url keyword.
	@param tokenName The name of the url keyword token.
	@param tokenValue The value that the token maps to.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOUrlKeyword_StoreIdAndTokenNameAndTokenValue
	base_table=seourlkeyword
	sql=
		SELECT SEOURL_ID FROM SEOURLKEYWORD WHERE STOREENT_ID=?storeId? AND SEOURL_ID IN (SELECT SEOURL_ID FROM SEOURL WHERE TOKENNAME=?tokenName? AND TOKENVALUE=?tokenValue?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given token name and url keyword.
	@param storeId Store identifier of the url keyword.
	@param urlKeyword The keyword to look for.
	@param tokenName The name of the url keyword token.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOUrlKeyword_StoreIdAndUrlKeywordAndTokenName
	base_table=seourlkeyword
	sql=
		SELECT SEOURL_ID FROM SEOURLKEYWORD WHERE STOREENT_ID=?storeId? AND URLKEYWORD=?urlKeyword? AND SEOURL_ID IN (SELECT SEOURL_ID FROM SEOURL WHERE TOKENNAME=?tokenName?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Updates the status of the specified url keywords
	@param status The updated status value.
	@param seoUrlId The list of identifiers of the seo url to update.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_SEOUrlKeyword_Status
	base_table=seourlkeyword
	sql=
		UPDATE SEOURLKEYWORD SET STATUS=?status? WHERE SEOURL_ID IN (?seoUrlId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Updates the token value of the specified seo urls
	@param tokenValue The updated token value.
	@param seoUrlId The list of identifiers of the seo urls to update.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_SEOUrl_TokenValue
	base_table=seourl
	sql=
		UPDATE SEOURL SET TOKENVALUE=?tokenValue? WHERE SEOURL_ID IN (?seoUrlId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Insert new seo token mapping to the new url along with other properties.
	@param seoUrlId Identifier of the url token.
	@param tokenName Name of the url token.
	@param tokenValue Value mapped to the url token.
	@param priority Relative priority for the url.
	@param changeFreq Frequency of change for the url.
	@param mobilePriority Relative priority for the mobile version of the url.
	@param mobileChangeFreq Frequency of change for the mobile version of the url.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_SEOUrl
	base_table=SEOURL
	sql=
    INSERT INTO SEOURL
           (SEOURL_ID, TOKENNAME, TOKENVALUE, PRIORITY, CHANGE_FREQUENCY, MOBILE_PRIORITY, MOBILE_CHG_FREQ)
    VALUES (?seoUrlId?, ?tokenName?, ?tokenValue?, ?priority?, ?changeFreq?, ?mobilePriority?, ?mobileChangeFreq?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Insert new keyword for the new seo url.
	@param seoUrlKeywordId Identifier of the seo url keyword.
	@param seoUrlId Identifier of the url token.
	@param storeId Store identifier of the url keyword.
	@param langId Identifier of the language this url keyword is in.
	@param urlKeyword Url keyword mapped to the token value.
	@param mobileUrlKeyword Mobile url keyword mapped to the token value.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_SEOUrlKeyword
	base_table=SEOURLKEYWORD
	sql=
    INSERT INTO SEOURLKEYWORD
           (SEOURLKEYWORD_ID, SEOURL_ID, STOREENT_ID, LANGUAGE_ID, URLKEYWORD, MOBILEURLKEYWORD)
    VALUES (?seoUrlKeywordId?, ?seoUrlId?, ?storeId?, ?langId?, ?urlKeyword?, ?mobileUrlKeyword?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Get the count of how many times the attribute is referenced by catalog entries 
	in CATENTRYATTR table.
	@param attrId The unique ID of the attribute.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CountCatalogEntryAttributeRelationshipByAttribute
	base_table=CATENTRYATTR
	sql=
		select count(*) from catentryattr where attr_id=?attrId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Get the count of how many times the specified attribute is referenced 
	by marketing activities.
	@param attrId The unique ID of the attribute.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CountAttributeActivityRelationshipByAttributeID
	base_table=DMELEMENTNVP
	sql=
		select 
			count(*) from dmelementnvp 
		where 
			name='filterName' and 
			value=?attrId? and
			dmelement_id in (select dmelement_id from dmelementnvp where name='filterType' and value in ('attributeType', 'facetableAttributeType'))
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=IBM_Select_DefaultCatalog
	base_table=STOREDEFCAT
	sql=
		SELECT 
			STOREDEFCAT.CATALOG_ID, STOREDEFCAT.STOREENT_ID
		FROM 
			STOREDEFCAT, CATALOG
		WHERE 
			STOREDEFCAT.STOREENT_ID in ($STOREPATH:catalog$) AND
			CATALOG.CATALOG_ID = STOREDEFCAT.CATALOG_ID
END_SQL_STATEMENT

<!-- ========================================================= -->
<!-- =====Get default override group of the given store ===== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CATOVRGRP+IBM_Admin_DefaultCatalogOverrideGroupForStore
	base_table=CATOVRGRP
	sql=
		SELECT
			CATOVRGRP.$COLS:CATOVRGRP$
		FROM  CATOVRGRP WHERE CATOVRGRP.STOREENT_ID=?storeId?
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================================ -->
<!--  Initialize the catalog entry long description override to empty_clob() -->
<!--                                                                              -->
<!--  @param UniqueID                                                          -->
<!--     The unique identifier of the catalog entry description override.                              -->
<!--==============================================================================-->
BEGIN_SQL_STATEMENT
  base_table=CATENTDESCOVR
  name=IBM_Set_CatEntry_Desc_Override_LongDescription_To_Empty_Clob
  sql=update CATENTDESCOVR set LONGDESCRIPTION = EMPTY_CLOB() where CATENTDESCOVR.CATENTDESCOVR_ID = ?UniqueID?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the catalog entry long description override clob column for an update         -->
<!--  on Oracle 9i; because of the Oracle bug, the CLOB column can not         -->
<!--  be the first or the last in the SELECT list.                             -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The unique identifier of the catalog entry description override.                              -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=CATENTDESCOVR
  name=IBM_Select_CatEntry_Desc_Override_LongDescription
  sql=select CATENTDESCOVR_ID, LONGDESCRIPTION, CATENTDESCOVR_ID from CATENTDESCOVR where CATENTDESCOVR.CATENTDESCOVR_ID = ?UniqueID? FOR UPDATE
END_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the catalog override group id for a store .
	 @param storeId
		The unique identifier for store
     =========================================================================== -->
BEGIN_SQL_STATEMENT
  name=IBM_Select_OverrideGroupID_By_StoreID
  base_table=STORECATOVRGRP
  sql= SELECT STORECATOVRGRP.CATOVRGRP_ID 
  		FROM 
  			STORECATOVRGRP 
  		WHERE 
  			STORECATOVRGRP.STOREENT_ID IN (?storeId?)
END_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the catalog entry description override for the given catalog entries, overide group and language ids.
     @param UniqueID List of unique identifiers for catalog entries
     @param catOverrideGroupID The unique identifier of the catalog override group.  
     @param language The language ids.
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CATENTDESCOVR[CATENTRY_ID= AND CATOVRGRP_ID=]+IBM_Get_CatalogEntryDescriptionOverride
	base_table=CATENTDESCOVR
	sql=
		SELECT CATENTDESCOVR.$COLS:CATENTDESCOVR$ FROM CATENTDESCOVR WHERE 
		CATENTDESCOVR.CATENTRY_ID IN (?UniqueID?) AND 
		CATENTDESCOVR.CATOVRGRP_ID = ?catOverrideGroupID?  AND 
		CATENTDESCOVR.LANGUAGE_ID IN (?language?) 	
		ORDER BY CATENTDESCOVR.CATENTRY_ID, CATENTDESCOVR.LANGUAGE_ID
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Query to retrieve the catalog entry description for the given catalog entries and language ids.
     @param UniqueID List of unique identifiers for catalog entries
     @param language The language ids.     
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CATENTDESC[CATENTRY_ID= AND LANGUAGE_ID=]+IBM_Get_CatalogEntryDescriptions
	base_table=CATENTDESC
	sql=
		SELECT CATENTDESC.$COLS:CATENTDESC$ FROM 
			CATENTDESC 
		WHERE CATENTDESC.CATENTRY_ID IN (?UniqueID?) AND CATENTDESC.LANGUAGE_ID IN (?language?)
		ORDER BY CATENTDESC.CATENTRY_ID, CATENTDESC.LANGUAGE_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Select parent catalog entry based on the item catentry ID.
	@param catalogEntryId Unique ID of the item.	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntryParent
	base_table=CATENTREL
	sql=
		select CATENTRY_ID_PARENT from CATENTREL where CATENTRY_ID_CHILD=?catalogEntryId? and CATRELTYPE_ID='PRODUCT_ITEM'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the UOM of CATENTRY from CATENTSHIP table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_UOM_From_CATENTSHIP
	base_table=CATENTSHIP
	sql=
	SELECT CATENTRY_ID, QUANTITYMEASURE
	FROM CATENTSHIP
	WHERE CATENTRY_ID IN (?UniqueID?)
        ORDER BY CATENTRY_ID
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve attributte values for a given list of attribute identifiers     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_VALUES
	base_table=ATTRVALDESC
	sql=
	SELECT VALUE
	  FROM ATTRVALDESC
	WHERE ATTRVAL_ID=?attributeValueId? AND LANGUAGE_ID=$CTX:LANG_ID$
END_SQL_STATEMENT


