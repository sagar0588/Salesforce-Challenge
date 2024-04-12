/*****************************************************************************************************
*  LendingSystemIntegrationWrapper 
* @Description: Wrapper class to prepare json body
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LendingSystemIntegrationWrapper {
   public String operation;// 'I', 'U', 'D'
   public String accountNumber; //'123456',
   public Double amount;// 1000
   public String loanId;
}