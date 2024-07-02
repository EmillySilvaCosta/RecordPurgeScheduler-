public with sharing class AccountCreatObjects {
    public static void createAccount(Integer numberOfAccounts){
        
        List<Account> accL = new List<Account>();
        for(Integer i=0; i<numberOfAccounts; i++){
            Account acc = new Account();
            acc.Name = 'TesteAccount' + i;
            acc.Active__c = 'Yes';
            acc.Site = 'email' + i + '@example.com';
            acc.Phone = '5544886578' + i;
            accL.add(acc);
        }
     try{
        insert accL;
        System.debug('Successfully inserted ' + numberOfAccounts + ' accounts.');
    } catch (DmlException e) {
        System.debug('Error inserting accounts: ' + e.getMessage());
    }
   
   }
}