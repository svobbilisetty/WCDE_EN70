<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.location.facade.datatypes.PointOfInterestType"
	var="poi" expressionBuilder="findPointOfInterestByID" varShowVerb="showVerb">
	<wcf:param name="PoiId" value="${location}" />
</wcf:getData>


<c:set var="showVerb" value="${showVerb}" scope="request"/>
<c:set var="businessObject" value="${poi}" scope="request"/>

<object objectType="ReferencePOI">
    <pointOfInterestId>${poi.pointOfInterestIdentifier.uniqueID}</pointOfInterestId>
	
    <object objectType="LocationPOI" readonly="true">
        <regionId>${poi.regionID}</regionId>

        <objectStoreId>${param.storeId}</objectStoreId>

        <pointOfInterestId>${poi.pointOfInterestIdentifier.uniqueID}</pointOfInterestId>
        
       	<name>${poi.pointOfInterestIdentifier.externalIdentifier.identifier}</name>
       	
        <description>${poi.pointOfInterestIdentifier.externalIdentifier.identifier}</description>
    </object>
</object>

