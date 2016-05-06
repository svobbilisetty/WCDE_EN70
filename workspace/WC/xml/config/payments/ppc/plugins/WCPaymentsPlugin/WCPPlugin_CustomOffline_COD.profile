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
  This is the Standard WebSphere Commerce cashier profile for the CustomOffline Cassette 
      for the "COD" payment method ($METHOD="COD")
 ================================================================== -->

<Profile useWallet="false" enableTrace="true" >

 <CollectPayment>
 
   <!-- ==================================================================
      Parameters required by WebSphere Commerce Payments for order creation
     ================================================================== -->
   <Parameter name="PAYMENTTYPE"><CharacterText>CustomOffline</CharacterText></Parameter>
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
          The default value is 0.
     -->
   <Parameter name="APPROVEFLAG"><CharacterText>0</CharacterText></Parameter>

   <!-- The amount which should be used when approving an order.  Usually
         this will be the same as the order amount.  This field is required
         if the APPROVEFLAG is set to 1 or 2. -->
   <Parameter name="PAYMENTAMOUNT"><CharacterText></CharacterText></Parameter>

   <!-- The payment number which should be used when approving an order.
         Usually this will be 1.  This field is required if the APPROVEFLAG
         is set to 1 or 2. -->
   <Parameter name="PAYMENTNUMBER"><CharacterText></CharacterText></Parameter>

   <!-- Indicates whether the deposit should be attempted automatically. 
         This flag is only valid if APPROVEFLAG is set to 1 or 2.
         Supported values are:
           0 - Funds should not be automatically deposited. 
           1 - Funds should be automatically deposited. 
         The default value is 0.

         Automatic Deposit can also be controled via the Account Advanced Setting
     -->
   <Parameter name="DEPOSITFLAG"><CharacterText></CharacterText></Parameter>

   <!-- The following two parameters are optional.  Either one could be used to pass the 
        Buyer Purchase Order number to WebSphere Commerce Payments. The first Parameter takes only 
        ASCII Text. If Buyer Purchase Order numbers on your system may contain non-ASCII 
        Strings, use parameter ORDERDATA2 instead. 
     -->
   <Parameter name="TRANSACTIONID" maxBytes="128" encoding="ASCII"><CharacterText>{purchaseorder_id}</CharacterText></Parameter>
   <Parameter name="ORDERDATA2"><CharacterText></CharacterText></Parameter>


   <!-- ==================================================================
      Parameters required by the cassette
     ================================================================== -->

   <!-- Indicates the manual payment method to be used.  Must match one of the
         methods configured for the CustomOffline Accounts for the Merchant.
         This is an ASCII String from 1 to 32 characters long.
     -->
   <Parameter name="$METHOD"><CharacterText>COD</CharacterText></Parameter>


   <!-- ==================================================================
      Optional parameters for the CustomOffline Cassette
     ================================================================== -->

   <!-- Use the $AUXILIARY1 and $AUXILIARY2 fields for anything you like.
         Can be any String from 0 to 254 Characters long.  
     -->
   <Parameter name="$AUXILIARY1"><CharacterText>{$AUXILIARY1}</CharacterText></Parameter>
   <Parameter name="$AUXILIARY2"><CharacterText>{$AUXILIARY2}</CharacterText></Parameter>

   <Parameter name="$STREETADDRESS"><CharacterText>{billto_address1}</CharacterText></Parameter>
   <Parameter name="$CITY"><CharacterText>{billto_city}</CharacterText></Parameter>
   <Parameter name="$STATEPROVINCE"><CharacterText>{billto_state}</CharacterText></Parameter>
   <Parameter name="$POSTALCODE"><CharacterText>{billto_zipcode}</CharacterText></Parameter>
   <Parameter name="$COUNTRYCODE"><CharacterText>{billto_country}</CharacterText></Parameter>

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
