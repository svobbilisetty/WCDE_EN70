//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos
wc.render.declareContext("searchBasedNavigation_context", {"contentBeginIndex":"0", "productBeginIndex":"0", "beginIndex":"0", "orderBy":"", "isHistory":"false", "pageView":"", "resultType":"both", "orderByContent":"", "searchTerm":"", "facet":"", "facetLimit":"", "minPrice":"", "maxPrice":""}, "");

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Products).
wc.render.declareRefreshController({
	id: "searchBasedNavigation_controller",
	renderContext: wc.render.getContextById("searchBasedNavigation_context"),
	url: "",
	formId: ""

,renderContextChangedHandler: function(message, widget) {
	var controller = this;
	var renderContext = this.renderContext;
	var resultType = renderContext.properties["resultType"];
	if(resultType == "products" || resultType == "both"){
		renderContext.properties["beginIndex"] = renderContext.properties["productBeginIndex"];
		widget.refresh(renderContext.properties);
	}
}

,postRefreshHandler: function(widget) {
	// Handle the new facet counts, and update the values in the left navigation.  First parse the script, and then call the update function.
	var facetCounts = $("facetCounts");
	if(facetCounts != null) {
		var scripts = facetCounts.getElementsByTagName("script");
		var j = scripts.length;
		for (var i = 0; i < j; i++){
			var newScript = document.createElement('script');
			newScript.type = "text/javascript";
			newScript.text = scripts[i].text;
			facetCounts.appendChild(newScript);
		}
		SearchBasedNavigationDisplayJS.resetFacetCounts();
		updateFacetCounts();
		SearchBasedNavigationDisplayJS.validatePriceInput();
	}

	var resultType = widget.controller.renderContext.properties["resultType"];
	if(resultType == "products" || resultType == "both"){
		var currentIdValue = currentId;
		cursor_clear();  
		//If the refresh was done on click of back/forward button, do not add the state to histroy list..else we will end up in infinite loop..
		if(widget.controller.renderContext.properties['isHistory'] == 'false'){
			var currentContextProperties = widget.controller.renderContext.properties;
			dojo.back.addToHistory(new SearchBasedNavigationDisplayJS.HistoryTracker(currentContextProperties));	
		}
		SearchBasedNavigationDisplayJS.initControlsOnPage(widget.controller.renderContext.properties);
		shoppingActionsJS.updateSwatchListView();
		shoppingActionsJS.checkForCompare();
		var gridViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_grid_categoryResults";
		var listViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_list_categoryResults";
		if(currentIdValue == "orderBy"){
			$("orderBy").focus();
		}
		else{
			if((currentIdValue == gridViewLinkId || currentIdValue != listViewLinkId) && $(listViewLinkId)){
				$(listViewLinkId).focus();
			}
			if((currentIdValue == listViewLinkId || currentIdValue != gridViewLinkId) && $(gridViewLinkId)){
				$(gridViewLinkId).focus();
			}
		}
	}
	var pagesList = document.getElementById("pages_list_id");
	if (pagesList != null && !isAndroid() && !isIOS()) {
		dojo.addClass(pagesList, "desktop");
	}
	dojo.publish("CMPageRefreshEvent");
}
});

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Articles and videos).
wc.render.declareRefreshController({
	id: "searchBasedNavigation_content_controller",
	renderContext: wc.render.getContextById("searchBasedNavigation_context"),
	url: "",
	formId: ""

,renderContextChangedHandler: function(message, widget) {
	var controller = this;
	var renderContext = this.renderContext;
	var resultType = renderContext.properties["resultType"];
	if(resultType == "content" || resultType == "both"){
		renderContext.properties["beginIndex"] = renderContext.properties["contentBeginIndex"];
		widget.refresh(renderContext.properties);
	}
}

,postRefreshHandler: function(widget) {
	var resultType = widget.controller.renderContext.properties["resultType"];
	if(resultType == "content" || resultType == "both"){
			var currentIdValue = currentId;
			cursor_clear();  
			//If the refresh was done on click of back/forward button, do not add the state to histroy list..
			if(widget.controller.renderContext.properties['isHistory'] == 'false'){
				var currentContextProperties = widget.controller.renderContext.properties;
				dojo.back.addToHistory(new SearchBasedNavigationDisplayJS.HistoryTracker(currentContextProperties));	
			}
			SearchBasedNavigationDisplayJS.initControlsOnPage(widget.controller.renderContext.properties);
			shoppingActionsJS.initCompare();
			if(currentIdValue == "orderByContent"){
				$("orderByContent").focus();
			}
		}
	}
});



