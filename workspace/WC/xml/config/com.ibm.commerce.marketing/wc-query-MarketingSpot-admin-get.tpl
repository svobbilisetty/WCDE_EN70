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
								
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Marketing Spot Access Profiles                                           -->
<!-- IBM_Admin_Details       All the columns from the EMSPOT table            -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=EMSPOT
  IBM_Details=IBM_Admin_Details
END_PROFILE_ALIASES

<!-- Marketing Spots -->

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- for all the eMarketingSpots in the current store, and in any stores      -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the eMarketingSpots in EMSPOT in one store -->
	name=/MarketingSpot[Usage=]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMSPOT.USAGETYPE = ?Usage?
	  ORDER BY EMSPOT.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMSPOT.USAGETYPE = ?Usage?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param MarketingSpotIdentifier The identifier of the eMarketing          -->
<!--                              spot to retrieve.                           -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch eMarketingSpots in EMSPOT by ID -->
	name=/MarketingSpot[MarketingSpotIdentifier[(UniqueID=)]]
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.EMSPOT_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name.                         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       marketing spot. This parameter is retrieved from within            -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = $CTX:STORE_ID$ AND
				EMSPOT.USAGETYPE = 'MARKETING' AND
		    EMSPOT.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name and usage.               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       marketing spot. This parameter is retrieved from within            -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name and usage in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[Name=]] and Usage=]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = $CTX:STORE_ID$ AND
				EMSPOT.USAGETYPE = ?Usage? AND
		    EMSPOT.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name and usage.               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param UniqueID The store for which to retrieve the marketing spot.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name, usage and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]] and Usage=]
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = ?UniqueID? AND
				EMSPOT.USAGETYPE = ?Usage? AND
		    EMSPOT.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified usage in the specific store.  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param UniqueID The store for which to retrieve the marketing spot.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name, usage and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[StoreIdentifier[UniqueID=]]] and Usage=]
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = ?UniqueID? AND
				EMSPOT.USAGETYPE = ?Usage?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- that match the specified search criteria                                 -->
<!-- for all the eMarketingSpots in the current store, and in any stores      -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the eMarketingSpots in EMSPOT in one store -->
	name=/MarketingSpot[Usage= and search()]
	base_table=EMSPOT
	sql=
		SELECT 
				DISTINCT EMSPOT.$COLS:EMSPOT_ID_NAME$
		FROM
				EMSPOT, $ATTR_TBLS$
		WHERE
				EMSPOT.STOREENT_ID in ($STOREPATH:campaigns$) AND
        EMSPOT.USAGETYPE = ?Usage? AND
				EMSPOT.$ATTR_CNDS$
	  ORDER BY EMSPOT.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the default content data of the MarketingSpot noun  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_DefaultContent -->
<!-- @param MarketingSpotIdentifier The identifier of the marketing spot for  -->
<!--                             which to retrieve the default content.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot default content in DMEMSPOTDEF table -->
	name=/MarketingSpot[MarketingSpotIdentifier[(UniqueID=)]]+IBM_Admin_DefaultContent
	base_table=DMEMSPOTDEF
	sql=
		SELECT 
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$				
		FROM
				DMEMSPOTDEF					
		WHERE
				DMEMSPOTDEF.EMSPOT_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the default content data of the MarketingSpot noun  -->
<!-- for the specified store identifier and usage type. Multiple results      -->
<!-- are returned based on the number of data entries for that store and      -->
<!-- usage.								      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_DefaultContent -->
<!-- @param Usage The usage type of the e-Marketing spot.                     -->
<!-- @param UniqueID The store for which to retrieve the marketing spot.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot default content in DMEMSPOTDEF table -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[StoreIdentifier[UniqueID=]]] and Usage=]+IBM_Admin_DefaultContent	    
	base_table=EMSPOT
	sql=
		SELECT 
			EMSPOT.$COLS:EMSPOT$,
			DMEMSPOTDEF.$COLS:DMEMSPOTDEF$ 
		FROM
			EMSPOT JOIN DMEMSPOTDEF ON (DMEMSPOTDEF.EMSPOT_ID = EMSPOT.EMSPOT_ID)			
		WHERE
			DMEMSPOTDEF.STOREENT_ID = ?UniqueID? AND			
			EMSPOT.USAGETYPE = ?Usage?

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
    END_ENTITY
END_PROFILE


