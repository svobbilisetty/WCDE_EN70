BEGIN_SYMBOL_DEFINITIONS

	COLS:MASSOCCECE=MASSOCCECE:*
			
END_SYMBOL_DEFINITIONS



<!-- ====================================================================== 
	Delete existing merchandising associations for the given source catalog entry
	and the store in the current context.
	
	@param catEntryId The catalog entry id
	@param storeId The store id
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_DeleteCatEntryAssociationsForSourceCatalogEntry
	base_table=MASSOCCECE
	sql=
		DELETE 
			FROM  MASSOCCECE
		WHERE
		MASSOCCECE.CATENTRY_ID_FROM=?catEntryId?
		AND STORE_ID=?storeId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Delete existing merchandising associations for the given target catalog entry
	and the store in the current context.
	
	@param catEntryId The catalog entry id
	@param storeId The store id	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_DeleteCatEntryAssociationsForTargetCatalogEntry
	base_table=MASSOCCECE
	sql=
		DELETE 
			FROM  MASSOCCECE
		WHERE
		MASSOCCECE.CATENTRY_ID_TO=?catEntryId?
		AND STORE_ID=?storeId? 
END_SQL_STATEMENT



<!-- ====================================================================== 
	Update the data type of descriptions for the given attribute dictionary attribute.
	
	@param attrDataTypeID The data type ID value to be set.
	@param attrID The ID of the attribute dictionary attribute.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_AttributeDicionaryAttribute_DescriptionsDataType
	base_table=ATTRDESC
	sql=
		UPDATE  ATTRDESC
			set ATTRTYPE_ID=?attrDataTypeID?
		WHERE
			ATTRDESC.ATTR_ID=?attrID?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Set the previous default allowed value to be non default allowed value 
	by updating the usage of the allowed value.
	
	@param UniqueID The ID of the current default allowed value.
	@param attrID The ID of the attribute dictionary attribute whose allowed value usage needs to be set.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_AttributeDicionaryAttribute_OldDefaultAllowedValue_Usage_NonDefault
	base_table=ATTRVAL
	sql=
		UPDATE  ATTRVAL
			set VALUSAGE = 1
		WHERE
			ATTRVAL.ATTR_ID=?attrID? 
			AND	ATTRVAL.ATTRVAL_ID <> ?UniqueID? 
			AND	VALUSAGE = 2
END_SQL_STATEMENT


<!-- ====================================================================== 
	Set the previous default allowed value to be non default allowed value 
	by updating the usage of the allowed value descriptions.
	
	@param UniqueID The ID of the current default allowed value.
	@param attrID The ID of the attribute dictionary attribute whose allowed value description usage needs to be set.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_AttributeDicionaryAttribute_OldDefaultAllowedValueDescription_Usage_NonDefault
	base_table=ATTRVALDESC
	sql=
		UPDATE  ATTRVALDESC
			set VALUSAGE = 1
		WHERE
			ATTRVALDESC.ATTR_ID = ?attrID? 
			AND ATTRVALDESC.ATTRVAL_ID <> ?UniqueID? 
			AND VALUSAGE = 2
END_SQL_STATEMENT
