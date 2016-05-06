BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	
	
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	COLS:CATALOG:IDENTIFIER=CATALOG:IDENTIFIER
	
	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID
	
	
	
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	
	
	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID	
	
	<!-- STORECENT table -->
	COLS:STORECENT=STORECENT:*
	COLS:STORECENT:STOREENT_ID=STORECENT:STOREENT_ID
	COLS:STORECENT:CATENTRY_ID=STORECENT:CATENTRY_ID
	
	<!-- Other tables -->
	COLS:ATTRIBUTE=ATTRIBUTE:*
	COLS:ATTRVALUE=ATTRVALUE:*
	COLS:CATENTDESC=CATENTDESC:* 
	COLS:CATENTREL=CATENTREL:*
	COLS:CATENTATTR=CATENTATTR:*
	COLS:CATENTSHIP=CATENTSHIP:*
	COLS:CATGPENREL=CATGPENREL:*
	COLS:CATCLSFCOD=CATCLSFCOD:*
	COLS:CATCONFINF=CATCONFINF:*
	COLS:CATENCALCD=CATENCALCD:*
	COLS:DKPDCCATENTREL=DKPDCCATENTREL:*
	COLS:DKPDCCOMPLIST=DKPDCCOMPLIST:*
	COLS:DKPDCREL=DKPDCREL:*
	COLS:DISPENTREL=DISPENTREL:*
	COLS:CATENTTYPE=CATENTTYPE:*
	COLS:LISTPRICE=LISTPRICE:*
	COLS:BASEITEM=BASEITEM:*
	COLS:OFFER=OFFER:*
	COLS:ITEMSPC=ITEMSPC:*
	COLS:MASSOCCECE=MASSOCCECE:*
	
	COLS:CATALOGDSC=CATALOGDSC:*
	COLS:CATTOGRP=CATTOGRP:*
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATCNTR=CATCNTR:*
	COLS:CATGRPTPC=CATGRPTPC:*
	COLS:CATGRPPS=CATGRPPS:*
	COLS:PRSETCEREL=PRSETCEREL:*

	
	COLS:CATGPCALCD=CATGPCALCD:*
	COLS:CATGRPATTR=CATGRPATTR:*
	COLS:CATGRPDESC=CATGRPDESC:*
	COLS:MASSOCGPGP=MASSOCGPGP:*
	COLS:MASSOC=MASSOC:*
	COLS:MASSOCTYPE=MASSOCTYPE:*
	COLS:ITEMVERSN=ITEMVERSN:*
	COLS:VERSIONSPC=VERSIONSPC:*
	COLS:ITEMTYPE=ITEMTYPE:*
	COLS:BASEITMDSC=BASEITMDSC:*
	
    <!-- ATTR table -->
	COLS:ATTR=ATTR:*
    
    <!-- ATTRVAL table -->	
	COLS:ATTRVAL=ATTRVAL:*
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:*
    
    <!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*
	
    <!-- CATENTRYATTR table -->		
	COLS:CATENTRYATTR=CATENTRYATTR:*
		
		
END_SYMBOL_DEFINITIONS

