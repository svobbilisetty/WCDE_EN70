<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2007, 2010                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

	<!-- EMSPOT table -->
	COLS:EMSPOT=EMSPOT:*
	COLS:EMSPOT_ID_NAME=EMSPOT:EMSPOT_ID, NAME
	COLS:DMEMSPOTDEF=DMEMSPOTDEF:*	
	COLS:DMEMSPOTCOLLDEF=DMEMSPOTCOLLDEF:*
								
END_SYMBOL_DEFINITIONS


<!-- ======================================================================== -->
<!-- This SQL will return the default content data of the MarketingSpot noun  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_DefaultContent -->
<!-- @param MarketingSpotIdentifier The identifier of the marketing spot for  -->
<!--                             which to retrieve the default content.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot title in EMSPOTCOLLDEF table -->
	name=/MarketingSpot[MarketingSpotIdentifier[(UniqueID=)]]+IBM_Admin_MarketingSpotTitle
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				DMEMSPOTCOLLDEF					
		WHERE
				DMEMSPOTCOLLDEF.EMSPOT_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the details of the MarketingSpot noun.   -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- returns eMarketingSpots in EMSPOT -->
	name=IBM_MarketingSpotDetailsAssoc
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.EMSPOT_ID in ($ENTITY_PKS$)
	  	ORDER BY EMSPOT.NAME								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing spot default content   -->
<!-- info of the MarketingSpot noun.                                          -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Spot with default content in EMSPOT and DMEMSPOTDEF -->
	name=IBM_MarketingSpotDefaultContent
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$				
		FROM
				EMSPOT 
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.STOREENT_ID IN ($STOREPATH:campaigns$))								
		WHERE
				EMSPOT.EMSPOT_ID IN ($ENTITY_PKS$)
						
END_ASSOCIATION_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing spot title   -->
<!-- info of the MarketingSpot noun.                                          -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Spot with title in EMSPOT and DMEMSPOTCOLLDEF -->
	name=IBM_MarketingSpotTitle
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				EMSPOT 
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.STOREENT_ID IN ($STOREPATH:campaigns$))								
		WHERE
				EMSPOT.EMSPOT_ID IN ($ENTITY_PKS$)
						
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- MarketingSpot Admin Details Access Profile                               -->
<!-- This profile returns the details of the MarketingSpot noun.              -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=EMSPOT
         className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
         associated_sql_statement=IBM_MarketingSpotDetailsAssoc         
         associated_sql_statement=IBM_MarketingSpotDefaultContent
         associated_sql_statement=IBM_MarketingSpotTitle
    END_ENTITY
END_PROFILE
