<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2007                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
  
  <!-- PX_PROMOTION table -->
  COLS:PX_PROMOTION=PX_PROMOTION:*
  COLS:PX_PROMOTION_SUMMARY=PX_PROMOTION:PX_PROMOTION_ID, STOREENT_ID, NAME, VERSION, REVISION, PX_GROUP_ID, PRIORITY, STATUS, EXCLSVE, TYPE, CDREQUIRED, TGTSALES, STARTDATE, ENDDATE, PERORDLMT,PERSHOPPERLMT,TOTALLMT, EFFECTIVE, EXPIRE, TRANSFER


  <!-- PX_PROMOAUTH table -->
  COLS:PX_PROMOAUTH=PX_PROMOAUTH:*

  <!-- PX_PROMOCD table -->
  COLS:PX_PROMOCD=PX_PROMOCD:*

  <!-- PX_DESCRIPTION table -->
  COLS:PX_DESCRIPTION=PX_DESCRIPTION:*

  <!-- PX_GROUP table -->
  COLS:PX_GROUP=PX_GROUP:*
  
  <!-- PX_ELEMENT table -->
  COLS:PX_ELEMENT=PX_ELEMENT:*
  
  <!-- PX_ELEMENTNVP table -->
  COLS:PX_ELEMENTNVP=PX_ELEMENTNVP:*

    
END_SYMBOL_DEFINITIONS

<!-- ========================================================================= -->
<!--  Get the PX_PROMOTION(s) having the specified NAME and with the specified -->
<!--  access profile IBM_Admin_All                                             -->
<!--                                                                           -->
<!--  @param NAME                                                              -->
<!--     The name(s) for which to retrieve the PX_PROMOTION                    -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the Promotion. This parameter is      -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_PROMOTION[(NAME=)]+IBM_Admin_All 
  base_table=PX_PROMOTION 
  sql= 
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$, 
        PX_PROMOAUTH.$COLS:PX_PROMOAUTH$, 
        PX_GROUP.$COLS:PX_GROUP$, 
        PX_PROMOCD.$COLS:PX_PROMOCD$ 
    FROM 
        PX_PROMOTION  
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID 
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID 
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID 
    WHERE 
        PX_PROMOTION.NAME IN (?NAME?) 
        AND PX_PROMOTION.STOREENT_ID IN ($CTX:STORE_ID$) 
        AND PX_PROMOTION.STATUS IN (0,1,2,3) 
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================= -->
<!--  Get the PX_PROMOTION(s) having the specified ADMINSTVENAME and with the  -->
<!--  specified access profile IBM_Admin_All                                   -->
<!--                                                                           -->
<!--  @param ADMINSTVENAME                                                     -->
<!--     The administrative name(s) for which to retrieve the PX_PROMOTION     -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the Promotion. This parameter is      -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_PROMOTION[(ADMINSTVENAME=)]+IBM_Admin_All 
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$, 
        PX_PROMOAUTH.$COLS:PX_PROMOAUTH$,
        PX_GROUP.$COLS:PX_GROUP$,
        PX_PROMOCD.$COLS:PX_PROMOCD$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
    WHERE
        PX_PROMOAUTH.ADMINSTVENAME IN (?ADMINSTVENAME?)
        AND PX_PROMOTION.STOREENT_ID IN ($CTX:STORE_ID$)
        AND PX_PROMOTION.STATUS IN (0,1,2,3)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the PX_PROMOTION(s) having the specified PX_PROMOTION_ID(s) and with -->
