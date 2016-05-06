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

  <!-- PX_PROMOTION table -->
  COLS:PX_PROMOTION=PX_PROMOTION:*
  
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

  <!-- PX_CDSPEC table -->
  COLS:PX_CDSPEC=PX_CDSPEC:*  
    
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
        PX_PROMOCD.$COLS:PX_PROMOCD$,
		PX_CDSPEC.$COLS:PX_CDSPEC$ 
    FROM 
        PX_PROMOTION  
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID 
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID 
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID 
		LEFT JOIN PX_CDSPEC ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDSPEC.PX_PROMOTION_ID 
    WHERE 
        PX_PROMOTION.NAME IN (?NAME?) 
        AND PX_PROMOTION.STOREENT_ID IN ($CTX:STORE_ID$) 
        AND PX_PROMOTION.STATUS IN (0,1,2,3,5) 
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
        PX_PROMOCD.$COLS:PX_PROMOCD$,
		PX_CDSPEC.$COLS:PX_CDSPEC$		
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
		LEFT JOIN PX_CDSPEC ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDSPEC.PX_PROMOTION_ID
    WHERE
        PX_PROMOAUTH.ADMINSTVENAME IN (?ADMINSTVENAME?)
        AND PX_PROMOTION.STOREENT_ID IN ($CTX:STORE_ID$)
        AND PX_PROMOTION.STATUS IN (0,1,2,3,5)
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
        PX_PROMOCD.$COLS:PX_PROMOCD$,
		PX_CDSPEC.$COLS:PX_CDSPEC$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID      
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
		LEFT JOIN PX_CDSPEC ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDSPEC.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?PX_PROMOTION_ID?)           
        AND PX_PROMOTION.STATUS IN (0,1,2,3,5)        
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
        AND PX_PROMOTION.STATUS IN (0,1,3,5)
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
        AND PX_PROMOTION.STATUS IN (0,1,3,5)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- Get the PX_PROMOTION(s) having the specified CODE and with the specified  -->
<!-- access profile IBM_Admin_All. Only retrieve promotions whose 		       -->
<!-- STATUS is 1(active) or 5(activating).						               -->
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
		AND PX_PROMOTION.STATUS IN (1,5)
		AND PX_PROMOCD.CODE IN (?CODE?)        
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- Get the PX_PROMOTION(s) having the specified PRIORITY and PX_GROUP_ID     -->
<!-- with the specified access profile IBM_Admin_All. Only retrieve            -->
<!-- promotions whose STATUS is 1(active) or 5(activating).					   -->										   
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
		AND PX_PROMOTION.STATUS IN (1,5)
		AND PX_PROMOTION.PRIORITY = ?PRIORITY?
		AND PX_GROUP.GRPNAME = ?GRPNAME?  		
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Update the OBJECTID field of the UPLOADFILE table.                       -->
<!--                                                                           -->
<!--  @param OBJECTID                                                          -->
<!--     The OBJECTID value to set                                             -->
<!--  @param UPLOADFILE_ID                                                     -->
<!--     The UPLOADFILE_ID of the row                                          -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=UPLOADFILE
  name=IBM_Set_OBJECTID_To_PROMOTION_ID
  sql=update UPLOADFILE set OBJECTID = ?OBJECTID? where UPLOADFILE_ID = ?UPLOADFILE_ID?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will create a PX_CDPOOL entry.                                  -->
