/*****************************************************************************************************
*  ObjectManager 
* @Description: Generic Class to create/update Log records
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LogManager {
  
    //Method to prepare log records for insertion from calling method
    public static LogInfo__c createLog(String recordId, String type, String request, HttpResponse response, 
                                       String Description, String className, String methodName, String stackTrace) {
        //create success log
        LogInfo__c logRec = new LogInfo__c();
        logRec.Record_Id__c = recordId;
        logRec.Log_Type__c = type;
        if(response != null) {
            logRec.Status_Code__c = String.valueOf(response.getStatusCode());
            logRec.HttpResponse__c = String.valueOf(response);
        }
        if(request != null) {
            logRec.HttpRequest__c = String.valueOf(request);
        }
        logRec.Description__c = Description;
        logRec.class__c = className;
        logRec.method__c = methodName;
        logRec.Stack_Trace__c = stackTrace;
        return logRec;
    }
}