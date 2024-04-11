/*****************************************************************************************************
*  LendingSystemIntegrationQueue 
* @Description: created this class to handle callouts due to callout limitation with future method 
***************ANOTHER APPROACH TO HANDLE SALESFORCE LIMITATIONS****************************				
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LendingSystemIntegrationQueue implements queueable, Database.Allowscallouts{
    public List<Loan__c> loanRecList = new List<Loan__c>();
    public Map<String, String> accIdaccNumberMap = new map<String, String>();
    public String operation;
    //queueable constructor to accept list of records
    public LendingSystemIntegrationQueue(List<Loan__c> loanRecList, Map<String, String> accIdaccNumberMap, String operation) {
        this.loanRecList = loanRecList;
        this.accIdaccNumberMap = accIdaccNumberMap;
        this.operation = operation;
    }
    public void execute(QueueableContext qc) {
        List<Loan__c> firstList = new List<Loan__c>();
        List<Loan__c> secondList = new List<Loan__c>();
        Boolean previousQueueCompleted = false;
        try{
            //__check the records size is greater than 100 and divide it in to 2 lists to avoid callout:101 exception--//
            if(loanRecList.size() > 100) {
                for(Integer i = 0; i < 100; i++) {
                    //_________make callout in current transaction for this first list_______//
                    firstList.add(loanRecList[i]);
                }
                for(Integer j = 100; j < loanRecList.size(); j++) {
                    //_________make callout in a new transaction for this second list by chaining another queueable_______//
                    secondList.add(loanRecList[j]);
                }
                //__________Invoking makeHttpCallout method to make callouts for first list_______________//
                previousQueueCompleted = makeHttpCallout(accIdaccNumberMap, firstList, operation);
                //_________Chaining the next queue for second list_______//
                if(!Test.isRunningTest() && previousQueueCompleted == true) {//chaining is not allowed from test class
                    LendingSystemIntegrationQueue calloutQueue = new LendingSystemIntegrationQueue(secondList, accIdaccNumberMap, operation);
                    System.enqueueJob(calloutQueue);
                }
            }else {
                //______________Make the callout for the full list because size is less than equal to 100 and won't hit limits_________//
                makeHttpCallout(accIdaccNumberMap, loanRecList, operation);
            }
        }catch(Exception ex) {
             //______________________create error log for this exception________________________//
            insert LogManager.createLog('', 'exception', null, null, 'Exception occured in Queue '+ex.getMessage(),'LendingSystemIntegrationQueue', 'execute', ex.getStackTraceString());
        }
    }
    
    //_______________________Method is used to make final callouts and create errors logs__________________//
    private  Boolean makeHttpCallout(Map<String, String> accIdaccNumberMap, List<Loan__c> loanRecList, String operation) {
        List<LogInfo__c> loggerList = new List<LogInfo__c>();
        List<Loan__c> updateList = new List<Loan__c>();
        
        for(Loan__c loanRec : loanRecList) {
            if(operation == 'D' || (operation != 'D' && accIdaccNumberMap.containsKey(loanRec.Account__c))) {
                //Prepare json request body string
                String accNumber = accIdaccNumberMap.get(loanRec.Account__c);
                //___________Constructing JSON request body based on the operation type_______________//
                String jsonBodyStr = LendingSystemIntegrationHelper.prepareRequestToProcessLoanRecord(loanRec, accNumber ,operation); 
                //___________Making callout to lending system_____________________//
                Map<String, Object> reqResMap = HttpCalloutController.makeHttpCallout(jsonBodyStr, 'LendingIntegration');
                HttpRequest request = (HttpRequest)reqResMap.get('request');
                HttpResponse response = (HttpResponse)reqResMap.get('response');
                System.debug('response '+response);
                //___________Success Response______________________//
                if(response.getStatusCode() == 201 || response.getStatus() == 'Created') {
                    String responseBody = response.getBody();
                    LendingSystemIntegrationWrapper respWrap = (LendingSystemIntegrationWrapper)JSON.deserialize(responseBody, LendingSystemIntegrationWrapper.class);
                    if(operation != 'D') {
                        Loan__c updateLoanRec = new Loan__c();
                        updateLoanRec.Id = loanRec.Id;
                        updateLoanRec.LoanId__c = respWrap.loanId;
                        updateList.add(updateLoanRec);  
                    } 
                    
                    //_________________create success log__________//
                    loggerList.add(LogManager.createLog(loanRec.Id, 'Success', jsonBodyStr, response,'Loan record is processed in lending system',
                                                        'LendingSystemIntegration', 'createLoanRecordInLendingSystem',''));
                    
                }else {//________________Error Response from Lending System______________//
                    
                    //__________create error log___________//
                    loggerList.add(LogManager.createLog(loanRec.Id, 'Error', jsonBodyStr, response,'Loan record process is failed in lending system',
                                                        'LendingSystemIntegration', 'createLoanRecordInLendingSystem',''));
                }
            }else {
                //__________info log Loan record does not associated with any Account______________//
                loggerList.add(LogManager.createLog(loanRec.Id, 'Info', null, null,'Account is not associated for this Loan record',
                                                    'LendingSystemIntegration', 'createLoanRecordInLendingSystem', ''));
            }
        }
        
        //_______________update loan records with loanid_____________//
        if(!updateList.isEmpty()) {
            ObjectManager.updateRecords(updateList, false);
        } 
        //_______________insert logs_________//
      
        if(!loggerList.isEmpty()) {
            ObjectManager.insertRecords(loggerList, false);
        } 
        return true;
    }
}