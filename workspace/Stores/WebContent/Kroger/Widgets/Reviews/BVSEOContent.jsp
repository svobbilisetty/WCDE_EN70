<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- 
  *****
  * This JSP makes available the SEO user generated content. 
  *****
--%>

<!-- BEGIN BVSEOContent.jsp -->

<%@ taglib uri="http://commerce.ibm.com/foundation-fep/stores" prefix="wcst" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="flow.tld" prefix="flow"%>


<flow:ifEnabled feature="RatingReviewIntegration">
		
	<wcst:storeconf var="runtimeURL" name="wc.bazaarvoice.runtime_url" />
	<wcst:storeconf var="seoBaseDir" name="wc.bazaarvoice.seoBaseDir" />
	<wcst:preview var="inPreview" />

	<c:set var="stagingString" value="staging"/>
	<c:choose>
		<c:when test="${inPreview == 'true'}">
			<c:set var="isPreview" value="true"/>
		</c:when>
		<c:when test="${fn:containsIgnoreCase(runtimeURL, stagingString)}">
			<c:set var="seoSuffix" value="staging"/>
		</c:when>
		<c:otherwise>
			<c:set var="seoSuffix" value="production"/>
		</c:otherwise>
	</c:choose>
		
	<!-- SEO User Generated Content. -->
	<%@ page import='java.io.BufferedReader'%>
	<%@ page import='java.io.File'%>
	<%@ page import='java.io.InputStreamReader'%>
	<%@ page import='java.io.FileInputStream'%>

	<%
	
		out.flush();
		StringBuilder seoStringBuilder = new StringBuilder();
		String isStorePreview = (String)pageContext.getAttribute("isPreview");

		FileInputStream fis = null;
		InputStreamReader istreamReader = null;
		BufferedReader reader = null;
	
		try {		
		
		  	if (isStorePreview != null && isStorePreview.equals("true")) {
				seoStringBuilder.append("<!-- No review SEO content will be shown on store preview. -->");		
		 	} else {		
				String RUNTIME_URL_SUFFIX = "-$locale$/bvapi.js";
				String runtimeURL = pageContext.getAttribute("runtimeURL").toString();
				String displayCode = "";
				int indexReturnCode = runtimeURL.indexOf(RUNTIME_URL_SUFFIX);
				if (indexReturnCode != -1) {
					displayCode = runtimeURL.substring(0, indexReturnCode);
					indexReturnCode = displayCode.lastIndexOf('/');
					if (indexReturnCode != -1) {
						displayCode = displayCode.substring(indexReturnCode + 1);
					}
				} 
		
				if (indexReturnCode == -1) {
					seoStringBuilder.append("<!-- No content because the value of wc.bazaarvoice.runtime_url in STORECONF (currently, ")
						.append(runtimeURL).append(") does not fit the expected format. Should end with ")
						.append(RUNTIME_URL_SUFFIX).append(" and there should be a forward slash that precedes this suffix.-->");
				} else {
					String lowerCaseLocale = request.getAttribute("locale").toString().toLowerCase();
					String seoBaseDirectory = pageContext.getAttribute("seoBaseDir").toString();
		
					Object seoSuffixObject = pageContext.getAttribute("seoSuffix");
					String seoDirSuffix;
					if (seoSuffixObject == null || !seoSuffixObject.toString().equals("staging")) {
						seoDirSuffix="/production";
					} else {
						seoDirSuffix="/staging";
					}
		
					String seoDirectory = seoStringBuilder.append(seoBaseDirectory).append(seoDirSuffix).toString();
					seoStringBuilder = new StringBuilder();
				
					String triplet = seoStringBuilder.append(request.getAttribute("catalogId")).append("_").append(request.getAttribute("storeId"))
						.append("_").append(request.getParameter("productId")).toString();
					seoStringBuilder = new StringBuilder(); 
		
					String seoFilePath= seoStringBuilder.append(seoDirectory).append("/").append(displayCode).append("-").append(lowerCaseLocale)
						.append("/reviews/product/1/").append(triplet).append(".htm").toString();
					File seoFile = new File(seoFilePath);
					seoStringBuilder = new StringBuilder();
				
					if (seoFile.exists() && seoFile.isFile()) {
						//Read in the file contents
						fis = new FileInputStream(seoFile);
						istreamReader = new InputStreamReader(fis, "UTF-8");
						reader = new BufferedReader(istreamReader);
						
						String line = null;
						String lineSep = System.getProperty("line.separator");
						while ((line = reader.readLine()) != null) {
							seoStringBuilder.append(line).append(lineSep);
						}
					} else if (!seoFile.exists()) {
						seoStringBuilder.append("<!-- No content because ").append(seoFilePath).append(" does not exist.-->");
					} else {
						seoStringBuilder.append("<!-- No content because ").append(seoFilePath).append(" is not a file.-->");
					}
				}
			}
		
		} catch (Exception ex) {
			seoStringBuilder.append("<!-- Caught exception when reading Bazaarvoice SEO content: ").append(ex.toString()).append("-->");
		} finally {
			if (fis != null) {
				fis.close();
			} 
			if (istreamReader != null) {
				istreamReader.close();
			} 
			if (reader != null) {
				reader.close();
			}
		}
		
		out.print(seoStringBuilder.toString());
		out.flush();
		

	%>
</flow:ifEnabled>

<!-- END BVSEOContent.jsp -->