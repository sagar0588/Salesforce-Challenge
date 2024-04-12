################################ Readme

1)I have created a salesforce personal org to take this challenge(Personal Org 1)

2)As part of this challenge i have created below classes in Personal Org 1 and tested this with lending system and working as expected, During our review meeting i can show working model of this challenge end to end

		2.1)LoanIntegrationTrigger -- test coverage : 100%
		2.2)LoanIntegrationTriggerHandler -- test coverage : 100%
		2.3)LendingSystemIntegration -- test coverage : 81%
		2.4)LogManager  -- test coverage : 100%
		2.5)LendingSystemIntegrationWrapper -- test coverage :  100
		2.6)LendingSystemIntegrationHelper --  test coverage : 100
		2.7)HttpCalloutController  -- test coverage : 100
		2.8)ObjectManager  -- test coverage : 83
		2.9)LendingSystemIntegrationQueue  -- test coverage :  84
		2.10)LoanIntegrationTrigger_Test
		2.11)LendingIntegrationMock
	overall test coverage : 94
3)Created Infolog__c object to track log records.

4)I have implemented a queueable class because of salesforce 101 callout limitation and effectively managed integration with lending system, We can discuss more during our review.

5)I have also created one more salesforce personal org (Personal Org 2) to develop a relica of lending system, then created a connected app, Rest Resource class to accept the calls from Person Org1

6)In Personal Org1 i have created a Named Credential and Auth Provider to authenticate the connection before making the actual callouts, I can show this also during our review meeting.

7)Our Loan__c trigger can process large volume of records in bulk with out hitting Salesforce governor limits as mentioned below.
	7.1)When a Salesforce trigger process large volume of records it divide the records in to batches of size 200.
	7.2)Trigger process 200 records at a time even though we are inserting millions of records at a time.
	7.3)Here comes the limitation issue when we make callouts from trigger synchronously then we will hit salesforce limits of callouts :100
	7.4)To overcome this limitation i designed this solution to make callouts from Queueable by processing 100 records each time and chaining queuable
		one in another (We can discuss this in our review meeting)