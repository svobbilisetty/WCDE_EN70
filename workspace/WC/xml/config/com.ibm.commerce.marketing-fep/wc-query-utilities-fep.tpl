<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2012                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- DMRANKINGITEM table -->
	COLS:DMRANKINGITEM=DMRANKINGITEM:*
	
	<!-- DMRANKINGSTAT table -->
	COLS:DMRANKINGSTAT=DMRANKINGSTAT:*

	<!-- DMEMSPOTCOLLDEF table -->
	COLS:DMEMSPOTCOLLDEF=DMEMSPOTCOLLDEF:*

	<!-- COLLIMGMAPAREA table -->
	COLS:COLLIMGMAPAREA=COLLIMGMAPAREA:*
	COLS:COLLIMGMAPAREA_ID=COLLIMGMAPAREA:COLLIMGMAPAREA_ID
	COLS:COLLATERAL_ID=COLLIMGMAPAREA:COLLATERAL_ID
	COLS:HTMLDEF=COLLIMGMAPAREA:HTMLDEF
		
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Access Profiles                                                          -->
<!-- IBM_Admin_Details       All the columns from the table                   -->
<!-- ======================================================================== -->

<!-- Rankiing -->

<!-- ======================================================================== -->
<!-- This SQL will return the ranking list for the specified element in the   -->
<!-- current context store.                                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the campaign element.              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a ranking list from DMRANKINGITEM -->
	name=/DMRANKINGITEM[DMELEMENT_ID= AND GROUP_ID=]+IBM_Admin_Details
	base_table=DMRANKINGITEM 
	sql= 
		SELECT  
				DMRANKINGITEM.$COLS:DMRANKINGITEM$ 
		FROM 
				DMRANKINGITEM 
		WHERE 
				DMRANKINGITEM.DMELEMENT_ID = ?DMELEMENT_ID? AND
				DMRANKINGITEM.GROUP_ID = ?GROUP_ID? AND
		    DMRANKINGITEM.STOREENT_ID = $CTX:STORE_ID$				
		ORDER BY SEQUENCE ASC
								 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the ranking list for the specified element in the   -->
<!-- specified store.                                                         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the campaign element.              -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a ranking list from DMRANKINGITEM -->
	name=/DMRANKINGITEM[DMELEMENT_ID= AND GROUP_ID= AND STOREENT_ID=]+IBM_Admin_Details
	base_table=DMRANKINGITEM 
	sql= 
		SELECT  
				DMRANKINGITEM.$COLS:DMRANKINGITEM$ 
		FROM 
				DMRANKINGITEM 
		WHERE 
				DMRANKINGITEM.DMELEMENT_ID = ?DMELEMENT_ID? AND
				DMRANKINGITEM.GROUP_ID = ?GROUP_ID? AND
				DMRANKINGITEM.STOREENT_ID = ?STOREENT_ID?				
								 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will create a ranking statistic entry.                          -->
<!-- @param DMRANKINGSTAT_ID The primary key of the ranking statistic entry.  -->
<!-- @param OBJECT_ID The identifier of the object that generated the event.  -->
<!-- @param OBJECT_TYPE The type of statistic entry.                          -->
<!-- @param STOREENT_ID The store identifier.                                 -->
<!-- @param GROUP_ID The identifier of the group to which the object belongs. -->
<!-- @param AMOUNT The amount associated with the event.                      -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- insert entries into DMRANKINGSTAT -->
  base_table=DMRANKINGSTAT
	name=IBM_Admin_Insert_InsertDmrankingstat
	sql=insert into DMRANKINGSTAT (DMRANKINGSTAT_ID, OBJECT_ID, OBJECT_TYPE, STOREENT_ID, DMELEMENT_ID, GROUP_ID, AMOUNT, FLAG, TIMECREATED) values ( ?DMRANKINGSTAT_ID?, ?OBJECT_ID?, ?OBJECT_TYPE?, ?STOREENT_ID?, ?DMELEMENT_ID?, ?GROUP_ID?, ?AMOUNT?, 0, CURRENT_TIMESTAMP)
END_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default title data for the     -->
<!-- specified eMarketingSpot, store, and content unique ID.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param COLLATERAL_ID     The unique identifier of the content.                 -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default title set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTCOLLDEF[COLLATERAL_ID= and  EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$
		FROM
				DMEMSPOTCOLLDEF
		WHERE
				DMEMSPOTCOLLDEF.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTCOLLDEF.STOREENT_ID = ?STOREENT_ID? AND
				DMEMSPOTCOLLDEF.COLLATERAL_ID = ?COLLATERAL_ID?				
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default title content data       -->
<!-- for the specified eMarketingSpot and store.                              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default content set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTCOLLDEF[EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$
		FROM
				DMEMSPOTCOLLDEF
		WHERE
				DMEMSPOTCOLLDEF.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTCOLLDEF.STOREENT_ID = ?STOREENT_ID?
		ORDER BY
				DMEMSPOTCOLLDEF.SEQUENCE ASC

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the title data of the MarketingSpot noun  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_MarketingSpotTitle -->
<!-- @param UniqueID The identifier of the marketing spot title for  -->
<!--                             which to retrieve the marketing spot title.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot title in DMEMSPOTCOLLDEF table -->
	name=/MarketingSpot[DefaultMarketingSpotTitle[(UniqueID=)]]+IBM_Admin_MarketingSpotTitle
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				DMEMSPOTCOLLDEF					
		WHERE
				DMEMSPOTCOLLDEF.DMEMSPOTCOLLDEF_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT
<!-- ====================================================================== 
	Select image map areas by content unique id.
	@param UniqueID the unique id of the marketing content. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Image_Map_Areas_By_Content_UniqueId
	base_table=COLLIMGMAPAREA
	sql=
		SELECT 
				COLLIMGMAPAREA.$COLS:COLLATERAL_ID$, COLLIMGMAPAREA.$COLS:HTMLDEF$
		FROM
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select image map area by content unique id, language id and coordinates.
	@param UniqueID the unique id of the marketing content.
	@param LanguageID the language id of the marketing content map.
	@param Coordinates the coordinates of the marketing content map area.    
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Image_Map_Areas_By_Content_UniqueId_LanguageId_Coordinates
	base_table=COLLIMGMAPAREA
	sql=
		SELECT 
				COLLIMGMAPAREA.$COLS:COLLIMGMAPAREA_ID$
		FROM
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID = ?UniqueID? AND
				COLLIMGMAPAREA.LANGUAGE_ID = ?LanguageID? AND
			    COLLIMGMAPAREA.COORDINATES = ?Coordinates?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete all image map areas of a content.
	@param UniqueID The unique id of the marketing content
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Content_Image_Map_Areas
	base_table=COLLIMGMAPAREA
	sql=
		DELETE FROM  
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Delete the image map areas with HTMLDEF column is null for a content.
	@param UniqueID The unique id of the marketing content
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Content_Image_Map_Areas_With_Source
	base_table=COLLIMGMAPAREA
	sql=
		DELETE FROM  
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?) AND
				COLLIMGMAPAREA.HTMLDEF IS NOT NULL
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the image map areas with HTMLDEF column is not null for a content.
	@param UniqueID The unique id of the marketing content
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Content_Image_Map_Areas_Without_Source
	base_table=COLLIMGMAPAREA
	sql=
		DELETE FROM  
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?) AND
				COLLIMGMAPAREA.HTMLDEF IS NULL
END_SQL_STATEMENT
