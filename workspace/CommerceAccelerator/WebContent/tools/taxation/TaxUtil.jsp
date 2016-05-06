<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

var remCalScale = new Vector();

function compareValues(a, b)
  {
    if ( a > b ) return 1;
    else if ( a < b ) return -1;
    else return 0;
  }

  function compareMixedCase(x, y)
  {
    if (x.toLowerCase() == y.toLowerCase()) return true;
    else return false;
  }
  
  function getSequence()
  {
     var sequence = parent.get("sequence");
     
     if (sequence == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calcode = taxes.calcode;
     
        if (size(calcode) == 0) {
           sequence = 0;
           parent.put("sequence", sequence);
           return sequence;
        } 
        else {
       		var sequence = 0;
       		for (var x=0; x < size(calcode); x++)     {
       			var thiscalcode = elementAt(x,calcode);
       			thiscalcode.sequence = x;
			sequence = x;
       		}
       		sequence ++;
       		parent.put("sequence", sequence);
           	return sequence;
        }
     } 
     else {
        sequence ++;
        parent.put("sequence", sequence);
        return sequence;
     }  
  
  }
  
  function getJurstuid()
  {
     var jurstuid = parent.get("jurstuid");
     
     if (jurstuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var jurst = taxes.jurst;
     
        if (size(jurst) == 0) {
           jurstuid = 100;
           parent.put("jurstuid", jurstuid);
           return jurstuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(jurst); i++) {
              var thisjurst = elementAt(i,jurst);
              if (thisjurst.jurisdictionId.substring(0,10) == "@jurst_id_") idArray[idArray.length] = parseFloat(thisjurst.jurisdictionId.substring(10));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              jurstuid = idArray[idArray.length -1] + 1;
           } else jurstuid = 100;
           
           parent.put("jurstuid", jurstuid);
           return jurstuid;
        }
     } else {
        jurstuid++;
        parent.put("jurstuid", jurstuid);
        return jurstuid;
     }
     
  }



  function getJurstgroupuid()
  {
     var jurstgroupuid = parent.get("jurstgroupuid");
     
     if (jurstgroupuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var jurstgroup = taxes.jurstgroup;
        
        if (size(jurstgroup) == 0) {
           jurstgroupuid = 100;
           parent.put("jurstgroupuid", jurstgroupuid);
           return jurstgroupuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(jurstgroup); i++) {
              var thisjurstgroup = elementAt(i,jurstgroup);
              if (thisjurstgroup.jurisdictionGroupId.substring(0,15) == "@jurstgroup_id_") idArray[idArray.length] = parseFloat(thisjurstgroup.jurisdictionGroupId.substring(15));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              jurstgroupuid = idArray[idArray.length -1] + 1;
           }else jurstgroupuid = 100;   
           parent.put("jurstgroupuid", jurstgroupuid);
           return jurstgroupuid;
        }
     } else {
        jurstgroupuid++;
        parent.put("jurstgroupuid", jurstgroupuid);
        return jurstgroupuid;
     }
     
  }


  function getCalcodeuid()
  {
     var calcodeuid = parent.get("calcodeuid");
     
     if (calcodeuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calcode = taxes.calcode;
     
//        if (size(calcode) == 0) {
//           calcodeuid = 1;
//           parent.put("calcodeuid", calcodeuid); 
//           return calcodeuid;
//        } else {
//           var idArray = new Array();
//           for (var i=0; i < size(calcode); i++) {
//              var thiscalcode = elementAt(i,calcode);
//              if (thiscalcode.calculationCodeId.substring(0,12) == "@calcode_id_") idArray[idArray.length] = parseFloat(thiscalcode.calculationCodeId.substring(12));
//           }
//           if (idArray.length != 0) {
//              idArray.sort(compareValues);
//              calcodeuid = idArray[idArray.length -1] + 1;
//           }else calcodeuid = 100;   
//           parent.put("calcodeuid", calcodeuid);
//           return calcodeuid;
//        }
	var allowed = '0123456789';
	var calcodeuid = 100;
	for(var i=1; i < size(calcode); i++) {
	 var thiscalcode = elementAt(i,calcode);
	 if(isValid(elementAt(i,calcode).calculationCodeId, allowed)) {
		 if(elementAt(i,calcode).calculationCodeId > calcodeuid) calcodeuid = elementAt(i,calcode).calculationCodeId;
	 }	 
	}
	calcodeuid++;
	parent.put("calcodeuid", calcodeuid);
	return calcodeuid;
     } else {
        calcodeuid++;
        parent.put("calcodeuid", calcodeuid);
        return calcodeuid;
     }
  }


  function isValid(string,allowed) {
    for (var i=0; i< string.length; i++) {
       if (allowed.indexOf(string.charAt(i)) == -1)
          return false;
    }
    return true;
  }

  function getCalrangeuid()
  {
     var calrangeuid = parent.get("calrangeuid");
     
     if (calrangeuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calrange = taxes.calrange;
     
        if (size(calrange) == 0) {
           calrangeuid = 1;
           parent.put("calrangeuid", calrangeuid);
           return calrangeuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calrange); i++) {
              var thiscalrange = elementAt(i,calrange);
              if (thiscalrange.calculationRangeId.substring(0,13) == "@calrange_id_") idArray[idArray.length] = parseFloat(thiscalrange.calculationRangeId.substring(13));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calrangeuid = idArray[idArray.length -1] + 1;
           }else calrangeuid = 100;   
           parent.put("calrangeuid", calrangeuid);
           return calrangeuid;
        }
     } else {
        calrangeuid++;
        parent.put("calrangeuid", calrangeuid);
        return calrangeuid;
     }
     
  }


  function getCalrlookupuid()
  {
     var calrlookupuid = parent.get("calrlookupuid");
     
     if (calrlookupuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calrlookup = taxes.calrlookup;
     
        if (size(calrlookup) == 0) {
           calrlookupuid = 1000;
           parent.put("calrlookupuid", calrlookupuid);
           return calrlookupuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calrlookup); i++) {
              var thiscalrlookup = elementAt(i,calrlookup);
              if (thiscalrlookup.calculationRangeLookupResultId.substring(0,15) == "@calrlookup_id_") idArray[idArray.length] = parseFloat(thiscalrlookup.calculationRangeLookupResultId.substring(15));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calrlookupuid = idArray[idArray.length -1] + 1;
           }else calrlookupuid = 1000;   
           parent.put("calrlookupuid", calrlookupuid);
           return calrlookupuid;
        }
     } else {
        calrlookupuid++;
        parent.put("calrlookupuid", calrlookupuid);
        return calrlookupuid;
     }
     
  }
  
  
  function getCalruleuid()
  {
     var calruleuid = parent.get("calruleuid");
     
     if (calruleuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calrule = taxes.calrule;
     
        if (size(calrule) == 0) {
           calruleuid = 1000;
           parent.put("calruleuid", calruleuid);
           return calruleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calrule); i++) {
              var thiscalrule = elementAt(i,calrule);
              if (thiscalrule.calculationRuleId.substring(0,12) == "@calrule_id_") idArray[idArray.length] = parseFloat(thiscalrule.calculationRuleId.substring(12));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calruleuid = idArray[idArray.length -1] + 1;
           }else calruleuid = 1000;   
           parent.put("calruleuid", calruleuid);
           return calruleuid;
        }
     } else {
        calruleuid++;
        parent.put("calruleuid", calruleuid);
        return calruleuid;
     }
     
  }
  
  
  function getCalscaleuid()
  {
     var calscaleuid = parent.get("calscaleuid");
     
     if (calscaleuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var calscale = taxes.calscale;
     
        if (size(calscale) == 0) {
           calscaleuid = 1000;
           parent.put("calscaleuid", calscaleuid);
           return calscaleuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(calscale); i++) {
              var thiscalscale = elementAt(i,calscale);
              if (thiscalscale.calculationScaleId.substring(0,13) == "@calscale_id_") idArray[idArray.length] = parseFloat(thiscalscale.calculationScaleId.substring(13));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              calscaleuid = idArray[idArray.length -1] + 1;
           }else calscaleuid = 1000;   
           parent.put("calscaleuid", calscaleuid);
           return calscaleuid;
        }
     } else {
        calscaleuid++;
        parent.put("calscaleuid", calscaleuid);
        return calscaleuid;
     }
     
  }
  
  
  function getTaxcgryuid()
  {
     var taxcgryuid = parent.get("taxcgryuid");
     
     if (taxcgryuid == null) {
     
        var taxes = parent.get("TaxInfoBean1");
        var taxcgry = taxes.taxcgry;
     
        if (size(taxcgry) == 0) {
           taxcgryuid = 100;
           parent.put("taxcgryuid", taxcgryuid);
           return taxcgryuid;
        } else {
           var idArray = new Array();
           for (var i=0; i < size(taxcgry); i++) {
              var thistaxcgry = elementAt(i,taxcgry);
              if (thistaxcgry.categoryId.substring(0,12) == "@taxcgry_id_") idArray[idArray.length] = parseFloat(thistaxcgry.categoryId.substring(12));
           }
           if (idArray.length != 0) {
              idArray.sort(compareValues);
              taxcgryuid = idArray[idArray.length -1] + 1;
           } else taxcgryuid = 100;   
           parent.put("taxcgryuid", taxcgryuid);
           return taxcgryuid;
        }
     } else {
        taxcgryuid++;
        parent.put("taxcgryuid", taxcgryuid);
        return taxcgryuid;
     }
     
  }

  <%--
    -  Returns a new calrule object with all of the dependant table rows
    - created and populated with the default values;
    --%>
  function createNewCalrule(taxtype, tempcalrlookup)
  {
      var taxes = parent.get("TaxInfoBean1");
      var storeid = parent.get("storeid");
      var calrlookup = taxes.calrlookup;
      var calrange = taxes.calrange;
      var calscale = taxes.calscale;
      var crulescale = taxes.crulescale;
      var calcode = taxes.calcode;
      var calcode_id;
      
//      for (var x=0; x < size(calcode); x++) {
//         var thiscalcode = elementAt(x,calcode);
//         if(thiscalcode.code == "Default") {
//            calcode_id = thiscalcode.calculationCodeId;
//            break;
//         }
//      }

      <%-- create a new calrlookup for this calrule --%>
      var newCalrlookup = new parent.calrlookup();
      newCalrlookup.calculationRangeLookupResultId = "@calrlookup_id_" + getCalrlookupuid();
	  newCalrlookup.calculationRangeLookupResultId = newCalrlookup.calculationRangeLookupResultId;
      newCalrlookup.calculationRangeId = "@calrange_id_" + getCalrangeuid();
	  newCalrlookup.calculationRangeId = newCalrlookup.calculationRangeId;
      newCalrlookup.value = tempcalrlookup;
	  newCalrlookup.value = tempcalrlookup;
            
      <%-- create a new calrange for this calrule --%>
      if (taxtype == "sales"){
       	var newCalrange = new parent.calrange();
      }
      else if (taxtype == "shipping"){
       	var newCalrange = new parent.shippingcalrange();
      }
      newCalrange.calculationRangeId = newCalrlookup.calculationRangeId;
	  newCalrange.calculationRangeId = newCalrlookup.calculationRangeId;
      var scaleid = getCalscaleuid();
      newCalrange.calculationScaleId = "@calscale_id_" + scaleid;
	  newCalrange.calculationScaleId = newCalrange.calculationScaleId;

      <%-- create a new calscale for this calrule --%>
      if (taxtype == "sales"){
       	var newCalscale = new parent.calscale();
      }
      else if (taxtype == "shipping"){
       	newCalscale = new parent.shippingcalscale();
      }
      newCalscale.calculationScaleId = newCalrange.calculationScaleId;
      newCalscale.calculationScaleId = newCalrange.calculationScaleId;
      newCalscale.code = scaleid;
      newCalscale.storeEntityId = storeid;
      newCalscale.storeEntityId = storeid;

      <%-- create a new calrule --%>
      if (taxtype == "sales"){
       	var newCalrule = new parent.calrule();
      }
      else if (taxtype == "shipping"){
       	var newCalrule = new parent.shippingcalrule();
      }
      var cid = getCalruleuid();
      newCalrule.calculationRuleId = "@calrule_id_" + cid;
      newCalrule.calculationRuleId = newCalrule.calculationRuleId;
      newCalrule.calculationCodeId = calcode_id;
	  newCalrule.calculationCodeId = newCalrule.calculationCodeId;
      newCalrule.identifier = cid;
	  newCalrule.identifier = cid;
      
      <%-- create a new crulescale --%>
      var newCrulescale = new parent.crulescale();
      newCrulescale.calculationRuleId = newCalrule.calculationRuleId;
      newCrulescale.calculationRuleId = newCalrule.calculationRuleId;
      newCrulescale.calculationScaleId = newCalscale.calculationScaleId;
	  newCrulescale.calculationScaleId = newCalscale.calculationScaleId;

      <%-- save the new entries --%>
      addElement(newCalrlookup,calrlookup);
      addElement(newCalrange,calrange);
      addElement(newCalscale,calscale);
      addElement(newCrulescale,crulescale);

      return newCalrule;
  }



  function getJurstgroupIdFromJurstId(jurst_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var jurstgprel = taxes.jurstgprel;
     var jurstgroup_id = -1;

     for (var i=0; i < size(jurstgprel); i++) {
        var temp = elementAt(i,jurstgprel);
        if (temp.jurisdictionId == jurst_id && temp.subclass=="2") {
           jurstgroup_id = temp.jurisdictionGroupId;
           break;
        }
     }

     if (jurstgroup_id == -1) {
        alertDialog("Rates1.jsp::getJurstgroupIdFromJurstId() - jurst_id= " + jurst_id + " does not belong to a group.");
        return;
     }      
     
     return jurstgroup_id;
  }


  function removeCalruleAssociations(calrule_id)
  {
    var taxes = parent.get("TaxInfoBean1");
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var crulescale = taxes.crulescale;
    var calscale = taxes.calscale;
    var calscaleds = taxes.calscaleds;
    var calrange = taxes.calrange;
    var calrlookup = taxes.calrlookup;
    
    
    <%-- remove this calrule from taxjcrule --%>
    for (var i=size(taxjcrule)-1; i >= 0 ; i--) {
       var temp = elementAt(i,taxjcrule);
       if (temp.calculationRuleId == calrule_id) {
          removeElementAt(i,taxjcrule);
       }
    }


    <%-- remove this calrule from crulescale (this cascades) --%>
    for (var i=size(crulescale)-1; i >= 0; i--) {
       var thisCrulescale = elementAt(i,crulescale);

       if (thisCrulescale.calculationRuleId == calrule_id) {

           var calscale_id = thisCrulescale.calculationScaleId;

           <%-- remove this calscale_id from the calscale table --%>
           for (var j=size(calscale)-1; j >=0 ; j--) {
              var tmp = elementAt(j,calscale);
              
               if (tmp.calculationScaleId == calscale_id) {
				     if (calscaleds != null){
					     for (var n=size(calscaleds) -1; n >= 0; n--) {
						     var thiscalscaleds = elementAt(n,calscaleds);
							  if (thiscalscaleds.calscale_id == calscale_id) {
								removeElementAt(n,calscaleds);
							  }	
						  }
					  } 
                 removeElementAt(j,calscale);
		     <%-- add the primary ids to the vector so that it can be deleted from the db --%>
                 if (tmp.calculationScaleId.substring(0,1) != "@"){
                     addElement(tmp.calculationScaleId,remCalScale);
                 }
              }
           }

           <%-- remove this calscale_id from the calrange table (this cascades to calrlookup) --%>
           for (var j=size(calrange) - 1; j >= 0; j--) {
              var tmp = elementAt(j,calrange);

              if (tmp.calculationScaleId == calscale_id) {
                 var calrange_id = tmp.calculationRangeId;

                 <%-- remove this calrange_id from the calrlookup table --%>
                 for (var k=size(calrlookup)-1; k >= 0; k--) {
                    var tmp2 = elementAt(k,calrlookup);
      
                    if (tmp2.calculationRangeId == calrange_id) {
                       removeElementAt(k,calrlookup);
                    }
                 }
                 <%--remove the records which is associated with the calrange_id from updateCalrlookup --%>
                 removeCalrangeRefUpdates(calrange_id);
                 removeElementAt(j,calrange);
                
              } 
           }

           removeElementAt(i,crulescale);
       }
    }
    parent.put("remCalScale",remCalScale);
  }
  
  <%--
  	 - This method remove the calrlookup records from updateCalrlookup,which is associated with the calrange_id.
  --%>
  function removeCalrangeRefUpdates(calrange_id){
  
  	 var updateCalrlookup = parent.get("updateCalrlookup");
  	 if (updateCalrlookup != null){
		  for (var i=0; i< size(updateCalrlookup) ; i++){
		  	var temp = elementAt(i,updateCalrlookup);
		 		if (temp.calculationRangeId == calrange_id){
					removeElementAt(i,updateCalrlookup);		
		 		}
		  }
	 }
	 
  }
  
  <%--
  	 - This method remove the records from updateTaxJcRule and updateCalrule ,which is associated with the calrule_id.
  --%>
  
  function removeCalruleRefUpdates(calrule_id){
  
	
	 var updateTaxJcRule = parent.get("updateTaxJcRule");
	 var updateCalrule = parent.get("updateCalrule");
	 
	 
	 if (updateTaxJcRule != null){
	 	for (var i=0; i< size(updateTaxJcRule); i++){
	 		var temp = elementAt(i,updateTaxJcRule);
	 		if (temp.calculationRuleId == calrule_id){
	 			removeElementAt(i,updateTaxJcRule);
	 		}
	 	}
	 }
	 
	 if (updateCalrule != null){
	 	for (var i = 0; i< size(updateCalrule); i++){
	 		var temp = elementAt(i,updateCalrule);
	 		if (temp.calculationRuleId == calrule_id){
	 			removeElementAt(i,updateCalrule);
	 		}
	 	}
	 }
  }
  

  <%--
    - Return the tax rate for the given (jurisdiction,category) pair.
    --%>
  function getCalrlookup(jurst_id, taxcgry_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrulebean = taxes.calrule;
     var jurstgroup_id = getJurstgroupIdFromJurstId(jurst_id);
     var ffmcntr = parent.get("ffmcntr");
     
     <%-- now find the calrule_id that has this jurstgroup_id and this taxcgry_id--%>
     var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
     var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
     var calrule_id = -1;

     for (var i=0; i < size(taxjcrule); i++) {
        var temp = elementAt(i,taxjcrule);
        if (temp.jurisdictionGroupId == jurstgroup_id && temp.fulfillmentCenterId == ffmcntr) {
         <%-- check if this taxjcrule.calrule_id has the right taxcgry_id in the calrule table --%>
	     var calrule = getCalrule(temp.calculationRuleId);
	     
	     if(calrule == null) {
	     	continue;
	     }
	     
         if (calrule.taxCategoryId == taxcgry_id) {
            calrule_id = temp.calculationRuleId;
            break;
         }
        }
     }

     if (calrule_id == -1) {
//        alertDialog("no calrule_id was found for jurstgroup_id = " + jurstgroup_id + " and taxcgry_id=" + taxcgry_id + ".");
        return;
     }


     <%-- find the calscale associated with this calrule --%>
     var calscale_id = getCalscaleIdFromCalruleId(calrule_id);

     <%-- find the calrange_id for this calscale_id. --%>
     var calrange_id = getCalrangeIdFromCalscaleId(calscale_id);

     <%-- find the value of this calrange_id. --%>
     var calrlookup = taxes.calrlookup;
	
     for (var i=0; i < size(calrlookup); i++) {
        var temp = elementAt(i,calrlookup);
        if (temp.calculationRangeId == calrange_id) {
           return temp;
        }
     }
     
     //alertDialog("Rates.jsp::getCalrlookup() - no value found for jurst_id=" + jurst_id + " and taxcgry_id=" + taxcgry_id + ".");
  }
  
  <%--
    --%>
  function getCalrule(calrule_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrule = taxes.calrule;

     for (var i=0; i < size(calrule); i++) {
        var temp = elementAt(i,calrule);
        if (temp.calculationRuleId == calrule_id) {
           return temp;
        }
     }

     //alertDialog("Rates.jsp::getCalrule() - calrule_id=" + calrule_id + " not found in calrule.");
  }
  
  <%--
    -
    --%>
  function getCalscaleIdFromCalruleId(calrule_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var crulescale = taxes.crulescale;

     for (var i=0; i < size(crulescale); i++) {
        var temp = elementAt(i,crulescale);
        if (temp.calculationRuleId == calrule_id) {
           return temp.calculationScaleId;
        }
     }

     //alertDialog("Rates.jsp::getCalscaleIdFromCalruleId() - calrule_id=" + calrule_id + " not found in crulescale.");
  }


  <%--
    - Note that we do not support tax ranges. Return the first calrange_id whose
    - calscale_id matches.
    --%>
  function getCalrangeIdFromCalscaleId(calscale_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var calrange = taxes.calrange;

     for (var i=0; i < size(calrange); i++) {
        var temp = elementAt(i,calrange);
        if (temp.calculationScaleId == calscale_id) {
           return temp.calculationRangeId;
        }
     }

     //alertDialog("Rates.jsp::getCalrangeIdFromCalscaleId() - calscale_id=" + calscale_id + " not found in calrange.");
  }
  
  function getJurstgroupIdFromJurstId(jurst_id)
  {
     var taxes = parent.get("TaxInfoBean1");
     var jurstgprel = taxes.jurstgprel;
     var jurstgroup_id = -1;

     for (var i=0; i < size(jurstgprel); i++) {
        var temp = elementAt(i,jurstgprel);
        if (temp.jurisdictionId == jurst_id && temp.subclass=="2") {
           jurstgroup_id = temp.jurisdictionGroupId;
           break;
        }
     }

     if (jurstgroup_id == -1) {
        //alertDialog("Rates.jsp::getJurstgroupIdFromJurstId() - jurst_id= " + jurst_id + " does not belong to a group.");
        return;
     }
     
     return jurstgroup_id;
  }

  function getTaxjcruleuid()
  {
     var taxjcruleuid = parent.get("taxjcruleuid");
     
     if (taxjcruleuid == null) {
     
//        var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
//     	var taxjcrule = taxFulfillmentInfoBean.taxjcrule;

//        if (size(taxjcrule) == 0) {
           taxjcruleuid = 1000;
           parent.put("taxjcruleuid", taxjcruleuid);
           return taxjcruleuid;
//        } else {
//           var idArray = new Array();
//           for (var i=0; i < size(taxjcrule); i++) {
//              var thistaxjcrule = elementAt(i,taxjcrule);
//              if (thistaxjcrule.taxJCRuleId.substring(0,14) == "@taxjcrule_id_") idArray[idArray.length] = parseFloat(thistaxjcrule.taxJCRuleId.substring(14));
//           }
//           if (idArray.length != 0) {
//              idArray.sort(compareValues);
//              taxjcruleuid = idArray[idArray.length -1] + 1;
//           }else taxjcruleuid = 1000;   
//           parent.put("taxjcruleuid", taxjcruleuid);
//           return taxjcruleuid;
//        }
     } else {
        taxjcruleuid++;
        parent.put("taxjcruleuid", taxjcruleuid);
        return taxjcruleuid;
     }
     
  }
  
  function getPrecedence(ajurstgroup_id)
  {
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    var thisprecedence;
    
    for (j=0; j < size(taxjcrule); j++) {
       var thistaxjcrule = elementAt(j,taxjcrule);
       if (thistaxjcrule.jurisdictionGroupId == ajurstgroup_id) {
          thisprecedence=thistaxjcrule.precedence;
          return(thisprecedence);
       }
    }
  }
             
  function setNameValuePair()
  {    
    var taxFulfillmentInfoBean = parent.get("TaxFulfillmentInfoBean1");
    var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
    
    for(var i=0; i< size(taxjcrule); i++) {
       var thistaxjcrule = elementAt(i,taxjcrule);
       if (thistaxjcrule.jurisdictionGroupId) thistaxjcrule.jurisdictionGroupIdInEJBType = thistaxjcrule.jurisdictionGroupId;
       if (thistaxjcrule.jurisdictionGroupIdInEJBType) thistaxjcrule.jurisdictionGroupId = String(thistaxjcrule.jurisdictionGroupIdInEJBType);
       
       if (thistaxjcrule.calculationRuleIdInEJBType) thistaxjcrule.calculationRuleId = String(thistaxjcrule.calculationRuleIdInEJBType);
       if (thistaxjcrule.calculationRuleId) thistaxjcrule.calculationRuleIdInEJBType = thistaxjcrule.calculationRuleId;
       
       if (thistaxjcrule.fulfillmentCenterIdInEJBType) thistaxjcrule.fulfillmentCenterId = String(thistaxjcrule.fulfillmentCenterIdInEJBType);
       if (thistaxjcrule.fulfillmentCenterId) thistaxjcrule.fulfillmentCenterIdInEJBType = thistaxjcrule.fulfillmentCenterId;
       
       if (thistaxjcrule.precedenceInEJBType) thistaxjcrule.precedence = String(thistaxjcrule.precedenceInEJBType);
       if (thistaxjcrule.precedence) thistaxjcrule.precedenceInEJBType = thistaxjcrule.precedence;
    }
    
    var taxes = parent.get("TaxInfoBean1");
    var jurst = taxes.jurst;
    
    for(var i=0; i < size(jurst); i++)
    {
        var thisjurst = elementAt(i,jurst);
        if (thisjurst.jurisdictionIdInEJBType) thisjurst.jurisdictionId = String(thisjurst.jurisdictionIdInEJBType);
        if (thisjurst.jurisdictionId) thisjurst.jurisdictionIdInEJBType = thisjurst.jurisdictionId;
        
        if (thisjurst.markForDeleteInEJBType) thisjurst.markForDelete = String(thisjurst.markForDeleteInEJBType);
        if (thisjurst.markForDelete) thisjurst.markForDeleteInEJBType = thisjurst.markForDelete;
        
        if (thisjurst.subclassInEJBType) thisjurst.subclass = String(thisjurst.subclassInEJBType);
        if (thisjurst.subclass) thisjurst.subclassInEJBType = thisjurst.subclass;
        
        if (thisjurst.storeEntityIdInEJBType) thisjurst.storeEntityId = String(thisjurst.storeEntityIdInEJBType);
        if (thisjurst.storeEntityId) thisjurst.storeEntityIdInEJBType = thisjurst.storeEntityId;
    }
    
    
    var jurstgroup = taxes.jurstgroup;
    for(var i=0; i < size(jurstgroup); i++)
    {
        var thisjurstgroup = elementAt(i,jurstgroup);
        if (thisjurstgroup.storeentIdInEJBType) thisjurstgroup.storeentId = String(thisjurstgroup.storeentIdInEJBType);
        if (thisjurstgroup.storeentId) thisjurstgroup.storeentIdInEJBType = thisjurstgroup.storeentId;
        
        if (thisjurstgroup.markForDeleteInEJBType) thisjurstgroup.markForDelete = String(thisjurstgroup.markForDeleteInEJBType);
        if (thisjurstgroup.markForDelete) thisjurstgroup.markForDeleteInEJBType = thisjurstgroup.markForDelete;
        
        if (thisjurstgroup.subclassInEJBType) thisjurstgroup.subclass = String(thisjurstgroup.subclassInEJBType);
        if (thisjurstgroup.subclass) thisjurstgroup.subclassInEJBType = thisjurstgroup.subclass;
        
        if (thisjurstgroup.jurisdictionGroupIdInEJBType) thisjurstgroup.jurisdictionGroupId = String(thisjurstgroup.jurisdictionGroupIdInEJBType);
        if (thisjurstgroup.jurisdictionGroupId) thisjurstgroup.jurisdictionGroupIdInEJBType = thisjurstgroup.jurisdictionGroupId;
        
    }    
    
    var jurstgprel = taxes.jurstgprel;
    for(var i=0; i < size(jurstgprel); i++)
    {
        var thisjurstgprel = elementAt(i,jurstgprel);
        if (thisjurstgprel.jurisdictionIdInEJBType) thisjurstgprel.jurisdictionId = String(thisjurstgprel.jurisdictionIdInEJBType);
        if (thisjurstgprel.jurisdictionId) thisjurstgprel.jurisdictionIdInEJBType = thisjurstgprel.jurisdictionId;
        
        if (thisjurstgprel.subclassInEJBType) thisjurstgprel.subclass = String(thisjurstgprel.subclassInEJBType);
        if (thisjurstgprel.subclassIn) thisjurstgprel.subclassInEJBType = thisjurstgprel.subclass;
        
        if (thisjurstgprel.jurisdictionGroupIdInEJBType) thisjurstgprel.jurisdictionGroupId = String(thisjurstgprel.jurisdictionGroupIdInEJBType);
        if (thisjurstgprel.jurisdictionGroupId) thisjurstgprel.jurisdictionGroupIdInEJBType = thisjurstgprel.jurisdictionGroupId;
    }   
    
    var taxcgry = taxes.taxcgry;    
    for(var i=0; i < size(taxcgry); i++)
    {
        var thistaxcgry = elementAt(i,taxcgry);
        if (thistaxcgry.field2InEJBType) thistaxcgry.field2 = String(thistaxcgry.field2InEJBType);
        if (thistaxcgry.field2) thistaxcgry.field2InEJBType = thistaxcgry.field2;
        
        if (thistaxcgry.categoryIdInEJBType) thistaxcgry.categoryId = String(thistaxcgry.categoryIdInEJBType);
        if (thistaxcgry.categoryId) thistaxcgry.categoryIdInEJBType = thistaxcgry.categoryId;
        
        if (thistaxcgry.markForDeleteInEJBType) thistaxcgry.markForDelete = String(thistaxcgry.markForDeleteInEJBType);
        if (thistaxcgry.markForDelete) thistaxcgry.markForDeleteInEJBType = thistaxcgry.markForDelete;
        
        if (thistaxcgry.displayUsageInEJBType) thistaxcgry.displayUsage = String(thistaxcgry.displayUsageInEJBType);
        if (thistaxcgry.displayUsage) thistaxcgry.displayUsageInEJBType = thistaxcgry.displayUsage;
        
        if (thistaxcgry.storeEntityIdInEJBType) thistaxcgry.storeEntityId = String(thistaxcgry.storeEntityIdInEJBType);
        if (thistaxcgry.storeEntityId) thistaxcgry.storeEntityIdInEJBType = thistaxcgry.storeEntity;
        
        if (thistaxcgry.field1InEJBType) thistaxcgry.field2 = String(thistaxcgry.field1InEJBType);
        if (thistaxcgry.field1) thistaxcgry.field1InEJBType = thistaxcgry.field1;
        
        if (thistaxcgry.typeIdInEJBType) thistaxcgry.typeId = String(thistaxcgry.typeIdInEJBType);
        if (thistaxcgry.typeId) thistaxcgry.typeIdInEJBType = thistaxcgry.typeId;
        
        if (thistaxcgry.calculationSequenceInEJBType) thistaxcgry.calculationSequence = String(thistaxcgry.calculationSequenceInEJBType);
        if (thistaxcgry.calculationSequence) thistaxcgry.calculationSequenceInEJBType = thistaxcgry.calculationSequence;
        
        if (thistaxcgry.displaySequenceInEJBType) thistaxcgry.displaySequence = String(thistaxcgry.displaySequenceInEJBType);
        if (thistaxcgry.displaySequence) thistaxcgry.displaySequenceInEJBType = thistaxcgry.displaySequence;
    }
    
    var taxcgryds = taxes.taxcgryds;
    for(var i=0; i < size(taxcgryds); i++)
    {
        var thistaxcgryds = elementAt(i,taxcgryds);
        if (thistaxcgryds.taxCategoryIdInEJBType) thistaxcgryds.taxCategoryId = String(thistaxcgryds.taxCategoryIdInEJBType);
        if (thistaxcgryds.taxCategoryId) thistaxcgryds.taxCategoryIdInEJBType = thistaxcgryds.taxCategoryId;
        
        if (thistaxcgryds.languageIdInEJBType) thistaxcgryds.languageId = String(thistaxcgryds.languageIdInEJBType);
        if (thistaxcgryds.languageId) thistaxcgryds.languageIdInEJBType = thistaxcgryds.languageId;
    }
    
    var calcode = taxes.calcode;
    for(var i=0; i < size(calcode); i++)
    {
        var thiscalcode = elementAt(i,calcode);
        if (thiscalcode.precedenceInEJBType) thiscalcode.precedence = String(thiscalcode.precedenceInEJBType);
        if (thiscalcode.precedence) thiscalcode.precedenceInEJBType = thiscalcode.precedence;
        
        if (thiscalcode.calculationUsageIdInEJBType) thiscalcode.calculationUsageId = String(thiscalcode.calculationUsageIdInEJBType);
        if (thiscalcode.calculationUsageId) thiscalcode.calculationUsageIdInEJBType = thiscalcode.calculationUsageId;
        
        if (thiscalcode.sequenceInEJBType) thiscalcode.sequence = String(thiscalcode.sequenceInEJBType);
        if (thiscalcode.sequence) thiscalcode.sequenceInEJBType = thiscalcode.sequence;
        
        if (thiscalcode.publishedInEJBType) thiscalcode.published = String(thiscalcode.publishedInEJBType);
        if (thiscalcode.published) thiscalcode.publishedInEJBType = thiscalcode.published;
        
        if (thiscalcode.calculationMethodIdInEJBType) thiscalcode.calculationMethodId = String(thiscalcode.calculationMethodIdInEJBType);
        if (thiscalcode.calculationMethodId) thiscalcode.calculationMethodIdInEJBType = thiscalcode.calculationMethodId;
        
        if (thiscalcode.endDateInEJBType) thiscalcode.endDate = String(thiscalcode.endDateInEJBType);
        if (thiscalcode.endDate) thiscalcode.endDateInEJBType = thiscalcode.endDate;
        
        if (thiscalcode.combinationInEJBType) thiscalcode.combination = String(thiscalcode.combinationInEJBType);
        if (thiscalcode.combination) thiscalcode.combinationInEJBType = thiscalcode.combination;
        
        if (thiscalcode.groupByInEJBType) thiscalcode.groupBy = String(thiscalcode.groupByInEJBType);
        if (thiscalcode.groupBy) thiscalcode.groupByInEJBType = thiscalcode.groupBy;
        
        if (thiscalcode.taxCodeClassIdInEJBType) thiscalcode.taxCodeClassId = String(thiscalcode.taxCodeClassIdInEJBType);
        if (thiscalcode.taxCodeClassId) thiscalcode.taxCodeClassIdInEJBType = thiscalcode.taxCodeClassId;        
        
        if (thiscalcode.startDateInEJBType) thiscalcode.startDate = String(thiscalcode.startDateInEJBType);
        if (thiscalcode.startDate) thiscalcode.startDateInEJBType = thiscalcode.startDate;                
        
        if (thiscalcode.storeEntityIdInEJBType) thiscalcode.storeEntityId = String(thiscalcode.storeEntityIdInEJBType);
        if (thiscalcode.storeEntityId) thiscalcode.storeEntityIdInEJBType = thiscalcode.storeEntityId;                 

        if (thiscalcode.flagsInEJBType) thiscalcode.flags = String(thiscalcode.flagsInEJBType);
        if (thiscalcode.flags) thiscalcode.flagsInEJBType = thiscalcode.flags;                 
        
        if (thiscalcode.calculationCodeApplyMethodIdInEJBType) thiscalcode.calculationCodeApplyMethodId = String(thiscalcode.calculationCodeApplyMethodIdInEJBType);
        if (thiscalcode.calculationCodeApplyMethodId) thiscalcode.calculationCodeApplyMethodIdInEJBType = thiscalcode.calculationCodeApplyMethodId;                 
        
        if (thiscalcode.calculationCodeQualifyMethodIdInEJBType) thiscalcode.calculationCodeQualifyMethodId = String(thiscalcode.calculationCodeQualifyMethodIdInEJBType);
        if (thiscalcode.calculationCodeQualifyMethodId) thiscalcode.calculationCodeQualifyMethodIdInEJBType = thiscalcode.calculationCodeQualifyMethodId; 
        
        if (thiscalcode.displayLevelInEJBType) thiscalcode.displayLevel = String(thiscalcode.displayLevelInEJBType);
        if (thiscalcode.displayLevel) thiscalcode.displayLevelInEJBType = thiscalcode.displayLevel;                 
        
        if (thiscalcode.lastUpdateInEJBType) thiscalcode.lastUpdate = String(thiscalcode.lastUpdateInEJBType);
        if (thiscalcode.lastUpdate) thiscalcode.lastUpdateInEJBType = thiscalcode.lastUpdate;                 
        
        if (thiscalcode.calculationCodeIdInEJBType) thiscalcode.calculationCodeId = String(thiscalcode.calculationCodeIdInEJBType);
        if (thiscalcode.calculationCodeId) thiscalcode.calculationCodeIdInEJBType = thiscalcode.calculationCodeId; 

    }   
    
    var calrule = taxes.calrule;
    for(var i=0; i < size(calrule); i++)
    {
        var thiscalrule = elementAt(i,calrule);
        if (thiscalrule.sequenceInEJBType) thiscalrule.sequence = String(thiscalrule.sequenceInEJBType);
        if (thiscalrule.sequence) thiscalrule.sequenceInEJBType = thiscalrule.sequence;

        if (thiscalrule.taxCategoryIdInEJBType) thiscalrule.taxCategoryId = String(thiscalrule.taxCategoryIdInEJBType);
        if (thiscalrule.taxCategoryId) thiscalrule.taxCategoryIdInEJBType = thiscalrule.taxCategoryId;

        if (thiscalrule.calculationMethodIdInEJBType) thiscalrule.calculationMethodId = String(thiscalrule.calculationMethodIdInEJBType);
        if (thiscalrule.calculationMethodId) thiscalrule.calculationMethodIdInEJBType = thiscalrule.calculationMethodId;
        
        if (thiscalrule.endDateInEJBType) thiscalrule.endDate = String(thiscalrule.endDateInEJBType);
        if (thiscalrule.endDate) thiscalrule.endDateInEJBType = thiscalrule.endDate;
        
        if (thiscalrule.endDateInEJBType) thiscalrule.endDate = String(thiscalrule.endDateInEJBType);
        if (thiscalrule.endDate) thiscalrule.endDateInEJBType = thiscalrule.endDate;        
        
        if (thiscalrule.calculationRuleIdInEJBType) thiscalrule.calculationRuleId = String(thiscalrule.calculationRuleIdInEJBType);
        if (thiscalrule.calculationRuleId) thiscalrule.calculationRuleIdInEJBType = thiscalrule.calculationRuleId;        

        if (thiscalrule.combinationInEJBType) thiscalrule.combination = String(thiscalrule.combinationInEJBType);
        if (thiscalrule.combination) thiscalrule.combinationInEJBType = thiscalrule.combination;        
        
        if (thiscalrule.identifierInEJBType) thiscalrule.identifier = String(thiscalrule.identifierInEJBType);
        if (thiscalrule.identifier) thiscalrule.identifierInEJBType = thiscalrule.identifier;        
        
        if (thiscalrule.flagsInEJBType) thiscalrule.flags = String(thiscalrule.flagsInEJBType);
        if (thiscalrule.flags) thiscalrule.flagsInEJBType = thiscalrule.flags;        
        
        if (thiscalrule.calculationRuleQualifyMethodIdInEJBType) thiscalrule.calculationRuleQualifyMethodId = String(thiscalrule.calculationRuleQualifyMethodIdInEJBType);
        if (thiscalrule.calculationRuleQualifyMethodId) thiscalrule.calculationRuleQualifyMethodIdInEJBType = thiscalrule.calculationRuleQualifyMethodId;        
        
        if (thiscalrule.field1InEJBType) thiscalrule.field1 = String(thiscalrule.field1InEJBType);
        if (thiscalrule.field1) thiscalrule.field1InEJBType = thiscalrule.field1;
        
        if (thiscalrule.calculationCodeIdInEJBType) thiscalrule.calculationCodeId = String(thiscalrule.calculationCodeIdInEJBType);
        if (thiscalrule.calculationCodeId) thiscalrule.calculationCodeIdInEJBType = thiscalrule.calculationCodeId;                        
     }
     
     var calscale = taxes.calscale;
     for(var i=0; i < size(calscale); i++)
     {
        var thiscalscale = elementAt(i,calscale);
        if (thiscalscale.calculationUsageIdInEJBType) thiscalscale.calculationUsageId = String(thiscalscale.calculationUsageIdInEJBType);
        if (thiscalscale.calculationUsageId) thiscalscale.calculationUsageIdInEJBType = thiscalscale.calculationUsageId;
        
        if (thiscalscale.calculationMethodIdInEJBType) thiscalscale.calculationMethodId = String(thiscalscale.calculationMethodIdInEJBType);
        if (thiscalscale.calculationMethodId) thiscalscale.calculationMethodIdInEJBType = thiscalscale.calculationMethodId;
        
        if (thiscalscale.calculationScaleIdInEJBType) thiscalscale.calculationScaleId = String(thiscalscale.calculationScaleIdInEJBType);
        if (thiscalscale.calculationScaleId) thiscalscale.calculationScaleIdInEJBType = thiscalscale.calculationScaleId;
        
        if (thiscalscale.storeEntityIdInEJBType) thiscalscale.storeEntityId = String(thiscalscale.storeEntityIdInEJBType);
        if (thiscalscale.storeEntityId) thiscalscale.storeEntityIdInEJBType = thiscalscale.storeEntityId;
     }     
     
     var crulescale = taxes.crulescale;     
     for(var i=0; i < size(crulescale); i++)
     {
        var thiscrulescale = elementAt(i,crulescale);
        if (thiscrulescale.calculationScaleIdInEJBType) thiscrulescale.calculationScaleId = String(thiscrulescale.calculationScaleIdInEJBType);
        if (thiscrulescale.calculationScaleId) thiscrulescale.calculationScaleIdInEJBType = thiscrulescale.calculationScale;
        
        if (thiscrulescale.calculationRuleIdInEJBType) thiscrulescale.calculationRuleId = String(thiscrulescale.calculationRuleIdInEJBType);
        if (thiscrulescale.calculationRuleId) thiscrulescale.calculationRuleIdInEJBType = thiscrulescale.calculationRuleId;
     }
     
     var calrange = taxes.calrange;
     for(var i=0; i < size(calrange); i++)
     {
        var thiscalrange = elementAt(i,calrange);
        if (thiscalrange.cumulativeInEJBType) thiscalrange.cumulative = String(thiscalrange.cumulativeInEJBType);
        if (thiscalrange.cumulative) thiscalrange.cumulativeInEJBType = thiscalrange.cumulative;
        
        if (thiscalrange.field2InEJBType) thiscalrange.field2 = String(thiscalrange.field2InEJBType);
        if (thiscalrange.field2) thiscalrange.field2InEJBType = thiscalrange.field2;
        
        if (thiscalrange.field1InEJBType) thiscalrange.field1 = String(thiscalrange.field1InEJBType);
        if (thiscalrange.field1) thiscalrange.field1InEJBType = thiscalrange.field1;
        
        if (thiscalrange.calculationMethodIdInEJBType) thiscalrange.calculationMethodId = String(thiscalrange.calculationMethodIdInEJBType);
        if (thiscalrange.calculationMethodId) thiscalrange.calculationMethodIdInEJBType = thiscalrange.calculationMethodId;

        if (thiscalrange.markForDeleteInEJBType) thiscalrange.markForDelete = String(thiscalrange.markForDeleteInEJBType);
        if (thiscalrange.markForDelete) thiscalrange.markForDeleteInEJBType = thiscalrange.markForDelete;
        
        if (thiscalrange.rangeStartInEJBType) thiscalrange.rangeStart = String(thiscalrange.rangeStartInEJBType);
        if (thiscalrange.rangeStart) thiscalrange.rangeStartInEJBType = thiscalrange.rangeStart;

        if (thiscalrange.calculationScaleIdInEJBType) thiscalrange.calculationScaleId = String(thiscalrange.calculationScaleIdInEJBType);
        if (thiscalrange.calculationScaleId) thiscalrange.calculationScaleIdInEJBType = thiscalrange.calculationScaleId;
        
        if (thiscalrange.calculationRangeIdInEJBType) thiscalrange.calculationRangeId = String(thiscalrange.calculationRangeIdInEJBType);
        if (thiscalrange.calculationRangeId) thiscalrange.calculationRangeIdInEJBType = thiscalrange.calculationRangeId;
     }     
     
     var calrlookup = taxes.calrlookup;
     for(var i=0; i < size(calrlookup); i++)
     {
        var thiscalrlookup = elementAt(i,calrlookup);
        if (thiscalrlookup.calculationRangeLookupResultIdInEJBType) thiscalrlookup.calculationRangeLookupResultId = String(thiscalrlookup.calculationRangeLookupResultIdInEJBType);
        if (thiscalrlookup.calculationRangeLookupResultId) thiscalrlookup.calculationRangeLookupResultIdInEJBType = thiscalrlookup.calculationRangeLookupResultId;
        
        if (thiscalrlookup.calculationRangeIdInEJBType) thiscalrlookup.calculationRangeId = String(thiscalrlookup.calculationRangeIdInEJBType);
        if (thiscalrlookup.calculationRangeId) thiscalrlookup.calculationRangeIdInEJBType = thiscalrlookup.calculationRangeId;
        
        if (thiscalrlookup.valueInEJBType) thiscalrlookup.value = String(thiscalrlookup.valueInEJBType);
        if (thiscalrlookup.value) thiscalrlookup.valueInEJBType = thiscalrlookup.value;
        
     }
     
//    var storecatalogtaxbean = parent.get("StoreCatalogTaxBean1");
//    var catencalcd = storecatalogtaxbean.catencalcd;
//    for (var i=0; i < size(catencalcd); i++)
//     {
//        var thiscatencalcd = elementAt(i,catencalcd);
//        if (thiscatencalcd.contractIdInEJBType) thiscatencalcd.contractId = String(thiscatencalcd.contractIdInEJBType);
//        if (thiscatencalcd.contractId) thiscatencalcd.contractIdInEJBType = thiscatencalcd.contractId;
//        
//        if (thiscatencalcd.storeIdInEJBType) thiscatencalcd.storeId = String(thiscatencalcd.storeIdInEJBType);
//        if (thiscatencalcd.storeId) thiscatencalcd.storeIdInEJBType = thiscatencalcd.storeId;
//        
//        if (thiscatencalcd.catalogEntryCalculationCodeIdInEJBType) thiscatencalcd.catalogEntryCalculationCodeId = String(thiscatencalcd.catalogEntryCalculationCodeIdInEJBType);
//        if (thiscatencalcd.catalogEntryCalculationCodeId) thiscatencalcd.catalogEntryCalculationCodeIdInEJBType = thiscatencalcd.catalogEntryCalculationCodeId;
//        
//        if (thiscatencalcd.catalogEntryIdInEJBType) thiscatencalcd.catalogEntryId = String(thiscatencalcd.catalogEntryIdInEJBType);
//        if (thiscatencalcd.catalogEntryId) thiscatencalcd.catalogEntryIdInEJBType = thiscatencalcd.catalogEntryId;
//        
//        if (thiscatencalcd.calculationCodeIdInEJBType) thiscatencalcd.calculationCodeId = String(thiscatencalcd.calculationCodeIdInEJBType);
//        if (thiscatencalcd.calculationCodeId) thiscatencalcd.calculationCodeIdInEJBType = thiscatencalcd.calculationCodeId;
//     }

    
  }
  
  
  