<!--  the specified access profile IBM_Admin_All                               -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID(s) for which to retrieve the PX_PROMOTION         -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the Promotion. This parameter is      -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_PROMOTION[(PX_PROMOTION_ID=)]+IBM_Admin_All  
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$, 
        PX_PROMOAUTH.$COLS:PX_PROMOAUTH$,
        PX_GROUP.$COLS:PX_GROUP$,
        PX_PROMOCD.$COLS:PX_PROMOCD$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?PX_PROMOTION_ID?)
        AND PX_PROMOTION.STATUS IN (0,1,2,3)        
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the PX_DESCRIPTION(s) having the specified PX_PROMOTION_ID and with  -->
<!--  the specified access profile IBM_Admin_All                               -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID for which to retrieve the PX_DESCRIPTION(s)       -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the Promotion. This parameter is      -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_DESCRIPTION[(PX_PROMOTION_ID=)]+IBM_Admin_All
  base_table=PX_DESCRIPTION
  sql=
    SELECT 
        PX_DESCRIPTION.$COLS:PX_DESCRIPTION$ 
    FROM
        PX_PROMOTION 
        INNER JOIN PX_DESCRIPTION ON PX_PROMOTION.PX_PROMOTION_ID=PX_DESCRIPTION.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?PX_PROMOTION_ID?)
        AND PX_PROMOTION.STOREENT_ID IN ($CTX:STORE_ID$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the PX_ELEMENT(s) and its PX_ELEMENTNVP(s) having the specified      -->
<!--  PX_PROMOTION_ID and with the specified access profile IBM_Admin_All      -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID for which to retrieve the PX_ELEMENT(s)           -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the Promotion. This parameter is      -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_ELEMENT[(PX_PROMOTION_ID=)]+IBM_Admin_All 
  base_table=PX_ELEMENT
  sql=
    SELECT 
        PX_ELEMENT.$COLS:PX_ELEMENT$,       
        PX_ELEMENTNVP.$COLS:PX_ELEMENTNVP$        
    FROM
        PX_PROMOTION 
        INNER JOIN PX_ELEMENT ON PX_PROMOTION.PX_PROMOTION_ID=PX_ELEMENT.PX_PROMOTION_ID
        LEFT JOIN PX_ELEMENTNVP ON PX_ELEMENT.PX_ELEMENT_ID=PX_ELEMENTNVP.PX_ELEMENT_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?PX_PROMOTION_ID?)
        AND PX_PROMOTION.STOREENT_ID IN ($CTX:STORE_ID$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the PX_GROUP row having the specified PX_GROUP_ID and with the       -->
<!--  specified access profile IBM_Admin_All                                   -->
<!--                                                                           -->
<!--  @param PX_GROUP_ID                                                       -->
<!--     The PX_GROUP_ID for which to retrieve the PX_GROUP row                -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the PX_GROUP. This parameter is       -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_GROUP[PX_GROUP_ID=]+IBM_Admin_All
  base_table=PX_GROUP
  sql=  
    SELECT 
          PX_GROUP.$COLS:PX_GROUP$ 
        FROM
          PX_GROUP
    WHERE
        PX_GROUP.PX_GROUP_ID IN (?PX_GROUP_ID?)
        AND PX_GROUP.STOREENT_ID IN ($CTX:STORE_ID$)
        AND PX_GROUP.STATUS IN (0,1)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the PX_GROUP row having the specified GRPNAME and with the specified -->
<!--  access profile IBM_Admin_All                                             -->
<!--                                                                           -->
<!--  @param GRPNAME                                                           -->
<!--     The GRPNAME for which to retrieve the PX_GROUP row                    -->
<!--  @param Context:STORE_ID                                                  -->
<!--     The store for which to retrieve the PX_GROUP. This parameter is       -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_GROUP[GRPNAME=]+IBM_Admin_All
  base_table=PX_GROUP
  sql=  
    SELECT 
          PX_GROUP.$COLS:PX_GROUP$ 
        FROM
          PX_GROUP
    WHERE
        PX_GROUP.GRPNAME IN (?GRPNAME?)
        AND PX_GROUP.STOREENT_ID IN ($CTX:STORE_ID$)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- Get the PX_PROMOTION(s) having the specified CODE and with the specified  -->
<!-- access profile IBM_Admin_All. Only retrieve promotions whose 		       -->
<!-- STATUS is 1 i.e. active promotions							               -->
<!--  												 						   -->
<!-- @param CODE 											                   -->
<!-- 	The CODE for which to retrieve the PX_PROMOTION(s)  		           -->
<!-- @param STOREPATH:promotions                                               -->
<!--    The stores for which to retrieve the Promotion. This parameter is      -->
<!--    retrieved from within the business context.                            -->
<!-- @param UniqueID 														   -->
<!--    The additional stores to check.                                        -->
<!-- ========================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_PROMOTION[PromotionIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] AND (CODE=)]+IBM_Admin_All 
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$, 
		PX_PROMOAUTH.$COLS:PX_PROMOAUTH$      
    FROM
        PX_PROMOTION      
		INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
    WHERE
		( PX_PROMOTION.STOREENT_ID in ($STOREPATH:promotions$) OR PX_PROMOTION.STOREENT_ID in (?UniqueID?) ) 
		AND PX_PROMOTION.STATUS IN (1)
		AND PX_PROMOCD.CODE IN (?CODE?)        
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- Get the PX_PROMOTION(s) having the specified CODE and STOREENT_ID.        -->
<!-- Only retrieve promotions whose STATUS is 1 i.e. active promotions		   -->	 		       
<!--  												 						   -->
<!-- @param CODE 											                   -->
<!-- 	The CODE for which to retrieve the PX_PROMOTION(s)  		           -->
<!-- @param UniqueID 														   -->
<!--    The stores to check.                                                   -->
<!-- ========================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_PROMOTION[PromotionIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] AND (CODE=)]+IBM_Admin_Summary
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_SUMMARY$	      
    FROM
        PX_PROMOTION		
        INNER JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
    WHERE
		PX_PROMOTION.STOREENT_ID in (?UniqueID?)
		AND PX_PROMOTION.STATUS IN (1)
		AND PX_PROMOCD.CODE IN (?CODE?)        
