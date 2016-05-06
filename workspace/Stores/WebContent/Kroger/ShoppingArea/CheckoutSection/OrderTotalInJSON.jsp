<%
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2008
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>
<%--
  *****
  * This JSP file is used to create a JSON that has the order total amount.
  *****
--%>
<%@	page session="false"%><%@ 
	page pageEncoding="UTF-8"%><%@
	taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %><%@ 
	taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<wcf:getData type="com.ibm.commerce.order.facade.datatypes.OrderType"
       var="order" expressionBuilder="findCurrentShoppingCartWithPagingOnItem" varShowVerb="ShowVerbCart" maxItems="1" recordSetStartNumber="0" recordSetReferenceId="jsonorder">
	<wcf:param name="accessProfile" value="IBM_Summary" />
	<wcf:param name="sortOrderItemBy" value="orderItemID" />
	<wcf:param name="isSummary" value="true" />
</wcf:getData>

/*
{
	orderTotal: <wcf:json object="${order.orderAmount.grandTotal.value}"/>,
	operation: "<c:out value="${param.operation}"/>",
	piFormName: "<c:out value="${param.piFormName}"/>",
	skipOrderPrepare: "<c:out value="${param.skipOrderPrepare}"/>"
}
*/
