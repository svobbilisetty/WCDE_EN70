<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Profile SYSTEM "profile.dtd">

<!--
//*==================================================================
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*================================================================== -->

<!-- ==================================================================
  This is the Standard WebSphere Commerce cashier profile for the Cassette for BankServACH.  
  (This Cassette is for US Only.)
 ================================================================== -->

<Profile useWallet="false" enableTrace="true" >

 <CollectPayment>
 
   <!-- ==================================================================
      Parameters required by WebSphere Commerce Payments for order creation
     ================================================================== -->
     
   <Parameter name="PAYMENTTYPE"><CharacterText>BankServACH</CharacterText></Parameter>
   
   <Parameter name="MERCHANTNUMBER"><CharacterText>{storeId}</CharacterText></Parameter>
   <Parameter name="ORDERNUMBER"><CharacterText>{orderId}</CharacterText></Parameter>
   <Parameter name="CURRENCY"><CharacterText>{CURRENCY}</CharacterText></Parameter>
   <Parameter name="AMOUNT"><CharacterText>{AMOUNT}</CharacterText></Parameter>
   <Parameter name="AMOUNTEXP10"><CharacterText>{AMOUNTEXP10}</CharacterText></Parameter>

   <!--  Indicates how automatic approval of the order should be attempted
          Supported values are: 
            0 - no automatic approval
            1 - synchronous automatic approval - WebSphere Commerce Payments attempts approval as
                part of order creation operation
            2 - asynchronous automatic approval - WebSphere Commerce Payments schedules an approval
                operations after order is created
   
        WebSphere Commerce works best with APPROVEFLAG set to 2. When the APPROVEFLAG is set to 1, the
        DoPayment command is blocked until WebSphere Commerce Payments completes the approval of the order. 
        Until this approval is complete, any commands wanting to read/update the same inventory 
        records modified by the DoPayment command will be blocked.  This will affect the throughput
        of the other commands.
     -->
   <Parameter name="APPROVEFLAG"><CharacterText>2</CharacterText></Parameter>

   <!-- The amount which should be used when approving an order.  Usually
         this will be the same as the order amount.  This field is required
         if the APPROVEFLAG is set to 1 or 2. -->
   <Parameter name="PAYMENTAMOUNT"><CharacterText>{approval_amount}</CharacterText></Parameter>

   <!-- The payment number which should be used when approving an order.
         Usually this will be 1.  This field is required if the APPROVEFLAG
         is set to 1 or 2. -->
   <Parameter name="PAYMENTNUMBER"><CharacterText>1</CharacterText></Parameter>

   <!-- Indicates whether the deposit should be attempted automatically. 
         This flag is only valid if APPROVEFLAG is set to 1 or 2.
         Supported values are:
           0 - Funds should not be automatically deposited. 
           1 - Funds should be automatically deposited. 
         The default value is 0.
     -->
   <Parameter name="DEPOSITFLAG"><CharacterText></CharacterText></Parameter>

   <!-- ==================================================================
      Optional parameters for WebSphere Commerce Payments
     ================================================================== -->
   
   <!-- The following two parameters are optional.  Either one could be used to pass the 
        Buyer Purchase Order number to WebSphere Commerce Payments. The first Parameter takes only 
        ASCII Text. If Buyer Purchase Order numbers on your system may contain non-ASCII 
        Strings, use parameter ORDERDATA2 instead. 
     -->
   <Parameter name="TRANSACTIONID" maxBytes="128" encoding="ASCII"><CharacterText>{PONumber}</CharacterText></Parameter>
   <Parameter name="ORDERDATA2"><CharacterText></CharacterText></Parameter>
   
   <!-- ==================================================================
      Parameters required by the cassette
     ================================================================== -->
   <!-- The checking account number -->
   <Parameter name="$CHECKINGACCOUNTNUMBER"><CharacterText>{checkingAccountNumber}</CharacterText></Parameter>
    
   <!-- The check routing number -->
   <Parameter name="$CHECKROUTINGNUMBER"><CharacterText>{checkRoutingNumber}</CharacterText></Parameter>

   <Parameter name="$BUYERNAME"     maxBytes="80" encoding="ASCII"><CharacterText>{billto_firstname} {billto_lastname}</CharacterText></Parameter>
   <Parameter name="$STREETADDRESS" maxBytes="50" encoding="ASCII"><CharacterText>{billto_address1}</CharacterText></Parameter>
   <Parameter name="$CITY"          maxBytes="50" encoding="ASCII"><CharacterText>{billto_city}</CharacterText></Parameter>
   
   <!-- Only the 2-character US State Codes in Uppercase (e.g. AL for Alabama, AK for Alaska, etc.) 
        are accepted by the cassette.    The BankServACH Cashier Extension class is used to locate 
        the 2-character State Code from the WebSphere Commerce STATEPROV Table using the value specified
        in the {billto_state} environment variable as State name.  The Cashier Extension returns null 
        if no State Code can be found for the State name specified.  For compatibility, the Extension 
        class returns the {billto_state} environment variable value as the State code if the value is 
        of length two.
   -->
   <Parameter name="$STATEPROVINCE" maxBytes="2"  encoding="ASCII">
       <ExtensionValue name="com.ibm.commerce.payment.extensions.BankServACHCashierExtension" />
   </Parameter>
   <Parameter name="$POSTALCODE"    maxBytes="9"  encoding="ASCII"><CharacterText>{billto_zipcode}</CharacterText></Parameter>
   <Parameter name="$COUNTRYCODE"   maxBytes="2"  encoding="ASCII"><CharacterText>US</CharacterText></Parameter>
   <Parameter name="$PHONENUMBER"   maxBytes="10" encoding="ASCII"><CharacterText>{billto_phone_number}</CharacterText></Parameter>

   <!-- ==================================================================
      Optional parameters for the cassette
     ================================================================== -->
   <Parameter name="$STREETADDRESS2" maxBytes="50" encoding="ASCII"><CharacterText></CharacterText></Parameter>
   <Parameter name="$EMAILADDRESS"   maxBytes="49" encoding="ASCII"><CharacterText></CharacterText></Parameter>

 </CollectPayment>

 <Command name="DEPOSIT">
   <!-- ==================================================================
      Parameters required by WebSphere Commerce Payments for the DEPOSIT Command
     ================================================================== -->
   <Parameter name="MERCHANTNUMBER"><CharacterText>{storeId}</CharacterText></Parameter>
   <Parameter name="ORDERNUMBER"><CharacterText>{orderId}</CharacterText></Parameter>
   <Parameter name="PAYMENTNUMBER"><CharacterText>{payment_number}</CharacterText></Parameter>
   <Parameter name="AMOUNT"><CharacterText>{AMOUNT}</CharacterText></Parameter>
   
 </Command>
 


</Profile>