END_XPATH_TO_SQL_STATEMENT



<!-- ========================================================================= -->
<!-- Get the PX_PROMOTION(s) having the specified PRIORITY and PX_GROUP_ID     -->
<!-- with the specified access profile IBM_Admin_All. Only retrieve            -->
<!-- promotions whose STATUS is 1 i.e. active promotions					   -->										   
<!--  												                           -->
<!-- @param PRIORITY 										                   -->
<!-- 	The PRIORITY for which to retrieve the PX_PROMOTION(s)  		       -->
<!-- @param GRPNAME 										                   -->
<!-- 	The GRPNAME of the promotion group to which the PX_PROMOTION(s)        -->
<!--	must belong  		       											   -->
<!-- @param STOREPATH:promotions                                               -->
<!--    The stores for which to retrieve the Promotion. This parameter is      -->
<!--    retrieved from within the business context.                            -->
<!-- @param UniqueID 														   -->
<!--    The additional stores to check.                                        -->
<!-- ========================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_PROMOTION[PromotionIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] AND PRIORITY= AND GRPNAME=]+IBM_Admin_All 
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$, 
		PX_PROMOAUTH.$COLS:PX_PROMOAUTH$        
    FROM
        PX_PROMOTION      
		INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID   
		LEFT JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID	
    WHERE
		( PX_PROMOTION.STOREENT_ID in ($STOREPATH:promotions$) OR PX_PROMOTION.STOREENT_ID in (?UniqueID?) ) 
		AND PX_PROMOTION.STATUS IN (1)
		AND PX_PROMOTION.PRIORITY = ?PRIORITY?
		AND PX_GROUP.GRPNAME = ?GRPNAME?  		
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Initialize the value of XMLPARAM filed of PX_PROMOTION to empty_clob()   -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID The identifier of the PX_PROMOTION row.           -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PX_PROMOTION
  name=IBM_Set_XMLPARAM_from_PX_PROMOTION_To_Empty_Clob
  sql=update PX_PROMOTION set XMLPARAM = EMPTY_CLOB() where PX_PROMOTION_ID = ?PX_PROMOTION_ID?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the XMLPARAM filed from PX_PROMOTION                                 -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID for which to retrieve the row                     -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PX_PROMOTION
  name=IBM_Select_XMLPARAM_from_PX_PROMOTION
  sql=select PX_PROMOTION_ID, XMLPARAM, PX_PROMOTION_ID from PX_PROMOTION where PX_PROMOTION_ID = ?PX_PROMOTION_ID? FOR UPDATE
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Initialize the value of XMLPARAM filed of PX_PROMOAUDIT to empty_clob()  -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID of the row                                        -->
<!--  @param VERSION                                                           -->
<!--     The VERSION of the row                                                -->
<!--  @param REVISION                                                          -->
<!--     The REVISION of the row                                               -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PX_PROMOTION
  name=IBM_Set_XMLPARAM_from_PX_PROMOAUDIT_To_Empty_Clob
  sql=update PX_PROMOAUDIT set XMLPARAM = EMPTY_CLOB() where PX_PROMOTION_ID = ?PX_PROMOTION_ID? and VERSION = ?VERSION? and REVISION = ?REVISION?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the XMLPARAM filed from PX_PROMOAUDIT                                -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The PX_PROMOTION_ID of the row                                        -->
<!--  @param VERSION                                                           -->
<!--     The VERSION of the row                                                -->
<!--  @param REVISION                                                          -->
<!--     The REVISION of the row                                               -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=PX_PROMOTION
  name=IBM_Select_XMLPARAM_from_PX_PROMOAUDIT
  sql=select PX_PROMOTION_ID, XMLPARAM, VERSION, REVISION from PX_PROMOAUDIT where PX_PROMOTION_ID = ?PX_PROMOTION_ID? and VERSION = ?VERSION? and REVISION = ?REVISION? FOR UPDATE
END_SQL_STATEMENT
