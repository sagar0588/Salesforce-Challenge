/*****************************************************************************************************
*  LoanIntegrationTrigger_Test 
* @Description: Test class for LoanIntegrationTrigger 
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
@isTest
public class LoanIntegrationTrigger_Test {
    
    @testSetup
    private static void testSetup() {
        Account acc = new Account();
        acc.name = 'Loan Test';
        acc.AccountNumber = '123456';
        acc.AnnualRevenue = 1034.45;
        insert acc;
    }
    
    @isTest
    private static void testLoanTriggerCreateEvent() {
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE name = 'Loan Test'];
        List<Loan__c> loanRecList = new List<Loan__c>();
        
        Loan__c loanRec = new Loan__c();
        loanRec.Account__c = acc.Id;
        loanRec.Amount__c = 908.89;
        loanRecList.add(loanRec);
        
        
        test.setMock(HttpCalloutMock.class, new LendingIntegrationMock('success'));
        insert loanRecList;
        Loan__c createdLoanRec = [SELECT Id FROM Loan__c LIMIT 1];
        //assert the loan record is created
        Assert.areEqual(createdLoanRec != null, true);
    }
    
    @isTest
    private static void testLoanTriggerCreateEventException() {
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE name = 'Loan Test'];
        List<Loan__c> loanRecList = new List<Loan__c>();
      //  for(Integer i=0; i<=600; i++) {
            Loan__c loanRec = new Loan__c();
            loanRec.Account__c = acc.Id;
            loanRec.Amount__c = 908.89;
            loanRecList.add(loanRec);
     //   }
        
        test.setMock(HttpCalloutMock.class, new LendingIntegrationMock('fail'));
        insert loanRecList;
        Loan__c createdLoanRec = [SELECT Id FROM Loan__c LIMIT 1];
        //assert the loan record is not created due to exception
        Assert.areEqual(createdLoanRec != null,true);
   
    }
     @isTest
    private static void testLoanTriggerCreateEventNegitiveScenario() {
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE name = 'Loan Test'];
        List<Loan__c> loanRecList = new List<Loan__c>();
        Loan__c loanRec = new Loan__c();
        //loanRec.Account__c = acc.Id;//insert Loan record with empty Account as a negitive test case
        loanRec.Amount__c = 908.89;
        loanRecList.add(loanRec);
        
        insert loanRecList;
        Loan__c createdLoanRec = [SELECT Id FROM Loan__c LIMIT 1];
        //assert the loan record is not created due to exception but no callout is being made
        Assert.areEqual(createdLoanRec != null,true);
   
    }
     @isTest
    private static void testLoanTriggerCreateEventErrorResponse() {
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE name = 'Loan Test'];
        List<Loan__c> loanRecList = new List<Loan__c>();
        Loan__c loanRec = new Loan__c();
        loanRec.Account__c = acc.Id;
        loanRec.Amount__c = 908.89;
        loanRecList.add(loanRec);
        test.setMock(HttpCalloutMock.class, new LendingIntegrationMock('400'));
        insert loanRecList;
        Loan__c createdLoanRec = [SELECT Id FROM Loan__c LIMIT 1];
        //assert the loan record is not created due to exception but no callout is being made
        Assert.areEqual(createdLoanRec != null,true);
   
    }
    @isTest
    private static void testLoanTriggerUpdateEvent() {
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE name = 'Loan Test'];
        Loan__c loanRec = new Loan__c();
        loanRec.Account__c = acc.Id;
        loanRec.Amount__c = 909;
        insert loanRec;
        Loan__c updateLoan = [SELECT Id, Amount__c FROM Loan__c LIMIT 1];
        updateLoan.Amount__c = 100;
        test.setMock(HttpCalloutMock.class, new LendingIntegrationMock('success'));
        update updateLoan;
        Loan__c updatedLoanRec = [SELECT Id, Amount__c FROM Loan__c LIMIT 1];
        //Assert loan record is updated
        Assert.areEqual(updatedLoanRec.Amount__c == 100, true);

    }
    
    @isTest
    private static void testLoanTriggerDeleteEvent() {
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE name = 'Loan Test'];
        Loan__c loanRec = new Loan__c();
        loanRec.Account__c = acc.Id;
        loanRec.Amount__c = 910;
        insert loanRec;
        Loan__c deleteLoan = [SELECT Id, Amount__c FROM Loan__c WHERE Amount__c = 910 LIMIT 1];
        
        test.setMock(HttpCalloutMock.class, new LendingIntegrationMock('success'));
        delete deleteLoan;
        List<Loan__c> deletedLoanRec = [SELECT Id, Amount__c FROM Loan__c];
        //assert loan record is deleted
        Assert.areEqual(deletedLoanRec.isEmpty(), true);

    }
}