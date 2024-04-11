/*****************************************************************************************************
*  LendingIntegrationMock 
* @Description: class to mock the lending integration response
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class LendingIntegrationMock implements HttpCalloutMock {
    public String flag;
    public LendingIntegrationMock(String flag) {
        this.flag = flag;
    }
    
    public HTTPResponse respond(HTTPRequest req){ 
        Map<String, String> responseMap = new Map<String, String>();
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        responseMap.put('loanId','loan-000001');
        String resBody = JSON.serialize(responseMap);
        if(flag == 'success') {
            response.setBody(resBody);  
        }
        if(flag == '400') {
            response.setStatusCode(400);
        }else {
            response.setStatusCode(201);
        }
        return response; 
        
    }
}