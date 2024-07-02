@isTest
public with sharing class AccountCreatObjectsTest {
    @isTest
    public static void createAccountTest(){
       // Defina o número de contas que deseja criar
        Integer numberOfAccounts = 5;
        
        // Chame o método para criar contas
        AccountCreatObjects.createAccount(numberOfAccounts);
        
        // Consulte as contas criadas
        List<Account> accounts = [SELECT Name, Active__c, Site, Phone FROM Account WHERE Name LIKE 'TesteAccount%'];
        
        // Verifique se o número correto de contas foi criado
        System.assertEquals(numberOfAccounts, accounts.size(), 'O número de contas criadas está incorreto.');
        
        // Verifique os valores dos campos das contas criadas
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = accounts[i];
            System.assertEquals('TesteAccount' + i, acc.Name, 'O campo Name está incorreto.');
            System.assertEquals('Yes', acc.Active__c, 'O campo Active__c está incorreto.');
            System.assertEquals('email' + i + '@example.com', acc.Site, 'O campo Site está incorreto.');
            System.assertEquals('5544886578' + i, acc.Phone, 'O campo Phone está incorreto.');
        }
    }
}