<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%

java.util.Map requestParameterMap = request.getParameterMap();
java.util.Map escapedParameterMap = new java.util.HashMap();
java.util.List<String> excludingParams = new java.util.ArrayList();

for(Object keyObj:requestParameterMap.keySet()){
	if(keyObj instanceof String){
		String key = keyObj.toString();
		if(key.toString().contains("numberPlaceType")||key.contains("numberPlaceValue")||key.contains("definingCurrencyCodes")){
			excludingParams.add(key);
			String newKey = key.replace(".","#");
			escapedParameterMap.put(newKey,new String[]{request.getParameter(key)});
		}
	}
}
for(String key:excludingParams){
	requestParameterMap.remove(key);
}

requestParameterMap.putAll(escapedParameterMap);
getServletContext().getRequestDispatcher(request.getParameter("proxyUrl")).forward(request,response);
%>
