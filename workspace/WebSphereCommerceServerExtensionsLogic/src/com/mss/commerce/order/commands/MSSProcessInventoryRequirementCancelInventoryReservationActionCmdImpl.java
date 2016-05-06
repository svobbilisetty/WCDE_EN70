package com.mss.commerce.order.commands;

import java.util.logging.Logger;

import com.ibm.commerce.foundation.common.util.logging.LoggingHelper;
import com.ibm.commerce.inventory.facade.datatypes.AcknowledgeInventoryRequirementType;
import com.ibm.commerce.inventory.facade.server.commands.ProcessInventoryRequirementActionCmd;
import com.ibm.commerce.inventory.facade.server.commands.ProcessInventoryRequirementCancelInventoryReservationActionCmdImpl;

public class MSSProcessInventoryRequirementCancelInventoryReservationActionCmdImpl extends
ProcessInventoryRequirementCancelInventoryReservationActionCmdImpl implements
		ProcessInventoryRequirementActionCmd 
{
	private static final String CLASSNAME = MSSProcessInventoryRequirementCancelInventoryReservationActionCmdImpl.class.getName();
	private static final Logger LOGGER = LoggingHelper.getLogger(MSSProcessInventoryRequirementCancelInventoryReservationActionCmdImpl.class);
	
	/**
	 * Customized method to avoid reserve inventory call to the external system
	 */
	public void performExecute() throws Exception 
	{
		final String METHODNAME = "performExecute";
		
		if (LoggingHelper.isEntryExitTraceEnabled(LOGGER))
		{
	        LOGGER.entering(CLASSNAME, METHODNAME);
	    }
		
		boolean traceEnabled = LoggingHelper.isTraceEnabled(LOGGER);
		
		AcknowledgeInventoryRequirementType respondBOD = null;
        try
        {
        	//super.performExecute();
        	
        	//Do nothing
            respondBOD = null;
        }
        catch(Exception e)
        {
            if(traceEnabled)
                LOGGER.logp(LOGGER.getLevel(), CLASSNAME, "performExecute()", e.getMessage(), e);
        }
		
		if (LoggingHelper.isEntryExitTraceEnabled(LOGGER))
		{
	        LOGGER.exiting(CLASSNAME, METHODNAME);
		}
	}
}