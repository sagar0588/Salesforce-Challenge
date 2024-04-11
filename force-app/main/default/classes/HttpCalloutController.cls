/*****************************************************************************************************
*  HttpCalloutController 
* @Description: Generic Class to make Http Callouts 
* @Author: Vedananda Sagar
* @Created Date: 29-03-2024
* @Version History:
* -----------------------------------------------------------------------
* Version 1.1 - 
**************************************************************************/
public class HttpCalloutController {
    
    //Generic class to make http Callouts
    
    public static Map<String, Object> makeHttpCallout(String reqBody, String namedCredential) {
        Map<String, Object> reqResMap = new Map<String, Object>();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:'+namedCredential);//generic
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setBody(reqBody);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        reqResMap.put('request',req);
        reqResMap.put('response',res);
        return reqResMap;
    }

}