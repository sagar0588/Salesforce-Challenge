/*****************************************************************************************************
*  LoanIntegrationTriggerHandler 
* @Description: Handler class for LoanIntegrationTrigger 
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LoanIntegrationTriggerHandler {
    
    //Handler method for Trigger.afterinsert event
    public static void afterInsert(List<Loan__c> loanList) {
        LendingSystemIntegration.createLoanRecordInLendingSystem(loanList); 
    }
    //Handler method for Trigger.afterupdate event
    public static void afterUpdate(List<Loan__c> loanList, List<Loan__c> oldList) {
        Map<Id, Loan__c> oldMap = new Map<Id, Loan__c>(oldList);
        List<Loan__c> loanRecToProcess = new List<Loan__c>();
        Set<String> parentAccIdSet = new Set<String>();
        for(Loan__c loanRec : loanList) {
            if(loanRec.Amount__c != oldMap.get(loanRec.Id).Amount__c) {
                loanRecToProcess.add(loanRec);
            }
            if(loanRec.Account__c != null) {
                parentAccIdSet.add(loanRec.Account__c);
            }
        }
        //_______Verify if the list is eligible to make update callouts in Lending system to avoid Trigger recursion___//
        if(!loanRecToProcess.isEmpty()) {
            LendingSystemIntegration.updateLoanRecordInLendingSystem(loanRecToProcess, parentAccIdSet); 
        }
    }
    //Handler method for Trigger.beforeDelete event
    public static void beforeDelete(List<Loan__c> oldList) {
        LendingSystemIntegration.deleteLoanRecordInLendingSystem(oldList); 
    }
}