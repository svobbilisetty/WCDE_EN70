<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<div id="widget_bundle_summary" class="widget_sidebar_container">

	<div class="top">
		<div class="left_border"></div>
		<div class="middle"></div>
		<div class="right_border"></div>
	</div>
	
	<div class="left_border">
		<div class="right_border">
			<div class="content">
				
				<div class="item">
					<c:choose>
						<c:when test="${requestScope.bundleKitAvailable eq 'true'}">
							<a id="addToCartBtn" href="javascript:setCurrentId('addToCartBtn');shoppingActionsJS.AddBundle2ShopCartAjax();" class="button_add_to_cart" wairole="button" role="button" 
								title="<fmt:message key="PD_ADD_TO_CART" />">
								<div class="left_border"></div>
								<div id="productPageAdd2Cart" class="button_text">
									<fmt:message key="PD_ADD_TO_CART" />
								</div>
								<div class="right_border"></div>
							</a>
						</c:when>
						<c:otherwise>
							<div class="disabled">
								<div class="button_primary">
									<div class="left_border"></div>
									<div class="button_text" style="width: 116px;"><fmt:message key="PD_UNAVAILABLE"/></div>
									<div class="right_border"></div>
								</div>																	
							</div>
						</c:otherwise>
					</c:choose>
						
					<div class="clear_float"></div>
					<div class="item_spacer_7px"></div>
					
					<%out.flush();%>
						<c:import url = "${env_jspStoreDir}Widgets/ShoppingList/ShoppingList.jsp" />
					<%out.flush();%>
				</div>
				<div class="clear_float"></div>
				<div class="divider" style="visibility:hidden"></div>

			</div>
		</div>
	</div>
	<div class="clear_float"></div>
	
	<div class="bottom">
		<div class="left_border"></div>
		<div class="middle"></div>
		<div class="right_border"></div>
	</div>
</div>
										