<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Profile SYSTEM "profile.dtd">

<!--
//*==================================================================
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*================================================================== -->

<!-- ==================================================================
  This is the Standard WebSphere Commerce cashier profile for the Cassette for Paymentech
 ================================================================== -->

<Profile useWallet="false" enableTrace="true" >

 <SelectStatement id="1" >
      SELECT DISTINCT COUNTRYABBR FROM Country WHERE name = '{billto_country}'
 </SelectStatement> 

 <CollectPayment>

   <!-- ==================================================================
      Parameters required by WebSphere Commerce Payments for order creation
     ================================================================== -->
   <Parameter name="PAYMENTTYPE"><CharacterText>Paymentech</CharacterText></Parameter>
   <Parameter name="MERCHANTNUMBER"><CharacterText>{storeId}</CharacterText></Parameter>
   <Parameter name="ORDERNUMBER"><CharacterText>{orderId}</CharacterText></Parameter>
   <Parameter name="AMOUNT"><CharacterText>{AMOUNT}</CharacterText></Parameter>
   <Parameter name="CURRENCY"><CharacterText>{CURRENCY}</CharacterText></Parameter>
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
   <Parameter name="$PAN" sensitive="true"><CharacterText>{card_number}</CharacterText></Parameter>
   
   <!-- The expiry date in format YYYYMM -->
   <Parameter name="$EXPIRY"><CharacterText>{card_expiry}</CharacterText></Parameter>

   <!-- postalcode; required field -->
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
    
   <!-- The $CARDHOLDERNAME, $AVS.STREETADDRESS, $AVS.CITY and $AVS.STATEPROVINCE  
         parameters are only for use with the United States Address Verification Service. 
         Only English ASCII characters are allowed in these fields.
     -->
   <Parameter name="$CARDHOLDERNAME"     maxBytes="30"  encoding="ASCII"><CharacterText>{billto_firstname} {billto_lastname}</CharacterText></Parameter>   
   <Parameter name="$AVS.STREETADDRESS"  maxBytes="30"  encoding="ASCII"><CharacterText>{billto_address1}</CharacterText></Parameter>
   <Parameter name="$AVS.STREETADDRESS2" maxBytes="28"  encoding="ASCII"><CharacterText>{billto_address2}</CharacterText></Parameter>
   <Parameter name="$AVS.CITY"           maxBytes="20"  encoding="ASCII"><CharacterText>{billto_city}</CharacterText></Parameter>
   
   <!-- Optional.  Only the 2-character US State Codes in Uppercase (e.g. AL for Alabama, AK for Alaska, etc.) 
        are accepted by the Cassette.  (We are omitting this parameter here.)
        
    If required, the BankServACH Cashier Extension class 
    (com.ibm.commerce.payment.extensions.BankServACHCashierExtension) could be used here to locate 
    the 2-character State Code from the WebSphere Commerce STATEPROV Table using the value specified
    in the {billto_state} environment variable as State name.  The Cashier Extension returns null 
    if no State Code can be found for the State name specified.  For compatibility, the Extension 
    class returns the {billto_state} environment variable value as the State code if the value is 
    of length two.  Simply replace the line between the Parameter start and end tags below with the 
    following:
        <ExtensionValue name="com.ibm.commerce.payment.extensions.BankServACHCashierExtension" />
    -->
   <Parameter name="$AVS.STATEPROVINCE" maxBytes="2"  encoding="ASCII">
        <CharacterText></CharacterText>
   </Parameter>
   
   
    <!-- The cardholder''s phone number should be entered as a 10 or 14 character string 
         in the format AAAEEENNNNXXXX where AAA = Area Code, EEE = Exchange, NNNN = Number, 
         and XXXX = Extension. -->
    <Parameter name="$AVS.PHONENUMBER" maxBytes="14" encoding="ASCII"><CharacterText></CharacterText></Parameter>
   
    <!-- The allowed values for the cardholder''s phone number type include Home (H), Work (W), 
         Day (D), and Night (N). -->
    <Parameter name="$AVS.PHONETYPE"><CharacterText></CharacterText></Parameter>
    
    <!-- The allowed values for the cardholder''s country code include 
         - CA (Canada),
         - GB (Great Britian), 
         - US (United States),
         - etc.
     -->
    <Parameter name="$AVS.COUNTRYCODE" maxBytes="2" encoding="ASCII">
        <DatabaseValue statementID="1" columnName="COUNTRYABBR" />
    </Parameter>
    
    <!-- The allowed values for transaction type include 
         - Recurring Transaction (2), 
         - Installment Payment (3), 
         - Non-SET Transaction Channel Encrypted (7), and 
         - Non-Secure Electronic Commerce Transaction (8).  
         
         See the cassette''s documentation for more information regarding this field. 
     -->
    <Parameter name="$TRANSACTIONTYPE"><CharacterText></CharacterText></Parameter>
    
    <!-- Card Security Presence refers to the presence of the Card Verification Code on the 
         cardholder's credit card.  The allowed values for card security presence include 
         Value Present (1), Value Illegible (2), and Value Not Present (9). -->
    <Parameter name="$CARDSECURITYPRESENCE"><CharacterText></CharacterText></Parameter>

    <!-- The settlement mode indicates whether the batch will be settled online (0) or offline (1). 
         The settlement mode will default to 0 (online settlement) if no value is specified.
     -->
    <Parameter name="$SETTLEMENTMODE"><CharacterText></CharacterText></Parameter>


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
