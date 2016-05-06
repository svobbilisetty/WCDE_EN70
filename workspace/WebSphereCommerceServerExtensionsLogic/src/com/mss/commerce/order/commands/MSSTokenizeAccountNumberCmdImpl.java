package com.mss.commerce.order.commands;

import com.ibm.commerce.order.facade.server.commands.TokenizeAccountNumberCmd;
import com.ibm.websphere.command.CommandException;

/**
 * An implementation of this class is needed by Commerce to submit an order to an external system.
 * This is a dummy class, since no tokenization of account information is needed.
 * @author miracle
 *
 */
public class MSSTokenizeAccountNumberCmdImpl implements
		TokenizeAccountNumberCmd {

	@Override
	public String getDisplayValue() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getToken() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAccountNumber(String s) {
		// TODO Auto-generated method stub

	}

	@Override
	public void setPaymentInstructionId(Long long1) {
		// TODO Auto-generated method stub

	}

	@Override
	public void execute() throws CommandException {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean isReadyToCallExecute() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void reset() {
		// TODO Auto-generated method stub

	}

}
