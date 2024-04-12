/*****************************************************************************************************
*  LendingSystemIntegrationHelper 
* @Description: Helper class to prepare request body and process response from lending system
*				and other helper methods used to make callouts
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LendingSystemIntegrationHelper {
    
    public static String prepareRequestToProcessLoanRecord(Loan__c loan, String accNumber, String operation) {
        
        LendingSystemIntegrationWrapper reqWrapper = new LendingSystemIntegrationWrapper();
        reqWrapper.operation = operation;//indicator for insert operation
        if(operation == 'D') {
            reqWrapper.loanId = loan.LoanId__c;      
        }else {
            if(operation == 'U') {
                reqWrapper.loanId = loan.LoanId__c;    
            }
            reqWrapper.amount = loan.Amount__c;
            reqWrapper.accountNumber = accNumber; 
        }
        
        return JSON.serialize(reqWrapper);    
    }
    
}