/*****************************************************************************************************
*  LoanIntegrationTrigger 
* @Description: Handles trigger on Loan__c object to synchronize the data with LendingSystem
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/

trigger LoanIntegrationTrigger on Loan__c (after insert, after update, before delete) {

    if(Trigger.isInsert && Trigger.isAfter) {
     //Call method to make callout to create Loan record in Lending System
      LoanIntegrationTriggerHandler.afterInsert(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter) {
     //Call method to make callout to create Loan record in Lending System
      LoanIntegrationTriggerHandler.afterUpdate(Trigger.new, Trigger.old);
    }
    if(Trigger.isDelete && Trigger.isBefore) {
     //Call method to make callout to create Loan record in Lending System
      LoanIntegrationTriggerHandler.beforeDelete(Trigger.old);
    }
}