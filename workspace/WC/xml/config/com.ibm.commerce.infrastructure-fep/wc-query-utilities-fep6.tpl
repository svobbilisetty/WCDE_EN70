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

<!-- ========================================================================= -->
<!--  Determine all facetable columns registered for search                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SEARCH_COLUMN_DISPLAY_NAMES
	base_table=SRCHATTRDESC
	sql=
	SELECT SRCHATTR_ID,DISPLAYNAME
	from SRCHATTRDESC
	where 
		 SRCHATTRDESC.SRCHATTR_ID IN (?srchattrIdList?)
		 and 
		 LANGUAGE_ID=?languageId?
		 ORDER BY DISPLAYNAME
END_SQL_STATEMENT
