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

	<!-- COLLATERAL table -->
	COLS:COLLATERAL=COLLATERAL:*
	COLS:COLLATERAL_ID_NAME=COLLATERAL:COLLATERAL_ID, NAME
	COLS:COLLATERAL_ID=COLLATERAL:COLLATERAL_ID

	<!-- COLLDESC table -->
	COLS:COLLDESC=COLLDESC:*
		
	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRLUS=ATCHRLUS:*			

	<!-- COLLIMGMAPAREA table -->
	COLS:COLLIMGMAPAREA=COLLIMGMAPAREA:*
	
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- This SQL will return the image map data of the MarketingContent noun     -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_ImageMap       -->
<!-- @param MarketingContentIdentifier The identifier of the marketing        -->
<!--                              content to retrieve image map.              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Content image maps in COLLIMGMAPAREA table -->
	name=/MarketingContent[MarketingContentIdentifier[(UniqueID=)]]+IBM_Admin_ImageMap
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$, COLLIMGMAPAREA.$COLS:COLLIMGMAPAREA$				
		FROM
				COLLATERAL
				LEFT OUTER JOIN COLLIMGMAPAREA ON COLLIMGMAPAREA.COLLATERAL_ID = COLLATERAL.COLLATERAL_ID 
		WHERE
				COLLATERAL.COLLATERAL_ID IN ( ?UniqueID? )
	  ORDER BY COLLIMGMAPAREA.SEQUENCE ASC
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing content description    -->
<!-- info of the MarketingContent noun.                                       -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content with attachment in COLLATERAL -->
	name=IBM_MarketingContentDescription
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$,
				COLLDESC.$COLS:COLLDESC$				
		FROM
				COLLATERAL 
					LEFT OUTER JOIN COLLDESC ON (COLLDESC.COLLATERAL_ID = COLLATERAL.COLLATERAL_ID 
						AND COLLDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)) 					
		WHERE
				COLLATERAL.COLLATERAL_ID IN ($ENTITY_PKS$) 				
						
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the attachment reference             -->
<!-- description info of the MarketingContent noun.                           -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content with attachment in COLLATERAL -->
	name=IBM_MarketingContentAttachmentReferenceDescription
	base_table=COLLATERAL
	additional_entity_objects=true	
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$,
				ATCHREL.$COLS:ATCHREL$,
				ATCHRELDSC.$COLS:ATCHRELDSC$,
				ATCHRLUS.$COLS:ATCHRLUS$
		FROM
				COLLATERAL					
					JOIN ATCHREL ON (ATCHREL.BIGINTOBJECT_ID = COLLATERAL.COLLATERAL_ID)
					LEFT OUTER JOIN ATCHRELDSC ON (ATCHRELDSC.ATCHREL_ID = ATCHREL.ATCHREL_ID AND ATCHRELDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
					JOIN ATCHRLUS ON (ATCHRLUS.ATCHRLUS_ID = ATCHREL.ATCHRLUS_ID)
					JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'COLLATERAL')
		WHERE
				COLLATERAL.COLLATERAL_ID IN ($ENTITY_PKS$) AND COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$)
						
				
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing content image map      -->
<!-- info of the MarketingContent noun.                                       -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content with attachment in COLLATERAL -->
	name=IBM_MarketingContentImageMap
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$, 
				COLLIMGMAPAREA.$COLS:COLLIMGMAPAREA$				
		FROM
				COLLATERAL
					LEFT OUTER JOIN COLLIMGMAPAREA ON (COLLIMGMAPAREA.COLLATERAL_ID = COLLATERAL.COLLATERAL_ID 
						AND COLLIMGMAPAREA.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))					
		WHERE
				COLLATERAL.COLLATERAL_ID IN ($ENTITY_PKS$)
    ORDER BY COLLIMGMAPAREA.SEQUENCE ASC				
						
END_ASSOCIATION_SQL_STATEMENT
<!-- ======================================================================== -->
<!-- MarketingContent details including marketing content description,        -->
<!-- attachment reference description and image map.                          -->
<!-- This profile returns the following information:                          -->
<!--  1) Marketing content description                                        -->
<!--  2) Attachment reference description                                     -->
<!--  3) Marketing content image map                                          -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=COLLATERAL
         className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
         associated_sql_statement=IBM_MarketingContentDescription
         associated_sql_statement=IBM_MarketingContentAttachmentReferenceDescription
         associated_sql_statement=IBM_MarketingContentImageMap
    END_ENTITY
END_PROFILE

<!-- ======================================================================== -->
<!-- MarketingContent details including marketing content description and     -->
<!-- attachment reference description and image map.                          -->
<!-- This profile returns the following information:                          -->
<!--  1) Marketing content description                                        -->
<!--  2) Attachment reference description                                     -->
<!--  3) Marketing content image map                                          -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Store_Details
       BEGIN_ENTITY 
         base_table=COLLATERAL
         className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
         associated_sql_statement=IBM_MarketingContentDescription
         associated_sql_statement=IBM_MarketingContentAttachmentReferenceDescription
         associated_sql_statement=IBM_MarketingContentImageMap
    END_ENTITY
END_PROFILE