if(typeof(SearchBasedNavigationDisplayJS) == "undefined" || SearchBasedNavigationDisplayJS == null || !SearchBasedNavigationDisplayJS){

	SearchBasedNavigationDisplayJS = {

		/** 
		 * This variable is an array to contain all of the facet ID's generated from the initial search query.  This array will be the master list when applying facet filters.
		 */
		facetIdsArray: new Array,

		init:function(searchResultUrl){
			wc.render.getRefreshControllerById('searchBasedNavigation_controller').url = searchResultUrl;
			this.initControlsOnPage(WCParamJS);
			this.updateContextProperties("searchBasedNavigation_context", WCParamJS);

			var currentContextProperties = wc.render.getContextById('searchBasedNavigation_context').properties;
			var historyObject = new SearchBasedNavigationDisplayJS.HistoryTracker(currentContextProperties);
			dojo.back.setInitialState(historyObject);	
		},

		initConstants:function(imgUrlPath, removeCaption, moreMsg, lessMsg) {
			this.imgUrlPath = imgUrlPath;
			this.removeCaption = removeCaption;
			this.moreMsg = moreMsg;
			this.lessMsg = lessMsg;
		},

		initControlsOnPage:function(properties){
			//Set state of sort by select box..
			var selectBox = dojo.byId("orderBy");
			if(selectBox != null && selectBox != 'undefined'){
				dojo.byId("orderBy").value = properties['orderBy'];
			}

			selectBox = dojo.byId("orderByContent");
			if(selectBox != null && selectBox != 'undefined'){
				dojo.byId("orderByContent").value = properties['orderByContent'];
			}
		},

		initContentUrl:function(contentUrl){
			wc.render.getRefreshControllerById('searchBasedNavigation_content_controller').url = contentUrl;
		},

		resetFacetCounts:function() {
			for(var i = 0; i < this.facetIdsArray.length; i++) {
				var facetValue = $("facet_count" + this.facetIdsArray[i]);
				if(facetValue != null) {
					facetValue.innerHTML = 0;
				}	
			}
		},

		updateFacetCount:function(id, count, value, label, image, contextPath, group, multiFacet) {
			var facetValue = $("facet_count" + id);
			if(facetValue != null) {
				var checkbox = $("facet_checkbox" + id);
				if(count > 0) {
					// Reenable the facet link
					checkbox.disabled = false;
					facetValue.innerHTML = count;
				}
			}	
			else if(count > 0) {
				var moresection = $("moresection_" + group);
				if(moresection != null && moresection.style.display == "block") {
					// there is no limit to the number of facets shown, and the user has exposed the show all link
					if($("facet_" + id) == null) {
						// this facet does not exist in the list.  Insert it.
						var grouping = $("more_" + group);
						if(grouping) {
							this.facetIdsArray.push(id);
							var newFacet = document.createElement("li");
							var facetClass = "";
							var section = "";
							
							if(!multiFacet) {
								facetClass = "singleFacet";
								// specify which facet group to collapse when multifacets are not enabled.
								section = group;
							}
							if(image != "") {
								facetClass = "singleFacet left";

							}

							newFacet.setAttribute("id", "facet_" + id);
							newFacet.setAttribute("class", facetClass);


							var facetLabel = "<label for='facet_checkbox" + id + "'>";

							if(image != "") {
								facetLabel = facetLabel + "<span class='swatch'><span class='outline'><span id='facetLabel_" + id + "'><img src='" + contextPath + "/" + image + "' title='" + label + "' alt='" + label + "'/></span> (<span id='facet_count" + id + "'>" + count + "</span>)</span></span>";
							}
							else {
								facetLabel = facetLabel + "<span class='outline'><span id='facetLabel_" + id + "'>" + label + "</span> (<span id='facet_count" + id +"'>" + count + "</span>)</span>";
							}

							facetLabel = facetLabel + "<span class='spanacce' id='facet_checkbox" + id + "_ACCE_Label'>" + label + " (" + count + ")</span></label>";

							newFacet.innerHTML = "<input type='checkbox' aria-labelledby='facet_checkbox" + id + "_ACCE_Label' id='facet_checkbox" + id + "' value='" + value + "' onclick='javascript: SearchBasedNavigationDisplayJS.toggleSearchFilter(this, \"" + id + "\", \"" + section + "\")'/>" + facetLabel;
							grouping.appendChild(newFacet);
						}
					}
				}
			}
		},

		isValidNumber:function(n) {
			return !isNaN(parseFloat(n)) && isFinite(n) && n >= 0;
		},

		checkPriceInput:function(event, currencySymbol, section) {
			if(this.validatePriceInput() && event.keyCode == 13) {
				this.appendFilterPriceRange(currencySymbol, section);
			}
			return false;
		},

		validatePriceInput:function() {
			if($("low_price_input") != null && $("high_price_input") != null && $("price_range_go") != null) {
				var low = $("low_price_input").value;
				var high = $("high_price_input").value;
				var go = $("price_range_go");
				if(this.isValidNumber(low) && this.isValidNumber(high) && parseFloat(high) > parseFloat(low)) {
					go.className = "go_button";
					go.disabled = false;
				}
				else {
					go.className = "go_button_disabled";
					go.disabled = true;
				}	
				return !go.disabled;
			}
			return false;
		},

		toggleShowMore:function(index, show) {
			var list = $('more_' + index);
			var morelink = $('morelink_' + index);
			if(list != null) {
				if(show) {
					morelink.style.display = "none";
					list.style.display = "block";
				}
				else {
					morelink.style.display = "block";
					list.style.display = "none";
				}
			}
		},
		
		toggleSearchFilterOnKeyDown:function(event, element, id, section) {
			if (event.keyCode == dojo.keys.ENTER) {
				element.checked = !element.checked;
				this.toggleSearchFilter(element, id, section);
			}
		},
		
		toggleSearchFilter:function(element, id, section) {
			if(element.checked) {
				this.appendFilterFacet(id, section);
			}
			else {
				this.removeFilterFacet(id, section);
			}

			if(section != "") {
				$('section_' + section).style.display = "none";
			}
		},

		appendFilterPriceRange:function(currencySymbol, section) {
			var facetFilterList = $("facetFilterList");
			// create facet filter list if it's not exist
			if (facetFilterList == null) {
				facetFilterList = document.createElement("ul");
				facetFilterList.setAttribute("id", "facetFilterList");
				var facetFilterListWrapper = $("facetFilterListWrapper");
				facetFilterListWrapper.appendChild(facetFilterList);
			}
			
			var filter = $("pricefilter");
			if(filter == null) {
				filter = document.createElement("li");
				filter.setAttribute("id", "pricefilter");
				facetFilterList.appendChild(filter);
			}
			var label = currencySymbol + $("low_price_input").value + " - " + currencySymbol + $("high_price_input").value;
			filter.innerHTML = "<a role='button' href='#' onclick='SearchBasedNavigationDisplayJS.removeFilterPriceRange(\"" + section + "\"); return false;'>" + "<div class='filter_option'><div class='filter_sprite'><img src='" + this.imgUrlPath + "' alt='" + this.removeCaption + "' title='" + this.removeCaption + "'></div><span>" + label + "</span></div></a>";

			$("clear_all_filter").style.display = "block";

			if(this.validatePriceInput()) {
				// Promote the values from the input boxes to the internal inputs for use in the request.
				$("low_price_value").value = $("low_price_input").value;
				$("high_price_value").value = $("high_price_input").value;
			}

			if(section != "") {
				$('section_' + section).style.display = "none";
			}
			this.doSearchFilter();			
		},

		removeFilterPriceRange:function(section) {
			if($("low_price_value") != null && $("high_price_value") != null) {
				$("low_price_value").value = "";
				$("high_price_value").value = "";	
			}
			var facetFilterList = $("facetFilterList");
			var filter = $("pricefilter");
			if(filter != null) {
				facetFilterList.removeChild(filter);
			}

			if(facetFilterList.childNodes.length == 0) {
				$("clear_all_filter").style.display = "none";
				$("facetFilterListWrapper").innerHTML = "";
			}
			if(section != "") {
				$('section_' + section).style.display = "block";
			}
			this.doSearchFilter();
		},

		appendFilterFacet:function(id, section) {
			var facetFilterList = $("facetFilterList");
			// create facet filter list if it's not exist
			if (facetFilterList == null) {
				facetFilterList = document.createElement("ul");
				facetFilterList.setAttribute("id", "facetFilterList");
				var facetFilterListWrapper = $("facetFilterListWrapper");
				facetFilterListWrapper.appendChild(facetFilterList);
			}
			
			var filter = $("filter_" + id);
			// do not add it again if the user clicks repeatedly
			if(filter == null) {
				filter = document.createElement("li");
				filter.setAttribute("id", "filter_" + id);
				var label = $("facetLabel_" + id).innerHTML;
				filter.innerHTML = "<a role='button' href='#' onclick='SearchBasedNavigationDisplayJS.removeFilterFacet(\"" + id + "\", \"" + section + "\"); return false;'>" + "<div class='filter_option'><div class='filter_sprite'><img src='" + this.imgUrlPath + "' alt='" + this.removeCaption + "' title='" + this.removeCaption + "'></div><span>" + label + "</span></div></a>";
				facetFilterList.appendChild(filter);
			}

			$("clear_all_filter").style.display = "block";
			this.doSearchFilter();
		},

		removeFilterFacet:function(id, section) {
			var facetFilterList = $("facetFilterList");
			var filter = $("filter_" + id);
			if(filter != null) {
				facetFilterList.removeChild(filter);
				$("facet_checkbox" + id).checked = false;
			}

			if(facetFilterList.childNodes.length == 0) {
				$("clear_all_filter").style.display = "none";
				$("facetFilterListWrapper").innerHTML = "";
			}

			if(section != "") {
				$('section_' + section).style.display = "block";
			}
			this.doSearchFilter();
		},

		getEnabledProductFacets:function() {
			var facetForm = document.forms['productsFacets'];
			var elementArray = facetForm.elements;

			var facetArray = new Array();
			if(_searchBasedNavigationFacetContext != 'undefined') {
				for(var i=0; i< _searchBasedNavigationFacetContext.length; i++) {
					facetArray.push(_searchBasedNavigationFacetContext[i]);
				}
			}
			var facetLimits = new Array();
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX") {
					if(element.title == "MORE") {
						// scan for "See More" facet enablement.
						if(element.checked) {
							facetLimits.push(element.value);
						}
					}
					else {
						// disable the checkbox while the search is being performed to prevent double clicks
						element.disabled = true;
						if(element.checked) {
							facetArray.push(element.value);
						}
					}
				}
			}
			// disable the price range button also
			if($("price_range_go") != null) {
				$("price_range_go").disabled = true;
			}

			var results = new Array();
			results.push(facetArray);
			results.push(facetLimits);
			return results;
		},

		doSearchFilter:function() {
			if(!submitRequest()){
				return;
			}
			cursor_wait();  

			var minPrice = "";
			var maxPrice = "";
			
			if($("low_price_value") != null && $("high_price_value") != null) {
				minPrice = $("low_price_value").value;
				maxPrice = $("high_price_value").value;
			}

			var facetArray = this.getEnabledProductFacets();
			
			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0", "facet": facetArray[0], "facetLimit": facetArray[1], "resultType":"products", "minPrice": minPrice, "maxPrice": maxPrice, "isHistory": "false"});
			MessageHelper.hideAndClearMessage();
		},

		toggleShowMore:function(element, id) {
			var section = $("moresection_" + id);
			var label = $("showMoreLabel_" + id);
			if(element.checked) {
				section.style.display = "block";
				label.innerHTML = this.lessMsg;
				this.doSearchFilter();
			}
			else {
				section.style.display = "none";
				label.innerHTML = this.moreMsg;
			}
		},

		clearAllFacets:function() {
			$("clear_all_filter").style.display = "none";
			$("facetFilterListWrapper").innerHTML = "";
			if($("low_price_value") != null && $("high_price_value") != null) {
				$("low_price_value").value = "";
				$("high_price_value").value = "";
			}

			var facetForm = document.forms['productsFacets'];
			var elementArray = facetForm.elements;
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX" && element.checked && element.title != "MORE") {
					element.checked = false;
				}
			}

			var elems = document.getElementsByTagName("*");
			for (var i=0; i < elems.length; i++) {
				// Reset all hidden facet sections (single selection facets are hidden after one facet is selected from that facet grouping).
				var element = elems[i];
				if (element.id != null && (element.id.indexOf("section_") == 0) && !(element.id.indexOf("section_list") == 0)) {
					element.style.display = "block";
				}
			}


			this.doSearchFilter();
		},

		toggleSearchContentFilter:function() {
			if(!submitRequest()){
				return;
			}
			cursor_wait();  

			var facetList = "";
			var facetForm = document.forms['contentsFacets'];
			var elementArray = facetForm.elements;
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX" && element.checked && element.title != "MORE") {
					facetList += element.value + ";";
				}
			}
			
			wc.render.updateContext('searchBasedNavigation_context', {"facet": facetList, "resultType":"content"});
			MessageHelper.hideAndClearMessage();
		},


		updateContextProperties:function(contextId, properties){
			//Set the properties in context object..
			for(key in properties){
				wc.render.getContextById(contextId).properties[key] = properties[key];
				console.debug(" key = "+key +" and value ="+wc.render.getContextById(contextId).properties[key]);
			}
		},

		showResultsPageForContent:function(data){

			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = dojo.number.parse(pageNumber);
			pageSize = dojo.number.parse(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();
			wc.render.updateContext('searchBasedNavigation_context', {"contentBeginIndex": beginIndex,"resultType":"content","isHistory":"false"});
			MessageHelper.hideAndClearMessage();
		},

		showResultsPage:function(data){

			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = dojo.number.parse(pageNumber);
			pageSize = dojo.number.parse(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}
			
			console.debug(wc.render.getRefreshControllerById('searchBasedNavigation_controller').renderContext.properties);
			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();
			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": beginIndex,"resultType":"products","isHistory":"false"});
			MessageHelper.hideAndClearMessage();
		},

		toggleView:function(data){
			var pageView = data["pageView"];
			setCurrentId(data["linkId"]);
			if(!submitRequest()){
				return;
			}
			cursor_wait();  
			console.debug("pageView = "+pageView+" controller = +searchBasedNavigation_controller");
			wc.render.updateContext('searchBasedNavigation_context', {"pageView": pageView,"isHistory":"false"});
			MessageHelper.hideAndClearMessage();
		},
		
		toggleExpand:function(id) {
			var expand_icon = $("expand_icon_" + id);
			var section_list = $("section_list_" + id);
			if(expand_icon.className == "expand_icon_open") {
				expand_icon.className = "expand_icon_close";
				section_list.style.display = "none";
			}
			else {
				expand_icon.className = "expand_icon_open";
				section_list.style.display = "block";
			}
		},

		sortResults:function(orderBy){
			if(!submitRequest()){
				return;
			}
			cursor_wait();  
			console.debug("orderBy = "+orderBy+" controller = +searchBasedNavigation_controller");
			//Reset beginIndex = 1
			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0","orderBy":orderBy,"resultType":"products","isHistory":"false"});
			MessageHelper.hideAndClearMessage();
		},

		sortResults_content:function(orderBy){
			if(!submitRequest()){
				return;
			}
			cursor_wait();  
			console.debug("orderBy = "+orderBy+" controller = +searchBasedNavigation_controller");
			//Reset beginIndex = 1
			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0","orderByContent":orderBy,"resultType":"content","isHistory":"false"});
			MessageHelper.hideAndClearMessage();
		},

		swatchImageClicked:function(id) {
			// This is a workaround for IE's bug for non-clickable label images.
			var e = $(id);
			if(!e.checked) {
				e.click();
			}
		},

		//Same HistoryTracker object is used for both products pagination and articles+videos pagination..
		HistoryTracker:function(currentContextProperties){
			// Do not change the URL in the browser address bar.. If user bookmarks or clicks on refresh button, we will show the page with beginIndex set to 0..Will not
			// show the actual page which was bookmarked.
			this.changeUrl = false;
			// Capture the current state of the facet list in the left navigation display
			this.leftNavSnapshot = $("widget_left_nav").innerHTML;
			this.contextProperties = SearchBasedNavigationDisplayJS.clone(currentContextProperties);
			this.contextProperties['isHistory'] = 'true';
			this.contextProperties["resultType"] = "both";
			this.back = SearchBasedNavigationDisplayJS.handleBrowserBackForward; //register function to handle back button of browser
			this.forward = SearchBasedNavigationDisplayJS.handleBrowserBackForward; //register function to handle forward button of browser
			console.debug("Add to history...."+this.contextProperties['orderBy']+" " +this.contextProperties['productBeginIndex']+" "+this.contextProperties['contentBeginIndex']+ " " +this.contextProperties['resultType']+ " " +this.contextProperties['facet']);
			console.debug(this.contextProperties);
		},
		
		handleBrowserBackForward:function(){
			cursor_wait();  
			console.debug("From history...."+this.contextProperties['orderBy']+" " +this.contextProperties['productBeginIndex']+" "+this.contextProperties['contentBeginIndex']+ " " +this.contextProperties['resultType']+ " " +this.contextProperties['facet']);
			wc.render.updateContext('searchBasedNavigation_context', this.contextProperties);
			// Restore the state of the facet list in the left navigation display
			$("widget_left_nav").innerHTML = this.leftNavSnapshot;
		},

		clone:function(masterObj) {
			if (null == masterObj || "object" != typeof masterObj) return masterObj;
			var clone = masterObj.constructor();
			for (var attr in masterObj) {
				if (masterObj.hasOwnProperty(attr)) clone[attr] = masterObj[attr];
			}
			return clone;
		}
	};
}
