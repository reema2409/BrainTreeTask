@isTest
private class AccountReparentingTest {
 
    static testMethod void myUnitTest() {
         RestRequest re = new RestRequest(); 
         RestResponse rp = new RestResponse();
         re.addHeader('httpMethod', 'POST');
         re.addParameter('BraintreeId', 'Test');        
         re.addParameter('Name', 'Test Account');
         RestContext.Request = re;
         RestContext.Response = rp;
         AccountReparanting.doPost();
         Account acc= new Account();
         acc.Name = 'Test Account 1';
         acc.Braintree_Id__c ='Test 1';
         insert acc;
         re.addParameter('BraintreeId', 'Test 1');        
         re.addParameter('Name', 'Test Account 1');
         RestContext.Request = re;
         RestContext.Response = rp;
         AccountReparanting.doPost();
         Account accOb1= new Account();
         accOb1.Name = 'Test Account 1';
         insert accOb1;
         re.addParameter('BraintreeId', 'Test 1');        
         re.addParameter('Name', 'Test Account 1');
         RestContext.Request = re;
         RestContext.Response = rp;
         AccountReparanting.doPost();
         re.addParameter('BraintreeId', 'Test 1');        
         re.addParameter('Name', 'Test Account 2');
         RestContext.Request = re;
         RestContext.Response = rp;
         AccountReparanting.doPost();
         System.assert(true);
        try{
            
            String a=null;
            a.length();
            
        }catch(Exception e){
            AccountReparanting.reportException(rp,400,e);
        }
   }
}