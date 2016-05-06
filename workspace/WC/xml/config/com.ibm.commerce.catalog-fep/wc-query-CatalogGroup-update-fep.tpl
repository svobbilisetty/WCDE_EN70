BEGIN_SYMBOL_DEFINITIONS

	COLS:CATGROUP=CATGROUP:*
	COLS:STORECGRP=STORECGRP:*
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATGPCALCD=CATGPCALCD:*
	COLS:CALCODE=CALCODE:*
	COLS:FACETCATGRP=FACETCATGRP:*
END_SYMBOL_DEFINITIONS


<!-- ===================================================================================== -->
<!-- ============ Catalog Group Change and Process Queries Begin ========================= -->
<!-- ===================================================================================== -->


<!-- ============================================================================================= -->
<!-- This SQL will return the details of a Catalog Group along with its merchandising associations,-->
<!-- catalog group to catalog entry relations, catalog group to catalog group relatios if catalog  -->
<!-- is not a top category other wise top category relation and catalog group to store relation.   -->	
<!-- Multiple results are returned if multiple catalog group ids are passed. Catalog Id is         -->
<!-- retrieved from business context and used to retrieve category to category relation or category-->
<!-- to catalog relation for a if catalog group is top category.				   -->	
<!-- @param UniqueID UniqueId of catalog group.						   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- @param CTX:STORE_ID  Store Id of store for which the catalog group has to be fetched.	   -->
<!--			  Store Id is retrieved form the business context                          -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupProfile
	base_table=CATGROUP
	sql=
		SELECT
			CATGROUP.$COLS:CATGROUP$,
			CATGRPREL.$COLS:CATGRPREL$,
			STORECGRP.$COLS:STORECGRP$,
			CATGPCALCD.$COLS:CATGPCALCD$,
			CALCODE.$COLS:CALCODE$
		FROM CATGROUP
		
			LEFT OUTER JOIN CATGRPREL ON (
				CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID AND
				CATGRPREL.CATALOG_ID IN ($CTX:CATALOG_ID$)
			)
			JOIN STORECGRP ON (
				STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
				STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
			)
			LEFT OUTER JOIN CATGPCALCD ON (
				CATGPCALCD.CATGROUP_ID = CATGROUP.CATGROUP_ID
			)
			LEFT OUTER JOIN CALCODE ON (
				CALCODE.CALCODE_ID = CATGPCALCD.CALCODE_ID
			)
		WHERE
			CATGROUP.MARKFORDELETE = 0 AND
			CATGROUP.CATGROUP_ID IN (?UniqueID?)	
										
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the details of a Catalog Group along with its facets.                    -->
<!-- Multiple results are returned if multiple catalog group ids are passed.                       -->
<!-- @param UniqueID UniqueId of catalog group.						                               -->
<!-- @param CTX:STOREENT_ID  Store Id of store for which the catalog group has to be fetched.	   -->
<!--			  Store Id is retrieved form the business context                                  -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]/Facet/FacetIdentifier/[(facetId=)]+IBM_Admin_CatalogGroupFacets
	base_table=CATGROUP
	sql=
		SELECT
			CATGROUP.$COLS:CATGROUP$,
			FACETCATGRP.$COLS:FACETCATGRP$
		FROM CATGROUP
		
		LEFT OUTER JOIN FACETCATGRP ON (
			FACETCATGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND 
			FACETCATGRP.FACET_ID=?facetId? AND
			FACETCATGRP.STOREENT_ID IN ($STOREPATH:catalog$)
		)
		
		WHERE
			CATGROUP.MARKFORDELETE = 0 AND			
			CATGROUP.CATGROUP_ID IN (?UniqueID?)	
										
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Find catalog group calculation code by calculation code and store
	@param calcodeId The calculation code id
	@param storeId The store identifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroupCalculationCode[(@calcodeId=) and (@storeId=)]+IBM_Admin_IdResolve
	base_table=CATGPCALCD
	sql=
		SELECT 
			CATGPCALCD.$COLS:CATGPCALCD$
		FROM 
			CATGPCALCD 
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


<!-- ========================================================= -->
<!-- Catalog Group Access Profile Alias definition             -->
<!--                                                            -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATGROUP
  IBM_CatalogGroupProfile=IBM_Admin_CatalogGroupProfile
  IBM_IdResolve=IBM_Admin_IdResolve
END_PROFILE_ALIASES


<!-- ===================================================================================== -->
<!-- ================================ CATALOG GROUP QUERIES END ========================== -->
<!-- ===================================================================================== -->



