/*****************************************************************************************************
*  ObjectManager 
* @Description: Generic Class to make DML operations
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public inherited sharing class ObjectManager {
    
    //_____ insertRecords  ______________________________________________
    public static boolean insertRecords(List<sObject> records, boolean allOrNone){
        System.debug('*** ObjectManager.insertRecords'); 
        boolean isSuccess;
        Database.SaveResult[] srList;
        try {
            srList = Database.insert(records, allOrNone);  
        }catch (Exception ex) {         
            System.Debug('** Exception ' + ex.getMessage()); 
        }      
        //_____ Process Database Results ___________________________________                                    
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Id: ' + sr.getId());
                isSuccess = True;
            }//if
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }//for
                isSuccess = false;
            }//if (sr.isSuccess())
        }//for                                                  
        return isSuccess;      
    }//insertRecords
    
    //_____ updateRecords  ______________________________________________
    public static boolean updateRecords(Sobject[] records, boolean allOrNone){
        System.debug('*** ObjectManager.updateRecords'); 
        
        boolean isSuccess;
        Database.SaveResult[] srList;
        try {
            srList = Database.update(records, allOrNone);  
        }catch (Exception e) {         
            System.Debug('** Exception ' + e ); 
        }// end try        
        //_____ Process Database Results ___________________________________                                    
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated Id: ' + sr.getId());
                isSuccess = true;
            }//if
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }//for
                isSuccess = false;
            }//if (sr.isSuccess())
        }//for                                                  
        return isSuccess;      
    }//updateRecords
}