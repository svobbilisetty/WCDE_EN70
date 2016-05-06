//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos
wc.render.declareRefreshController({
	id: "contentRecommendationRefresh_controller",
	renderContext: wc.render.getContextById("searchBasedNavigation_context"),
	url: "",
	formId: ""

,renderContextChangedHandler: function(message, widget) {
	var controller = this;
	var renderContext = this.renderContext;
	var resultType = renderContext.properties["resultType"];
	if(resultType == "products" || resultType == "both"){
		widget.refresh(renderContext.properties);
		console.log("espot refreshing");
	}
}
});
