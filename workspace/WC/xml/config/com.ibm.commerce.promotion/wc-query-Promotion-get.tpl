<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2008                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
  
  <!-- PX_PROMOTION table -->
  COLS:PX_PROMOTION=PX_PROMOTION:*
  COLS:PX_PROMOTION_PK=PX_PROMOTION:PX_PROMOTION_ID
  COLS:PX_PROMOTION_SUMMARY=PX_PROMOTION:PX_PROMOTION_ID, STOREENT_ID, NAME, VERSION, REVISION, PX_GROUP_ID, PRIORITY, STATUS, EXCLSVE, TYPE, CDREQUIRED, TGTSALES, STARTDATE, ENDDATE, PERORDLMT,PERSHOPPERLMT,TOTALLMT, EFFECTIVE, EXPIRE, TRANSFER

  <!-- PX_PROMOAUTH table -->
  COLS:PX_PROMOAUTH=PX_PROMOAUTH:*

  <!-- PX_PROMOCD table -->
  COLS:PX_PROMOCD=PX_PROMOCD:*

  <!-- PX_DESCRIPTION table -->
  COLS:PX_DESCRIPTION=PX_DESCRIPTION:*

  <!-- PX_GROUP table -->
  COLS:PX_GROUP=PX_GROUP:*
  COLS:PX_GROUP_IDS=PX_GROUP:PX_GROUP_ID, GRPNAME, STOREENT_ID
  
  <!-- PX_ELEMENT table -->
  COLS:PX_ELEMENT=PX_ELEMENT:*
  
  <!-- PX_ELEMENTNVP table -->
  COLS:PX_ELEMENTNVP=PX_ELEMENTNVP:*
    
END_SYMBOL_DEFINITIONS

<!-- ========================================================================= -->
<!--  Get the Promotion(s) having the specified unique id(s) (PX_PROMOTION_ID  -->
<!--  in PX_PROMOTION table)                                                   -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The identifier(s) for which to retrieve the Promotion                 -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[PromotionIdentifier[(UniqueID=)]]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?UniqueID?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) having the specified unique id(s) (PX_PROMOTION_ID  -->
<!--  in PX_PROMOTION table) and with the specified access profile             -->
<!--  IBM_Admin_PromotionElements                                              -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The identifier(s) for which to retrieve the Promotion                 -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--  @param Control:LANGUAGES                                                 -->
<!--     The language for which to retrieve the promotion description .This    --> 
<!--     parameter is retrieved from within the business context.              -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[PromotionIdentifier[(UniqueID=)]]+IBM_Admin_PromotionElements
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_SUMMARY$, 
        PX_ELEMENT.$COLS:PX_ELEMENT$,       
        PX_ELEMENTNVP.$COLS:PX_ELEMENTNVP$        
    FROM
        PX_PROMOTION 
        LEFT JOIN PX_ELEMENT ON PX_PROMOTION.PX_PROMOTION_ID=PX_ELEMENT.PX_PROMOTION_ID
        LEFT JOIN PX_ELEMENTNVP ON PX_ELEMENT.PX_ELEMENT_ID=PX_ELEMENTNVP.PX_ELEMENT_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?UniqueID?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
    ORDER BY PX_ELEMENT.PX_ELEMENT_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion(s)                                                     -->
<!--                                                                           -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion(s) that has its ElementType and its Id NVP matches     -->
<!--  the specified ElementType and Id value.                                  -->
<!--                                                                           -->
<!--  @param ElementType                                                       -->
<!--     The ElementType of the row in the PX_ELEMENT table                    -->
<!--  @param Value                                                             -->
<!--     The Value of the row in the PX_ELEMENTNVP table with its name as Id   -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[Element[(ElementType=) and ElementVariable[(Value=)]]]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_ELEMENT ON PX_PROMOTION.PX_PROMOTION_ID=PX_ELEMENT.PX_PROMOTION_ID AND PX_ELEMENT.TYPE IN (?ElementType?)
        INNER JOIN PX_ELEMENTNVP ON PX_ELEMENT.PX_ELEMENT_ID=PX_ELEMENTNVP.PX_ELEMENT_ID
    WHERE
        PX_ELEMENTNVP.NAME IN ('Id')
        AND PX_ELEMENTNVP.VALUE IN (?Value?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) of the specified type. Possible types include:      -->
<!--  0: This promotion is applicable to people who belong to one or more of   -->
<!--  the targeted customer profiles. 										   -->
<!--  When the targeted profile file list is empty, it applies to everyone.    -->
<!--  1: This promotion is applicable only to those to whom it has been        -->
<!--  explicitly granted, that is, this promotion is a coupon promotion.       -->
<!--                                                                           -->
<!--  @param CouponRequired                                                    -->
<!--     The type for which to retrieve the Promotion.                         -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[CouponRequired=]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
		AND PX_PROMOTION.TYPE = ?CouponRequired?
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) of the specified type that match the specified 	   -->
<!--  search criteria. Possible promotion types include:                       -->
<!--  0: This promotion is applicable to people who belong to one or more of   -->
<!--  the targeted customer profiles. 										   -->
<!--  When the targeted profile file list is empty, it applies to everyone.    -->
<!--  1: This promotion is applicable only to those to whom it has been        -->
<!--  explicitly granted, that is, this promotion is a coupon promotion.       -->
<!--                                                                           -->
<!--  @param CouponRequired                                                    -->
<!--     The type for which to retrieve the Promotion.                         -->
<!--  @param ATTR_CNDS                                                         -->
<!--     The search criteria.                                                  -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[CouponRequired= and search()]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOAUTH, PX_PROMOTION, $ATTR_TBLS$
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
        AND PX_PROMOTION.TYPE = ?CouponRequired?
        AND PX_PROMOTION.$ATTR_CNDS$
   ORDER BY
        PX_PROMOTION.PX_PROMOTION_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion(s) that match the specified search criteria.           -->
<!--                                                                           -->
<!--  @param ATTR_CNDS                                                         -->
<!--     The search criteria.                                                  -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[search()]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOAUTH, PX_PROMOTION, $ATTR_TBLS$
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
        AND PX_PROMOTION.$ATTR_CNDS$
   ORDER BY
        PX_PROMOTION.PX_PROMOTION_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion(s) with the specified access profile IBM_Admin_Details -->
<!--                                                                           -->
<!--  @param Context:ENTITY_PKS                                                -->
<!--     The primary keys of the Promotions.                                   -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--  @param Control:LANGUAGES                                                 -->
<!--     The language for which to retrieve the promotion description .This    --> 
<!--     parameter is retrieved from within the business context.              -->
<!--===========================================================================-->

BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_Admin_Details_AssociationSQL
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_SUMMARY$, 
        PX_PROMOAUTH.$COLS:PX_PROMOAUTH$,
        PX_GROUP.$COLS:PX_GROUP_IDS$,
        PX_PROMOCD.$COLS:PX_PROMOCD$,
        PX_DESCRIPTION.$COLS:PX_DESCRIPTION$        
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
        LEFT JOIN PX_DESCRIPTION ON PX_PROMOTION.PX_PROMOTION_ID=PX_DESCRIPTION.PX_PROMOTION_ID
        AND PX_DESCRIPTION.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID in ($ENTITY_PKS$) AND
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
    ORDER BY PX_PROMOTION.PX_PROMOTION_ID               
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Promotion Admin Details Access Profile                                   -->
<!-- This profile returns the details of the Promotion noun.                  -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=PX_PROMOTION
         associated_sql_statement=IBM_Admin_Details_AssociationSQL
    END_ENTITY
END_PROFILE

