/*****************************************************************************************************
*  LendingSystemIntegration 
* @Description: Apex class to develop business logic to make lending system integration
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LendingSystemIntegration {
    
    //Method to create loan record in lending system
    public static void createLoanRecordInLendingSystem(List<Loan__c> loanRecList) {
        //list to hold log records to be created
        List<LogInfo__c> loggerList = new List<LogInfo__c>();
        //set to hold parent account ids
        Set<String> parentAccIdSet = new Set<String>();
        //Map to hold Accountid and Account number mapping
        Map<String, String> accIdaccNumberMap = new Map<String, String>();
        try{
            for(Loan__c loanRec : loanRecList) {
                if(loanRec.Account__c != null) {
                    parentAccIdSet.add(loanRec.Account__c);
                }
            }
            //check if the parent account id set is empty
            if(!parentAccIdSet.isEmpty()) {
                for(Account parentAcc : [SELECT Id, AccountNumber FROM Account WHERE Id IN:parentAccIdSet]) {
                    accIdaccNumberMap.put(parentAcc.Id, parentAcc.AccountNumber);
                }
            }
            
            //__________To OVERCOME THE SF LIMITATION WITH FUTURE METHOD BETTER TO PREFER QUEUEABLE THAN FUTURE____//
            LendingSystemIntegrationQueue calloutQueue = new LendingSystemIntegrationQueue(loanRecList, accIdaccNumberMap, 'I');
            System.enqueueJob(calloutQueue);
            
        }catch(Exception ex) {
            //create error log for this exception
            insert LogManager.createLog('', 'exception', null, null, 'Exception occured '+ex.getMessage(),'LendingSystemIntegration', 'createLoanRecordInLendingSystem', ex.getStackTraceString());
        }
    }
    
    //Method to update loan record in lending system
    public static void updateLoanRecordInLendingSystem(List<Loan__c> loanRecList, Set<String> parentAccIdSet) {
        //list to hold log records to be created
        List<LogInfo__c> loggerList = new List<LogInfo__c>();
        //Map to hold Accountid and Account number mapping
        Map<String, String> accIdaccNumberMap = new Map<String, String>();
        try{
            if(!parentAccIdSet.isEmpty()) {
                for(Account parentAcc : [SELECT Id, AccountNumber FROM Account WHERE Id IN:parentAccIdSet]) {
                    accIdaccNumberMap.put(parentAcc.Id, parentAcc.AccountNumber);
                }
            }
            
            //__________To OVERCOME THE SF LIMITATION WITH FUTURE METHOD BETTER TO PREFER QUEUEABLE THAN FUTURE____//
            LendingSystemIntegrationQueue calloutQueue = new LendingSystemIntegrationQueue(loanRecList, accIdaccNumberMap, 'U');
            System.enqueueJob(calloutQueue);
            //______EITHER FUTURE OR QUEUEABLE SHOULD BE PRESENT IN THE CODE DURING RUN TIME____//
            
        }catch(Exception ex) {
            //create error log for this exception
            insert LogManager.createLog('', 'exception', null, null, 'Exception occured '+ex.getMessage(),'LendingSystemIntegration', 'updateLoanRecordInLendingSystem', ex.getStackTraceString());
        }
    }
    //Method to delete the loan record in lending system
    public static void deleteLoanRecordInLendingSystem(List<Loan__c> loanRecList) {
        //list to hold log records to be created
        List<LogInfo__c> loggerList = new List<LogInfo__c>();
       
        try{ 
            
            //__________To OVERCOME THE SF LIMITATION WITH FUTURE METHOD BETTER TO PREFER QUEUEABLE THAN FUTURE____//
            LendingSystemIntegrationQueue calloutQueue = new LendingSystemIntegrationQueue(loanRecList, new Map<String, String>(), 'D');
            System.enqueueJob(calloutQueue);
            //______EITHER FUTURE OR QUEUEABLE SHOULD BE PRESENT IN THE CODE DURING RUN TIME____//
            
        }catch(Exception ex) {
            //create error log for this exception
            insert LogManager.createLog('', 'exception', null, null, 'Exception occured '+ex.getMessage(),'LendingSystemIntegration', 'updateLoanRecordInLendingSystem', ex.getStackTraceString());
        }
    }
}