<!-- ====================================================================== 
	Select child catalog entries based on the product catentry ID
	@param catalogEntryId The parent catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ChildCatalogEntry
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_PARENT=?catalogEntryId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select child catalog entries based on the product catentry ID
	and not marked for delete
	@param catalogEntryId The parent catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Active_ChildCatalogEntry
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL, CATENTRY WHERE CATENTREL.CATENTRY_ID_PARENT=?catalogEntryId?
			AND CATENTRY.CATENTRY_ID=CATENTREL.CATENTRY_ID_CHILD AND CATENTRY.MARKFORDELETE=0
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select catalog entry ID by part number and store path.
	@param partNumberList The part numbers 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntry_By_PartNumber
	base_table=CATENTRY
	sql=
			SELECT CATENTRY.CATENTRY_ID 
			FROM 
			CATENTRY LEFT OUTER JOIN STORECENT
			ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID) 
		WHERE
			CATENTRY.PARTNUMBER IN (?partNumberList?) AND  		
			CATENTRY.MARKFORDELETE = 0 AND
			STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ )
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select catalog entry ID by part number and member(owner) id.
	@param partNumberList the part number
	@param memberId the member ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntry_By_PartNumber_And_Owner
	base_table=CATENTRY
	sql=
			SELECT CATENTRY.CATENTRY_ID 
			FROM 
			CATENTRY
		WHERE
			CATENTRY.PARTNUMBER IN (?partNumberList?) AND MEMBER_ID =?memberId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete catalog entries and the children (set markfordelete and update partnumber)
	@param catalogEntryIdList A list of catalog entry IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_CatalogEntry
	base_table=CATENTRY
	dbtype=oracle	
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(CATENTRY.PARTNUMBER||'-'||SYSTIMESTAMP)<=64 
	     				THEN 
	     					CATENTRY.PARTNUMBER||'-'||SYSTIMESTAMP  
	     				ELSE 
	     					SUBSTR(CATENTRY.PARTNUMBER,1,64-LENGTH(''||SYSTIMESTAMP)-1)||'-'||SYSTIMESTAMP END
	     				,CATENTRY.MARKFORDELETE=1
	     	WHERE
						CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
	dbtype=db2
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)
	     				ELSE 
	     					SUBSTR(CATENTRY.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,CATENTRY.MARKFORDELETE=1
	     	WHERE
						CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)

	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)  
	     				ELSE 
	     					SUBSTR(CATENTRY.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,CATENTRY.MARKFORDELETE=1
	     	WHERE
						CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select item specification by a list of catalog entry IDs
	@param catalogEntryIdList A list of catalog entry IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ItemSpecification_By_CatalogEntryIdList
	base_table=CATENTRY
	sql = 
	SELECT CATENTRY.ITEMSPC_ID FROM CATENTRY 
	WHERE CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete item specification (set markfordelete and update partnumber)
	@param itemspcIdList A list of item specification IDs 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_ItemSpecification
	base_table=ITEMSPC
	dbtype=oracle	
	sql=
			UPDATE 
						ITEMSPC
	     	SET 
	     				ITEMSPC.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(ITEMSPC.PARTNUMBER||'-'||SYSTIMESTAMP)<=64 
	     				THEN 
	     					ITEMSPC.PARTNUMBER||'-'||SYSTIMESTAMP  
	     				ELSE 
	     					SUBSTR(ITEMSPC.PARTNUMBER,1,64-LENGTH(''||SYSTIMESTAMP)-1)||'-'||SYSTIMESTAMP END
	     				,ITEMSPC.MARKFORDELETE=1
	     	WHERE
						ITEMSPC.ITEMSPC_ID IN (?itemspcIdList?)
	dbtype=db2
	sql=
			UPDATE 
						ITEMSPC
	     	SET 
	     				ITEMSPC.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)
	     				ELSE 
	     					SUBSTR(ITEMSPC.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,ITEMSPC.MARKFORDELETE=1
	     	WHERE
						ITEMSPC.ITEMSPC_ID IN (?itemspcIdList?)

	sql=
			UPDATE 
						ITEMSPC
	     	SET 
	     				ITEMSPC.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)  
	     				ELSE 
	     					SUBSTR(ITEMSPC.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,ITEMSPC.MARKFORDELETE=1
	     	WHERE
						ITEMSPC.ITEMSPC_ID IN (?itemspcIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select base item by a list of catalog entry IDs
	@param catalogEntryIdList A list of catalog entry IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_BaseItem_By_CatalogEntryIdList
	base_table=CATENTRY
	sql = 
	SELECT CATENTRY.BASEITEM_ID FROM CATENTRY 
	WHERE CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete base item (set markfordelete and update partnumber)
	@param baseItemIdList A list of base item IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_BaseItem
	base_table=BASEITEM
	dbtype=oracle	
	sql=
			UPDATE 
						BASEITEM
	     	SET 
	     				BASEITEM.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(BASEITEM.PARTNUMBER||'-'||SYSTIMESTAMP)<=72 
	     				THEN 
	     					BASEITEM.PARTNUMBER||'-'||SYSTIMESTAMP  
	     				ELSE 
	     					SUBSTR(BASEITEM.PARTNUMBER,1,72-LENGTH(''||SYSTIMESTAMP)-1)||'-'||SYSTIMESTAMP END
	     				,BASEITEM.MARKFORDELETE=1
	     	WHERE
						BASEITEM.BASEITEM_ID IN (?baseItemIdList?)
	dbtype=db2
	sql=
			UPDATE 
						BASEITEM
	     	SET 
	     				BASEITEM.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=72 
	     				THEN 
	     					BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)
	     				ELSE 
	     					SUBSTR(BASEITEM.PARTNUMBER,1,72-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,BASEITEM.MARKFORDELETE=1
	     	WHERE
						BASEITEM.BASEITEM_ID IN (?baseItemIdList?)

	sql=
			UPDATE 
						BASEITEM
	     	SET 
	     				BASEITEM.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=72 
	     				THEN 
	     					BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)  
	     				ELSE 
	     					SUBSTR(BASEITEM.PARTNUMBER,1,72-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,BASEITEM.MARKFORDELETE=1
	     	WHERE
						BASEITEM.BASEITEM_ID IN (?baseItemIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the LASTUPDATE timestamp of the catalog entry
	@param catalogEntryId The catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_CatalogEntry_UpdateLastUpdateTimeStamp
	base_table=CATENTRY
	dbtype=oracle
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.LASTUPDATE=SYSTIMESTAMP
	     				
	     	WHERE
						CATENTRY.CATENTRY_ID=?catalogEntryId?
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.LASTUPDATE=CURRENT TIMESTAMP

	     	WHERE
						CATENTRY.CATENTRY_ID=?catalogEntryId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the LASTUPDATE timestamp of the catalog group
	@param catalogGroupId The catalog group id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_CatalogGroup_UpdateLastUpdateTimeStamp
	base_table=CATGROUP
	dbtype=oracle
	sql=
			UPDATE 
						CATGROUP
	     	SET 
	     				CATGROUP.LASTUPDATE=SYSTIMESTAMP
	     				
	     	WHERE
						CATGROUP.CATGROUP_ID=?catalogGroupId?
	sql=
			UPDATE 
						CATGROUP
	     	SET 
	     				CATGROUP.LASTUPDATE=CURRENT TIMESTAMP

	     	WHERE
						CATGROUP.CATGROUP_ID=?catalogGroupId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Add a new product set catalog entry relation
	@param productSetId The product set id
	@param catalogEntryId The catalog entry id
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_SyncProductSet_AddNewProductSetCatalogEntryRelation_Update
	base_table=PRSETCEREL
	sql=
		INSERT INTO 
	     		PRSETCEREL
	     				(PRODUCTSET_ID, CATENTRY_ID)
	     	VALUES
					( ?productSetId? , ?catalogEntryId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete existing catalog entry product set relation
	@param productSetId The product set id
	@param catalogEntryId The catalog entry id
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_SyncProductSet_DeleteExistingProductSetCatalogEntryRelation_Update
	base_table=PRSETCEREL
	sql=
		DELETE 
			FROM  PRSETCEREL
		WHERE
		PRSETCEREL.PRODUCTSET_ID=?productSetId? AND PRSETCEREL.CATENTRY_ID=?catalogEntryId?  
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the existing catalog entry category relation for reparenting the catalog entry
	@param catalogEntryId The catalog entry id 
	@param categoryId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_ReparentCatalogEntry_DeleteExistingCategoryRelation
	base_table=CATGPENREL
	sql=
			DELETE 
	     	FROM
	     				CATGPENREL
	     	WHERE
						CATGPENREL.CATENTRY_ID=?catalogEntryId? AND
						CATGPENREL.CATGROUP_ID = ?categoryId? AND
						 CATGPENREL.CATALOG_ID= ?catalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the existing catalog entry category relation for reparenting the catalog entry
	@param catalogEntryId The catalog entry id 
	@param catalogGroupId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_ReparentCatalogEntry_DeleteExistingCategoryRelationWithCatgroup
	base_table=CATGPENREL
	sql=
			DELETE 
	     	FROM
	     				CATGPENREL
	     	WHERE
						CATGPENREL.CATENTRY_ID=?catalogEntryId? AND CATGPENREL.CATALOG_ID=?catalogId? AND CATGPENREL.CATGROUP_ID =?catalogGroupId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Add new catalog entry category relation for reparenting the catalog entry
	@param catalogEntryId The catalog entry id 
	@param catalogGroupId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_ReparentCatalogEntry_AddNewCategoryRelation
	base_table=CATGPENREL
	dbtype=oracle
	sql=
			INSERT INTO 
	     				CATGPENREL
	     				(CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	     	VALUES
						( ?catalogGroupId? , ?catalogId? , ?catalogEntryId? , 0, SYSTIMESTAMP)

	dbtype=db2
	sql=
			INSERT INTO 
	     				CATGPENREL
	     				(CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	     	VALUES
						( ?catalogGroupId? , ?catalogId? , ?catalogEntryId? , 0, current timestamp)

	sql=
			INSERT INTO 
	     				CATGPENREL
	     				(CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	     	VALUES
						( ?catalogGroupId? , ?catalogId? , ?catalogEntryId? , 0, current timestamp)
END_SQL_STATEMENT


<!-- ====================================================================== 
  Executed during unlink.
	Select child catalog entries based on the catalog group id and the source catalog id
	This query is used to find the catalog group to catalog entry relationships to be deleted which were created by a previous link operation.
	@param catGroupId The catalog group id 
	@param sourceCatalogId The catalog id for the source relations 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ChildCatalogEntry_For_Unlink
	base_table=CATGPENREL
	sql=
		SELECT CATGPENREL.CATENTRY_ID from CATGPENREL where CATGPENREL.CATGROUP_ID=?catGroupId? and CATGPENREL.CATALOG_ID=?sourceCatalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the existing catalog group catentry relation for the catalog group.
	@param categoryId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_CatalogGroup_ExistingCatentryRelation
	base_table=CATGPENREL
	sql=
			DELETE 
	     	FROM
	     				CATGPENREL
	     	WHERE
						CATGPENREL.CATGROUP_ID = ?categoryId? AND
						CATGPENREL.CATALOG_ID= ?catalogId?
END_SQL_STATEMENT



<!-- ================================================================================================= 
	Executed during unlink. Use to delete catalog group to catalog entry relations that were created by a previous link operation.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param catalogEntryIdList A list of catalog entry IDs whose relationships need to be deleted 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveCatalogGroupToCatalogEntryLinkRelations
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID=?catalogId? AND CATENTRY_ID IN (?catalogEntryIdList?)

END_SQL_STATEMENT


<!-- ================================================================================================= 
	Executed during unlink. Use to delete catalog group to catalog entry relations that were created by a previous link operation in one step.
	It combines IBM_Select_ChildCatalogEntry_For_Unlink and IBM_Delete_RemoveCatalogGroupToCatalogEntryLinkRelations. 
	@param catGroupId The catalog group id 
	@param linkCatalogIds The list of linked catalog ids	
	@param sourceCatalogId The catalog id for the source relations 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllCatalogGroupToCatalogEntryLinkRelations
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID IN (?linkCatalogIds?) 
		AND 
		CATENTRY_ID IN 
		(SELECT CATGPENREL.CATENTRY_ID from CATGPENREL where CATGPENREL.CATGROUP_ID=?catGroupId? and CATGPENREL.CATALOG_ID=?sourceCatalogId?)

END_SQL_STATEMENT

<!-- ================================================================================================= 
	Executed during unlink in workspace. Use to delete catalog group to catalog entry relations that were created by a previous link operation in one step.
	@param catGroupId The catalog group id 
	@param linkCatalogIds The list of linked catalog ids	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllCatalogGroupToCatalogEntryLinkRelationsInWorkspace
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID IN (?linkCatalogIds?) 

END_SQL_STATEMENT

<!-- ====================================================================== 
	Add new catalog group to catalog entry relations for link creation.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param sourceCatalogId The catalog id for the source relations 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryLinkRelations
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, TO_NUMBER(?catalogId?), t1.catentry_id, t1.rule, t1.sequence, SYSTIMESTAMP
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId? and
	not exists(select 1 
	   from catgpenrel t2
	   where t2.catgroup_id=t1.catgroup_id and t2.catalog_id=?catalogId? and t2.catentry_id=t1.catentry_id)
	   
	dbtype=db2
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, CAST(?catalogId? as BIGINT), t1.catentry_id, t1.rule, t1.sequence, current timestamp
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId?
	except 
		select t2.catgroup_id, CAST(?catalogId? as BIGINT), t2.catentry_id, t2.rule, t2.sequence, current timestamp 
		from catgpenrel t2 
		where t2.catgroup_id in (?catGroupId?) and t2.catalog_id=?catalogId? 
		
	dbtype=derby
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, ?catalogId?, t1.catentry_id, t1.rule, t1.sequence, current timestamp
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId? and
	not exists(select 1 
	   from catgpenrel t2
	   where t2.catgroup_id=t1.catgroup_id and t2.catalog_id=?catalogId? and t2.catentry_id=t1.catentry_id)
	     
	dbtype=any
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, CAST(?catalogId? as BIGINT), t1.catentry_id, t1.rule, t1.sequence, current timestamp
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId?
	except 
		select t2.catgroup_id, CAST(?catalogId? as BIGINT), t2.catentry_id, t2.rule, t2.sequence, current timestamp 
		from catgpenrel t2 
		where t2.catgroup_id in (?catGroupId?) and t2.catalog_id=?catalogId? 
	        
END_SQL_STATEMENT

<!-- =============================================================================== 
	Create a new catalog group to catalog entry relations.
	@param catGroupId The catalog group id	
	@param catalogId The catalog id for the new relations
	@param catEntryId The catalog entry id 	
	@param sequence The display sequence number	
==================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryRelation
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE) VALUES
					( ?catGroupId? , ?catalogId?, ?catEntryId?, ?sequence?, SYSTIMESTAMP)
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE) VALUES
					( ?catGroupId? , ?catalogId?, ?catEntryId?, ?sequence?, current timestamp)				
	        
END_SQL_STATEMENT
<!-- =============================================================================== 
	Add new catalog group to catalog entry relations for SKUs of a product.
	@param catGroupId The catalog group id
	@param catEntryId The product id 
	@param catalogId The catalog id for the new relations	
	
==================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryRelationsForSKUs	      
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select TO_NUMBER(?catGroupId?), TO_NUMBER(?catalogId?), t1.catentry_id_child, t1.sequence, SYSTIMESTAMP
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'
	   
	dbtype=db2
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, t1.sequence, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'
	  
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, t1.sequence, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'   
	        
END_SQL_STATEMENT
<!-- ================================================================================================= 
	Execute during catalog entry reparent. Use to delete old catalog group to catalog entry relations
	to a product and SKUs of a product.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param catEntryId The catalog entry Id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveCatalogGroupToCatalogEntryRelationsForProductAndSKUs
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID=?catalogId? AND 
	(CATENTRY_ID IN (SELECT CATENTREL.CATENTRY_ID_CHILD from CATENTREL where CATENTREL.CATENTRY_ID_PARENT=?catEntryId? and CATRELTYPE_ID='PRODUCT_ITEM') 
	OR CATENTRY_ID=?catEntryId?)

END_SQL_STATEMENT
<!-- ================================================================================================= 
	Execute during catalog entry delete. Use to delete all catalog group to catalog entry relations
	to a product and SKUs of a product.
	@param catalogEntryIdList The list of child catalog entry IDs 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllCatalogGroupToCatalogEntryRelationsForProductAndSKUs
	base_table=CATGPENREL

	sql=
	DELETE FROM CATGPENREL 
	WHERE CATENTRY_ID IN (?catalogEntryIdList?)
			

END_SQL_STATEMENT

<!-- ============================================================================== 
	Get the identifier of a catalog according to its unique id.
	@param catalogId The unique id of the catalog group. 
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogIdentifier
	base_table=CATALOG
	sql=	
		SELECT 
			CATALOG.$COLS:CATALOG:IDENTIFIER$
		FROM 
			CATALOG
		WHERE 
			CATALOG.CATALOG_ID IN (?catalogId?)
END_SQL_STATEMENT


<!-- ============================================================================== 
	Get the catalog group relationship according to catalog id, parent group id and 
	child group id.
	@param catalogId The unique id of the catalog.
	@param parentCatalogGroupID The unique id of the parent group in the relationship
	@param childCatalogGroupID The unique id of the child group in the relationship
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogGroupRelationship
	base_table=CATGRPREL
	sql=	
		SELECT 
			CATGRPREL.$COLS:CATGRPREL$
		FROM 
			CATGRPREL
		WHERE 
			CATGRPREL.CATALOG_ID IN (?catalogId?) AND
			CATGRPREL.CATGROUP_ID_PARENT IN (?parentCatalogGroupID?) AND
			CATGRPREL.CATGROUP_ID_CHILD IN (?childCatalogGroupID?)
END_SQL_STATEMENT

<!-- ============================================================================== 
	Get the owning store id of a catalog according to its unique id.
	@param catalogId The unique id of the catalog. 
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogStoreID
	base_table=STORECAT
	sql=	
		SELECT 
			STORECAT.$COLS:STORECAT$
		FROM 
			STORECAT
		WHERE 
			STORECAT.CATALOG_ID IN (?catalogId?)
END_SQL_STATEMENT
			

<!-- ========================================================= -->
<!-- =====Get name of supported merchandising association===== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/MASSOCTYPE+IBM_Admin_SupportedMerchandisingAssociationName
	base_table=MASSOCTYPE
	sql=
		SELECT
			MASSOCTYPE.$COLS:MASSOCTYPE$
		FROM  MASSOCTYPE
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- =====Get supported semantic specifiers for association=== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/MASSOC+IBM_Admin_SupportedSemanticSpecifiers
	base_table=MASSOC
	sql=
		SELECT
			MASSOC.$COLS:MASSOC$
		FROM  MASSOC
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will delete the Catalog Group to Catalog relation for the given Catalog Group Id     -->
<!-- and Catalog Id.                                                                               -->
<!-- @param catalogGroupID Id of catalog group.                                                    -->
<!-- @param catalogID  The catalog id for which relation has to be deleted.                        --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_TopCatGroupRelation
	base_table=CATTOGRP
	sql=
		DELETE 
	     	FROM
	     				CATTOGRP
	     	WHERE
						CATTOGRP.CATGROUP_ID IN (?catalogGroupID?) AND CATTOGRP.CATALOG_ID = ?catalogID?
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the sequence of a Catalog Group to Catalog relation for the given        -->
<!-- Catalog Group Id and Catalog Id.                                                              -->
<!-- @param catalogGroupID Id of catalog group.                                                    -->
<!-- @param catalogID  The catalog id for which relation has to be updated.                        --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_TopCatGroupSequence
	base_table=CATTOGRP
	sql=
			UPDATE 
	     			CATTOGRP
	     	SET 	CATTOGRP.SEQUENCE = ?sequence?		
	     	WHERE
					CATTOGRP.CATGROUP_ID IN (?catalogGroupID?) AND CATTOGRP.CATALOG_ID = ?catalogID?
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the partnumber of a Catalog entry in the BaseItem table for the given    -->
<!-- BaseItem Id.                                                                                  -->
<!-- @param baseItemID Id of catalog entry.                                                        -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_BaseItemPartNumber
	base_table=BASEITEM
	sql=
			UPDATE 
	     			BASEITEM
	     	SET 	BASEITEM.PARTNUMBER = ?partnumber?		
	     	WHERE
					BASEITEM.BASEITEM_ID = ?baseItemID?
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will synchronize the sequence of Catalog Groups to Catalog Group relation for the    -->
<!-- given Catalog Group Id and Catalog Links to Catalog Id.                                       -->
<!-- @param sequence Sequence of child catalog group.                                              -->
<!-- @param childCatGroupId Id of child catalog group.                                             -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- @param catalogID  The catalog id link for which relation has to be updated.                   --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_LinkedCatGroupSequence
	base_table=CATGRPREL
	sql=
			UPDATE 
	     			CATGRPREL
	     	SET 	CATGRPREL.SEQUENCE = ?sequence?		
	     	WHERE
			CATGRPREL.CATGROUP_ID_CHILD IN (?childCatGroupId?) AND
			CATGRPREL.CATGROUP_ID_PARENT IN (?catalogGroupID?) AND
			CATGRPREL.CATALOG_ID_LINK = ?catalogID?
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will synchronize the sequence of Catalog Entries to Catalog Group relation for the   -->
<!-- given Catalog Group Id and Catalog Links Catalog Id.                                          -->
<!-- @param sequence Sequence of child catalog entry.                                              -->
<!-- @param catalogEntryId Id of child catalog entry.                                              -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- @param catalogID  The catalog id link for which relation has to be updated.                   --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_LinkedCatEntrySequence
	base_table=CATGPENREL
	sql=
	
			UPDATE CATGPENREL SET CATGPENREL.SEQUENCE = ?sequence? 
			WHERE 
					CATGPENREL.CATENTRY_ID = ?catalogEntryId? AND 
					CATGPENREL.CATGROUP_ID = ?catalogGroupID? AND 
					CATGPENREL.CATALOG_ID <> ?catalogID?	
					
END_SQL_STATEMENT


BEGIN_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Delete all links from a parent catalog group to a child catalog group in a catalog.           -->
	<!-- This SQL will delete from catgrprel where catgroup_id_parent in @parentCatGroupId and         -->       
	<!-- catgroup_id_child in @catGroupId and catalog_id in @catalogId and catalog_id_link is not null --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogId  One or more catalog ids                                                     -->
	<!-- @param parentCatGroupId Parent catalog group id                                               -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinkFromParentCatalogGroup
	base_table=CATGRPREL
	sql=		                            
             	DELETE FROM CATGRPREL
 				WHERE				
 				CATGRPREL.CATGROUP_ID_PARENT in (?parentCatGroupId?) AND		
				CATGRPREL.CATGROUP_ID_CHILD in (?catGroupId?) AND
				CATGRPREL.CATALOG_ID IN (?catalogId?) AND
				CATGRPREL.CATALOG_ID_LINK IS NOT NULL

END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Delete all links from the root of a catalog to one or more catalog groups.                    -->
	<!-- This SQL will delete from cattogrp where catgroup_id in @catGroupId and                       -->       
	<!-- catalog_id in @catalogId and catalog_id_link is not null                                      --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogId  One or more catalog ids                                                     -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinkFromCatalogRoot
	base_table=CATTOGRP
	sql=		                            
             	DELETE FROM CATTOGRP
 				WHERE						
				CATTOGRP.CATGROUP_ID IN (?catGroupId?) AND
				CATTOGRP.CATALOG_ID IN (?catalogId?) AND
				CATTOGRP.CATALOG_ID_LINK IS NOT NULL

END_SQL_STATEMENT	 


BEGIN_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Delete links from any catalog root to one or more catalog groups.                             -->
	<!-- This SQL will delete from cattogrp where catgroup_id in @catGroupId and                       -->       
	<!-- catalog_id_link in @catalogIdLink                                                             --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogIdLink The source catalog of the link                                           -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinksFromAnyCatalogRoot
	base_table=CATTOGRP
	sql=		                            
             	DELETE FROM CATTOGRP
 				WHERE						
				CATTOGRP.CATGROUP_ID IN (?catGroupId?) AND
				CATTOGRP.CATALOG_ID_LINK IN (?catalogIdLink?)

END_SQL_STATEMENT	

BEGIN_SQL_STATEMENT	
	<!-- ============================================================================================= -->
	<!-- Delete links from any parent catalog groups to a catalog group.                               -->
	<!-- This SQL will delete from catgrprel where catgroup_id_child in @catGroupId and                -->       
	<!-- catalog_id_link in @catalogIdLink                                                             --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogIdLink The source catalog of the link                                           -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinksFromAnyParentCatalogGroup
	base_table=CATGRPREL
	sql=		                            
             	DELETE FROM CATGRPREL
 				WHERE 				
				CATGRPREL.CATGROUP_ID_CHILD IN (?catGroupId?) AND
				CATGRPREL.CATALOG_ID_LINK IN (?catalogIdLink?)

END_SQL_STATEMENT

BEGIN_SQL_STATEMENT	
	<!-- ============================================================================================= -->
	<!-- Delete all relations from any parent catalog group to a catalog entry.                        -->
	<!-- This SQL will delete from catgpenrel where catentry_id in @catEntryId                         -->       
	<!-- @param catEntryId One or more catalog group ids                                               -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_ParentCatalogGroupToCatalogEntryRelation
	base_table=CATGRPREL
	sql=		                            
             	DELETE FROM CATGPENREL
 				WHERE 				
				CATGPENREL.CATENTRY_ID in (?catEntryId?) 

END_SQL_STATEMENT

<!-- ================================================================================================ -->
<!-- Given a list of catalog entry ids, filter out the ones mark for delete or not in the store path
<!-- @param catEntryId The list of catalog entry ids.
<!-- ================================================================================================ -->

BEGIN_SQL_STATEMENT
	name=IBM_Get_FilteredCatalogEntryIDs
	base_table=CATENTRY
	sql=
	SELECT 
		CATENTRY.CATENTRY_ID 
	FROM 
		CATENTRY LEFT OUTER JOIN STORECENT
		ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID) 

		WHERE
			CATENTRY.CATENTRY_ID IN (?catEntryId?) AND  		
			(CATENTRY.MARKFORDELETE = 1 OR
			STORECENT.STOREENT_ID NOT IN ( $STOREPATH:catalog$ ) OR STORECENT.STOREENT_ID IS NULL)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Check if the specified catalog entry id is valid. 
	@param catEntryId The unique id of the catalog entry. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogEntry/CatalogEntryIdentifier[(UniqueID=)]+IBM_Admin_IdResolve
	base_table=CATENTRY
	sql=
		SELECT 
			CATENTRY_ID_1
		FROM 
		(
		  SELECT 
		  		CATENTRY.$COLS:CATENTRY_ID$ CATENTRY_ID_1
		  FROM 
		  		CATENTRY
		  WHERE 
		  		CATENTRY.CATENTRY_ID = (?UniqueID?)  AND 
				CATENTRY.MARKFORDELETE = 0
		) T1
		WHERE EXISTS 
		( 
		  SELECT 
		  		1 
		  FROM 
		  		STORECENT 
		  WHERE 
		  		CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND 
		  		STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		)
END_XPATH_TO_SQL_STATEMENT		
<!-- ====================================================================== 
	Get the catalog(s) of the store having the specified value for CATALOG_ID
	@param UniqueID The unique id of the catalog. 
	@param storeId The store for which to retrieve the catalog. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all properties + the storecat of a catalog -->
	<!-- xpath = "/Catalog[CatalogIdentifier[(UniqueID=)] and (@storeId=)]]" -->
	name=/Catalog[CatalogIdentifier[(UniqueID=)] and (@storeId=)]]+IBM_Admin_CatalogStoreDetailsProfile	
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
					JOIN STORECAT ON (STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
					AND STORECAT.STOREENT_ID=?storeId?)					
				        
        	WHERE
               		CATALOG.CATALOG_ID in (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT
<!-- ====================================================================== 
	Get the master catalog of the specified store.
	@param storeId The store for which to retrieve the catalog. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all properties + the storecat for the master catalog of a store -->
	<!-- xpath = "/Catalog[@storeId=]" -->
	name=/Catalog[@storeId=]+IBM_Admin_CatalogStoreDetailsProfile
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
					JOIN STORECAT ON (STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
					AND STORECAT.STOREENT_ID=?storeId?)					
				        
        	WHERE
               		STORECAT.STOREENT_ID = ?storeId? AND
			STORECAT.MASTERCATALOG = '1' 
			
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get attribute dictionary attributes of a catalog entry according to the 
	unique ids of the attribute dictionary attributes.
	@param UniqueID The unique ids of the attribute dictionary attributes. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes[AttributeIdentifier/(UniqueID=)]+IBM_Admin_AttributeDictionaryAttribute
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR$,
				ATTRDESC.$COLS:ATTRDESC$,
				ATTRVAL.$COLS:ATTRVAL$,
				ATTRVALDESC.$COLS:ATTRVALDESC$
							
		FROM
				ATTR
				LEFT OUTER JOIN ATTRDESC ON
					(ATTRDESC.ATTR_ID=ATTR.ATTR_ID AND
					 ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
							 
				LEFT OUTER JOIN ATTRVAL ON
					(ATTRVAL.ATTR_ID = ATTR.ATTR_ID AND
					ATTRVAL.VALUSAGE is NOT NULL AND
					ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$))
					LEFT OUTER JOIN ATTRVALDESC ON
			        	(ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
					    ATTRVALDESC.LANGUAGE_ID = ATTRDESC.LANGUAGE_ID)		
				        
        WHERE
		        ATTR.ATTR_ID IN (?UniqueID?) AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
		        
		ORDER BY
				ATTRVALDESC.SEQUENCE				
			
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= 
	Get values of attribute dictionary attributes of a catalog entry 
	according to the identifiers of the attribute values.
	@param identifier The identifiers (unique ids) of the attribute dictionary attribute values. 
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes/Attributes/Value[(@identifier=)]+IBM_Admin_AttributeDictionaryAttribute
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$,			
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVAL
				LEFT OUTER JOIN ATTRVALDESC ON
					(ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
					ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				        
        WHERE
		        ATTRVAL.ATTRVAL_ID IN (?identifier?) AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================================================== 
	Get classic attributes according to the unique ids of the classic attributes.
	@param UniqueID The unique ids of the classic attributes. 
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes[AttributeIdentifier/(UniqueID=)]+IBM_Admin_Attribute
	base_table=ATTRIBUTE
	sql=
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$ 
		FROM 
			ATTRIBUTE  
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID IN (?UniqueID?) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================================================== 
	Get allowed values of classic attributes according to the unique ids of the classic attributes.
	@param UniqueID The unique ids of the classic attributes. 
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes[AttributeIdentifier/(UniqueID=)]/AllowedValue+IBM_Admin_Attribute
	base_table=ATTRVALUE
	sql=
		SELECT 
			ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM 
			ATTRVALUE  
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN (?UniqueID?) AND
			ATTRVALUE.CATENTRY_ID = 0 AND
			ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRVALUE.SEQUENCE						
			
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== 
	Get the identifier information of a catalog entry according to its unique id.
	The information can be used to build the logical catalog entry identifier.
	@param UniqueID The unique id of the catalog entry. 
=================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]+IBM_Admin_IDENTIFIER
	base_table=CATENTRY
	sql=

		SELECT 
			CATENTRY.$COLS:CATENTRY_ID$,
			CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
			CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			CATENTRY,STORECENT 
		WHERE 
			CATENTRY.CATENTRY_ID IN (?UniqueID?) AND CATENTRY.MARKFORDELETE = 0 AND 
			CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== 
	Get the identifier information of a catalog group according to its unique id.
	The information can be used to build the logical catalog group identifier.
	@param UniqueID The unique id of the catalog group. 
=================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_IDENTIFIER
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
			CATGROUP.CATGROUP_ID IN (?UniqueID?) AND CATGROUP.MARKFORDELETE = 0 AND 
			CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== 
	Get the store identifier information of a catalog entry according to its unique id.
	The information can be used to build the logical store identifier.
	@param UniqueID The unique id of the catalog entry. 
=================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryIdentifier[(UniqueID=)]/ExternalIdentifier/StoreIdentifier+IBM_Admin_IDENTIFIER
	base_table=STORECENT
	sql=

		SELECT 
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			STORECENT 
		WHERE 
			STORECENT.CATENTRY_ID IN (?UniqueID?) AND
			STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This query is deprecated in the FEP4 code.                -->
<!-- See /MASSOCTYPE+IBM_Admin_SupportedMerchandisingAssociationName -->
<!-- =====Get name of supported merchandising association===== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/MassocType+IBM_Admin_SupportedMerchandisingAssociationName
	base_table=MASSOCTYPE
	sql=
		SELECT
			MASSOCTYPE.$COLS:MASSOCTYPE$
		FROM  MASSOCTYPE
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This query is deprecated in the FEP4 code.                -->
<!-- See /MASSOC+IBM_Admin_SupportedSemanticSpecifiers               -->
<!-- =====Get supported semantic specifiers for association=== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Massoc+IBM_Admin_SupportedSemanticSpecifiers
	base_table=MASSOC
	sql=
		SELECT
			MASSOC.$COLS:MASSOC$
		FROM  MASSOC
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================================ -->
<!--  Initialize the catalog entry long description email message to empty_clob() -->
<!--                                                                              -->
<!--  @param CATENTRY_ID                                                          -->
<!--     The unique identifier of the catalog entry.                              -->
<!--  @param LANGUAGE_ID                                                          -->
<!--     The language identifier                                                  -->
<!--==============================================================================-->
BEGIN_SQL_STATEMENT
  base_table=CATENTDESC
  name=IBM_Set_CatEntry_LongDescription_To_Empty_Clob
  sql=update CATENTDESC set LONGDESCRIPTION = EMPTY_CLOB() where CATENTRY_ID = ?CATENTRY_ID? and LANGUAGE_ID=?LANGUAGE_ID?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the catalog entry long description clob column for an update         -->
<!--  on Oracle 9i; because of the Oracle bug, the CLOB column can not         -->
<!--  be the first or the last in the SELECT list.                             -->
<!--                                                                           -->
<!--  @param CATENTRY_ID                                                       -->
<!--     The unique identifier of the catalog entry.                           -->
<!--  @param LANGUAGE_ID                                                       -->
<!--     The language identifier                                               -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=EMLCONTENT
  name=IBM_Select_CatEntry_LongDescription
  sql=select CATENTRY_ID, LONGDESCRIPTION, CATENTRY_ID from CATENTDESC where CATENTRY_ID = ?CATENTRY_ID? and LANGUAGE_ID=?LANGUAGE_ID? FOR UPDATE
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select active child SKUs based on the product catentry ID
	@param catalogEntryId The parent catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ChildSKU
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL, CATENTRY WHERE CATENTREL.CATENTRY_ID_PARENT=?catalogEntryId? AND CATRELTYPE_ID = 'PRODUCT_ITEM'
			AND CATENTRY.CATENTRY_ID=CATENTREL.CATENTRY_ID_CHILD AND CATENTRY.MARKFORDELETE=0
END_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Access Profile Alias definition			       -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATENTRY
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_IDENTIFIER=IBM_Admin_IDENTIFIER
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=MASSOCTYPE
  IBM_SupportedMerchandisingAssociationName=IBM_Admin_SupportedMerchandisingAssociationName	
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=MASSOC
  IBM_SupportedSemanticSpecifiers=IBM_Admin_SupportedSemanticSpecifiers
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATALOG
  IBM_CatalogStoreDetailsProfile=IBM_Admin_CatalogStoreDetailsProfile
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTR
  IBM_AttributeDictionaryAttribute=IBM_Admin_AttributeDictionaryAttribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRVAL
  IBM_AttributeDictionaryAttribute=IBM_Admin_AttributeDictionaryAttribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRIBUTE
  IBM_Attribute=IBM_Admin_Attribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRVALUE
  IBM_Attribute=IBM_Admin_Attribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATGROUP
    IBM_IDENTIFIER=IBM_Admin_IDENTIFIER
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=STORECENT
    IBM_IDENTIFIER=IBM_Admin_IDENTIFIER
END_PROFILE_ALIASES
