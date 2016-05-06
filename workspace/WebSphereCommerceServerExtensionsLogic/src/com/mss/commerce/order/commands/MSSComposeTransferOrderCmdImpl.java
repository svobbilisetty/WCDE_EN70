package com.mss.commerce.order.commands;

import java.util.List;
import java.util.logging.Logger;

import com.ibm.commerce.foundation.common.util.logging.LoggingHelper;
import com.ibm.commerce.order.facade.datatypes.OrderType;
import com.ibm.commerce.order.facade.datatypes.PaymentInstructionType;
import com.ibm.commerce.order.facade.datatypes.ShowOrderType;
import com.ibm.commerce.order.facade.server.commands.ComposeTransferOrderCmdImpl;
import com.ibm.websphere.command.CommandException;

public class MSSComposeTransferOrderCmdImpl extends ComposeTransferOrderCmdImpl 
{
	private static final String CLASSNAME = MSSComposeTransferOrderCmdImpl.class.getName();
	private static final Logger LOGGER = LoggingHelper.getLogger(MSSComposeTransferOrderCmdImpl.class);
	
	/**
	 * Customize the OOB command to avoid construction of payment instruction xml
	 * @param: List
	 * @return: ShowOrderType
	 */
	protected ShowOrderType composeOrderDetail(List avOrders) throws CommandException {

		final String METHODNAME = "composeOrderDetail";
		
		if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	        LOGGER.entering(CLASSNAME, METHODNAME);
	    }

		boolean traceEnabled = LoggingHelper.isTraceEnabled(LOGGER);
		
		ShowOrderType showOrderType = null;
		
		try
		{
			showOrderType = super.composeOrderDetail(avOrders);
			List lOrder = showOrderType.getDataArea().getOrder();
			
			OrderType ordType = (OrderType) lOrder.get(0);
		
			List lPIType = ordType.getOrderPaymentInfo().getPaymentInstruction();
			PaymentInstructionType paymentType = (PaymentInstructionType)lPIType.get(0);
			lPIType.set(0, setBillMeLaterPaymentRule(paymentType));			
		}
		
		catch(Exception e)
        {
            if(traceEnabled)
                LOGGER.logp(LOGGER.getLevel(), CLASSNAME, "performExecute()", e.getMessage(), e);
        }
		
		if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	        LOGGER.exiting(CLASSNAME, METHODNAME);
		}
		System.err.println("Can you seeme");
		return showOrderType;
	}
	
	protected PaymentInstructionType setBillMeLaterPaymentRule(PaymentInstructionType paymentType) throws CommandException {

		final String METHODNAME = "setBillMeLaterPaymentRule";
		
		if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	        LOGGER.entering(CLASSNAME, METHODNAME);
	    }

		boolean traceEnabled = LoggingHelper.isTraceEnabled(LOGGER);
		
		try
		{
			paymentType.setPaymentRule("BillMeLater");
		}
		
		catch(Exception e)
        {
            if(traceEnabled)
                LOGGER.logp(LOGGER.getLevel(), CLASSNAME, "performExecute()", e.getMessage(), e);
        }
		
		if (LoggingHelper.isEntryExitTraceEnabled(LOGGER)) {
	        LOGGER.exiting(CLASSNAME, METHODNAME);
		}
		return paymentType;
	}
}