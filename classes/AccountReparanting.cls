@RestResource(urlMapping='/AccountReparanting/*')
global with sharing class AccountReparanting{

  
  @HttpPost
    global static void doPost() {
        
        RestRequest req = RestContext.request;
        String braintreeId = req.params.get('BraintreeId'); // Fetching the braintree id from the request
        String accName = req.params.get('Name');
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String jsonResponse = '';
        //Fetching the list of accounts based on braintree Id
        List<Account> accList = [select id,name from Account where Braintree_Id__c = :braintreeId limit 1];
       
        if(accList != null && !accList.isEmpty()){
           // If account list is notnull and empty ,then fetch the first record from the account list.
            String accId = accList.get(0).Id;
          //  Based on the account Id try to fetch the parent account
            List<Account> parentAccList = [select id,Name from Account where name =:accName and Braintree_Id__c != :braintreeId and ParentId = '' limit 1];
            
            if(parentAccList != null && !parentAccList.isEmpty()){
               // If Parent Account Exists then link both the parent and child accounts through parent id.
                Account accOb = new Account();
                accOb.Id = accId;
                accOb.ParentId = parentAccList.get(0).Id;
                
                try{
                 //Update the account and set the response status   
                    update accOb;
                    res.statusCode = 200;
                    jsonResponse = '{"response": {"status": "Success", "message": "Account updated successfully!"}}';
                    res.responseBody = blob.valueOf(jsonResponse);
                    return;
                    
                }catch(Exception e){
                //Lock the error and set response status accordingly
                    System.debug(LoggingLevel.Error,e.getMessage());
                    reportException(res,400,e);
                    return;
                }
            }
        
        }else{
        
           // Fetch Account List based on account name            
            List<Account> accByName = [select id,name from Account where name = :accName];
            
            Account accOb = new Account();
            accOb.Name = accName;
            
            if(accByName != null && !accByName.isEmpty()){
               // Set the parentid to this account
                accOb.ParentId = accByName.get(0).Id; 
            }
            
            try{
               // Insert a new account and set the response status and response message in the response body. 
                insert accOb;
                res.statusCode = 200;
                jsonResponse = '{"response": {"status": "Success", "message": "Account created successfully!"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
                
            }catch(Exception e){
                //Set the response status accordingly
                System.debug(LoggingLevel.Error,e.getMessage());
               	reportException(res,400,e);
                return;
            
            }
        
        
            
        
        }
        
    }
    // Static Method to report exception in the response body.
    global static RestResponse reportException(RestResponse res,Integer code,Exception e){
        res.statusCode = code;
        String jsonResponse = '{"response": {"status": "Failure", "message": "'+e.getMessage()+'"}}';
        res.responseBody = blob.valueOf(jsonResponse);
        return res;
    }
}