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
  This is the Standard WebSphere Commerce cashier profile for the OfflineCard Cassette
 ================================================================== -->

<Profile useWallet="false" enableTrace="true" >

 <CollectPayment>

   <!-- ==================================================================
      Parameters required by WebSphere Commerce Payments for order creation
     ================================================================== -->
   <Parameter name="PAYMENTTYPE"><CharacterText>OfflineCard</CharacterText></Parameter>
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
   <Parameter name="TRANSACTIONID" maxBytes="128" encoding="ASCII"><CharacterText>{PONumber}</CharacterText></Parameter>
   <Parameter name="ORDERDATA2"><CharacterText></CharacterText></Parameter>


   <!-- ==================================================================
      Parameters required by the cassette
     ================================================================== -->

   <Parameter name="$PAN" sensitive="true"><CharacterText>{card_number}</CharacterText></Parameter>
   <Parameter name="$BRAND"><CharacterText>{cardBrand}</CharacterText></Parameter>
   
   <!-- The expiry date in format YYYYMM -->
   <Parameter name="$EXPIRY"><CharacterText>{card_expiry}</CharacterText></Parameter>
   

   <!-- ==================================================================
      Optional Parameters for the cassette

        $CARDHOLDERNAME         1 -  64 bytes 
        $AVS.STREETADDRESS      1 - 128 bytes 
        $AVS.CITY               1 -  50 bytes
        $AVS.STATEPROVINCE      1 -  50 bytes
        $AVS.POSTALCODE         1 -  14 bytes
        $AVS.COUNTRYCODE        1 -  50 bytes
     ================================================================== -->
   <Parameter name="$CARDHOLDERNAME"    maxBytes="64" ><CharacterText></CharacterText></Parameter>
   <Parameter name="$AVS.STREETADDRESS" maxBytes="128"><CharacterText>{billto_address1}</CharacterText></Parameter>
   <Parameter name="$AVS.CITY"          maxBytes="50" ><CharacterText>{billto_city}</CharacterText></Parameter>
   <Parameter name="$AVS.STATEPROVINCE" maxBytes="50" ><CharacterText>{billto_state}</CharacterText></Parameter>
   <Parameter name="$AVS.POSTALCODE"    maxBytes="14" ><CharacterText>{billto_zipcode}</CharacterText></Parameter>
   <Parameter name="$AVS.COUNTRYCODE"   maxBytes="50" ><CharacterText>{billto_country}</CharacterText></Parameter>

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
