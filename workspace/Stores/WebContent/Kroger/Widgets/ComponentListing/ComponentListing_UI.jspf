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
<div class="widget_bundle_package_list">
	<div class="widget_product_listing">
		<div class="top">
			<div class="left_border"></div>
			<div class="middle_tile"></div>
			<div class="right_border"></div>
		</div>
		<div class="middle">
			<div class="left_border">
				<div class="right_border">
					<div class="content">
						<div class="product_listing_container">
							<div class="list_mode ${param.type}_mode">
								<div class="row row_border first_row">
									<c:forEach var="componentDetails" items="${components}">
									<%out.flush();%>
										<c:import url="${env_jspStoreDir}Widgets/CatalogEntry/CatalogEntryDisplay.jsp" >
											<c:param name="productId" value="${componentDetails['uniqueID']}"/>
											<c:param name="pageView" value="miniList"/>
											<c:param name="quantity" value="${componentDetails['quantity']}"/>
										</c:import>
									<%out.flush();%>
									</c:forEach>
								</div>
							</div>
						</div>
					</div>
				</div>				
			</div>
		
		</div>
		<div class="bottom">
			<div class="left_border"></div>
			<div class="middle_tile"></div>
			<div class="right_border"></div>
		</div>
	</div>
</div>
