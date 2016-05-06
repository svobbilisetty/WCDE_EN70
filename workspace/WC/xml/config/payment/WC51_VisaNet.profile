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
  This is the Standard WebSphere Commerce cashier profile for the Cassette for VisaNet 
       with Account number set to 1.
 ================================================================== --> 

<Profile useWallet="false" enableTrace="true">

  <CollectPayment>

    <!-- ==================================================================
      Parameters required by WebSphere Commerce Payments
     ================================================================== -->
   
    <Parameter name="PAYMENTTYPE"><CharacterText>VisaNet</CharacterText></Parameter>
    <Parameter name="MERCHANTNUMBER"><CharacterText>{storeId}</CharacterText></Parameter>
    <Parameter name="ORDERNUMBER"><CharacterText>{orderId}</CharacterText></Parameter>
    <Parameter name="AMOUNT"><CharacterText>{AMOUNT}</CharacterText></Parameter>
    <Parameter name="CURRENCY"><CharacterText>{CURRENCY}</CharacterText></Parameter>
    <Parameter name="AMOUNTEXP10"><CharacterText>{AMOUNTEXP10}</CharacterText></Parameter>
    
    <!-- ==================================================================
      Optional parameters for WebSphere Commerce Payments
     ================================================================== -->
    
    <!--  Indicates how automatic approval of the order should be attempted
          Supported values are: 
            0 - no automatic approval
            1 - synchronous automatic approval - WebSphere Commerce Payments attempts approval as
                part of order creation operation
            2 - asynchronous automatic approval - WebSphere Commerce Payments schedules an approval
                operations after order is created
          The default value is 0.

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
     
    <!-- The credit card number -->
    <Parameter name="$PAN" sensitive="true"><CharacterText>{card_number}</CharacterText></Parameter>
    
    <!-- The expiry date in format YYYYMM -->
    <Parameter name="$EXPIRY"><CharacterText>{card_expiry}</CharacterText></Parameter>
    
    <Parameter name="$ACCOUNTNUMBER"><CharacterText>1</CharacterText></Parameter>

    <!-- The cardholder's street address -->
    <Parameter name="$AVS.STREETADDRESS" maxBytes="24" encoding="ASCII"><CharacterText>{billto_address1}</CharacterText></Parameter>
    
    <!-- The cardholder's zip code -->
    <Parameter name="$AVS.POSTALCODE" maxBytes="9" encoding="ASCII"><CharacterText>{billto_zipcode}</CharacterText></Parameter>



    <!-- ==================================================================
      Optional parameters for the cassette
     ================================================================== -->
    
    <!-- Some payment cards are issued with a verification code. The verification
         code is generated by the issuing bank and can be verified by the bank. 
         The account number followed by the three or four digit verification code 
         is printed on the signature panel of the card. The value must be a 3 or 4 
         character numeric string. Example values: 1234 or 321.  -->
    <Parameter name="$CARDVERIFYCODE" maxBytes="4" encoding="ASCII"><CharacterText>{cardVerificationCode}</CharacterText></Parameter>

    <!-- A purchase order number to be associated with this order -->
    <Parameter name="$PURCHORDERNUM"><CharacterText></CharacterText></Parameter>

    <!-- The maximum number of payments to be allowed for this order -->
    <Parameter name="$NUMPAYMENTS"><CharacterText>1</CharacterText></Parameter>

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