<!-- @param PX_CDPOOL_ID The primary key of the entry.                        -->
<!-- @param STORE_ID The store identifier.                                    -->
<!-- @param USAGETYPE The type of code - public vs private.                   -->
<!-- @param CODE The promotion code.                                          -->
<!-- @param STATUS The status of the code. 									  -->
<!-- @param TRANSFERABLE To indicate if the code can be transferred or not.   -->
<!-- @param REFERENCE_ID The promotion identifier.                            -->
<!-- @param INTERNAL_ID Internally used identifier.   						  -->
<!-- @param WORKSPACE The base schema name.         						  -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- insert entries into PX_CDPOOL -->
  base_table=PX_CDPOOL
	name=IBM_Admin_Insert_InsertPxCdPool
	sql=insert into PX_CDPOOL (PX_CDPOOL_ID, STORE_ID, USAGETYPE, CODE, STATUS, TRANSFERABLE, REFERENCE_ID, INTERNAL_ID, WORKSPACE) values ( ?PX_CDPOOL_ID?, ?STORE_ID?, ?USAGETYPE?, ?CODE?, ?STATUS?, ?TRANSFERABLE?, ?REFERENCE_ID?, ?INTERNAL_ID?, ?WORKSPACE?)
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will create a PX_CDPOOL entry.                                  -->
<!-- @param PX_CDPOOL_ID The primary key of the entry.                        -->
<!-- @param STORE_ID The store identifier.                                    -->
<!-- @param USAGETYPE The type of code - public vs private.                   -->
<!-- @param CODE The promotion code.                                          -->
<!-- @param STATUS The status of the code. 									  -->
<!-- @param TRANSFERABLE To indicate if the code can be transferred or not.   -->
<!-- @param REFERENCE_ID The promotion identifier.                            -->
<!-- @param INTERNAL_ID Internally used identifier.   						  -->
<!-- @param WORKSPACE The name of the workspace.     						  -->
<!-- @param TASKGROUP The name of the taskgroup.    						  -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- insert entries into PX_CDPOOL -->
  base_table=PX_CDPOOL
	name=IBM_Admin_Insert_InsertPxCdPoolForWorkspace
	sql=insert into PX_CDPOOL (PX_CDPOOL_ID, STORE_ID, USAGETYPE, CODE, STATUS, TRANSFERABLE, REFERENCE_ID, INTERNAL_ID, WORKSPACE, TASKGROUP) values ( ?PX_CDPOOL_ID?, ?STORE_ID?, ?USAGETYPE?, ?CODE?, ?STATUS?, ?TRANSFERABLE?, ?REFERENCE_ID?, ?INTERNAL_ID?, ?WORKSPACE?, ?TASKGROUP?)
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will create a PX_CDPROMO entry.                                 -->
<!-- @param PX_CDPROMO_ID The primary key of the entry.                       -->
<!-- @param PX_CDPOOL_ID The corresponding PX_CDPOOL_ID entry.                -->
<!-- @param PX_PROMOTION_ID The ID of the promotion that the code belongs to. -->
<!-- @param STATUS The status of the code. 	                                  -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- insert entries into PX_CDPROMO -->
  base_table=PX_CDPROMO
	name=IBM_Admin_Insert_InsertPxCdPromo
	sql=insert into PX_CDPROMO (PX_CDPROMO_ID, PX_CDPOOL_ID, PX_PROMOTION_ID, STATUS, LASTUPDATE) values ( ?PX_CDPROMO_ID?, ?PX_CDPOOL_ID?, ?PX_PROMOTION_ID?, ?STATUS?, CURRENT_TIMESTAMP)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete codes in the PX_CDPOOL table using PX_PROMOTION_ID.               -->
<!--  @param PX_PROMOTION_ID The promotion identifier.                         -->
<!--========================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete entries from PX_CDPOOL table by PX_PROMOTION_ID -->
  base_table=PX_CDPOOL
	name=IBM_Delete_PX_CDPOOL_by_PX_PROMOTION_ID
	sql=delete from px_cdpool where reference_id=?PX_PROMOTION_ID?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete codes in the PX_CDPOOL table using PX_PROMOTION_ID and USAGETYPE. -->
<!--  @param PX_PROMOTION_ID The promotion identifier.                         -->
<!--  @param USAGETYPE The promotion code usage type (0: Private 1: Public).   -->
<!--========================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete entries from PX_CDPOOL table by PX_PROMOTION_ID -->
  base_table=PX_CDPOOL
	name=IBM_Delete_PX_CDPOOL_by_PX_PROMOTION_ID_and_USAGETYPE
	sql=delete from px_cdpool where reference_id=?PX_PROMOTION_ID? and usagetype=?USAGETYPE?
END_SQL_STATEMENT