<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- BEGIN BVSubmissionRedirect.jsp --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<%@ taglib uri="flow.tld" prefix="flow"%>
<%@include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/ReviewsSetup.jspf"%>

<flow:ifEnabled feature="RatingReviewIntegration">
	<c:choose>
		<c:when test="${reviewParameters.provider eq 'BV'}">
			<wcf:url var="bvCommandUrl" value="SocialCommerceBV">
				<wcf:param name="catalogId" value="${catalogId}" />
				<wcf:param name="storeId" value="${storeId}" />
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="bvdisplaycode" value="${WCParam.bvdisplaycode}" />
				<wcf:param name="bvappcode" value="${WCParam.bvappcode}" />
				<wcf:param name="bvproductid" value="${WCParam.bvproductid}" />
				<wcf:param name="bvcontenttype" value="${WCParam.bvcontenttype}" />
				<wcf:param name="bvauthenticateuser"
					value="${WCParam.bvauthenticateuser}" />
				<wcf:param name="bvpage" value="${WCParam.bvpage}" />
			</wcf:url>

			<%-- Use this URL to provide the LognForm Service a return URL to Bazaarvoice 
		controller command that renders the review submission form directly--%>
			<wcf:url var="logonFormToSubmissionPage" value="LogonForm">
				<wcf:param name="catalogId" value="${catalogId}" />
				<wcf:param name="storeId" value="${storeId}" />
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="URL" value="${bvCommandUrl}" />
			</wcf:url>

			<%-- Use this URL to provide the LognForm Service a return URL to calling 
		product page. Not calling  command directly because IE URL length issue, see 218772 & 219733--%>
			<wcf:url var="logonFormToProductPage" value="LogonForm">
				<wcf:param name="catalogId" value="${catalogId}" />
				<wcf:param name="storeId" value="${storeId}" />
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="URL" value="${WCParam.scProductURL}" />
			</wcf:url>

			<%--   	 
	 <c:set var="bvCommandUrl1" value="${bvCommandUrl}" scope="request">   </c:set>
	    <c:set var="bvauthenticateuser" value="${WCParam.bvauthenticateuser}" scope="request">   </c:set>
		    
	     <%
	    
	    		System.out.println("*** bvCommandUrl = " + request.getAttribute("bvCommandUrl1"));
			
	    		System.out.println("***  bvauthenticateuser = " + request.getAttribute("bvauthenticateuser"));
	     %>
	--%>
			<c:choose>
				<c:when test="${WCParam.bvauthenticateuser eq 'true'}">
					<c:choose>
						<%-- Check for IE. IE URL to long issue, see  218772 & 219733--%>
						<c:when test="${(userType == 'G')}">
							<%-- Change to javascript for d226880 --%>
							<script type="text/javascript">						
								var ie7 = (navigator.userAgent.toLowerCase().indexOf("msie 7.0") > -1);
								var ie8 = (navigator.userAgent.toLowerCase().indexOf("msie 8.0") > -1);
							
								if (ie7 || ie8) {
									window.location.href="<c:out value='${logonFormToProductPage}' escapeXml='false'/>";
								}
								else {
									window.location.href="<c:out value='${logonFormToSubmissionPage}' escapeXml='false'/>";
								}
							</script>
						</c:when>
						<c:otherwise>
							<c:redirect url="${bvCommandUrl}"></c:redirect>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:set var="incfile" value="BVSubmissionRender.jsp" />
					<%out.flush();%>
					<c:import url="${incfile}" />
					<%out.flush();%>
				</c:otherwise>
			</c:choose>
		</c:when>
	</c:choose>
</flow:ifEnabled>

<%-- END BVSubmissionRedirect.jsp --%>