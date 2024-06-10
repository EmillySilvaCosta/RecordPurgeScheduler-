@isTest
public class PurgeRecordBatchTest {

    @isTest
    //Verifica se a consulta SOQL é gerada corretamente com as configurações válidas
    static void testQueryGeneration() {
        
        PurgeRecordScheduler__mdt settings = new PurgeRecordScheduler__mdt(
            sObjectName__c = 'Account',
            QueryFilter__c = 'CreatedDate = LAST_N_DAYS:30', 
            PartialDelete__c = false,
            RunAtSystemLevel__c = true,
            SendNotification__c = 'Always'
        );
        
        PurgeRecordBatch batch = new PurgeRecordBatch(settings);

        Test.startTest();
        String query = batch.getQueryString();
        Test.stopTest();

        System.assertEquals('SELECT Id FROM Account WHERE CreatedDate = LAST_N_DAYS:30', query);
    }

    @isTest
    //Garante que o método start retorne um Database.QueryLocator
    static void testStartMethod() {
    
        PurgeRecordScheduler__mdt settings = new PurgeRecordScheduler__mdt(
            sObjectName__c = 'Account',
            QueryFilter__c = 'CreatedDate = LAST_N_DAYS:30',
            PartialDelete__c = false,
            RunAtSystemLevel__c = true,
            SendNotification__c = 'Always'
        );
     
        PurgeRecordBatch batch = new PurgeRecordBatch(settings);

        Test.startTest();
        Database.QueryLocator ql = batch.start(null);
        Test.stopTest();

        System.assertNotEquals(null, ql);
    }

    @isTest
    //Verifica se o método execute exclui registros conforme o esperado
    static void testExecuteMethod() {
        
        PurgeRecordScheduler__mdt settings = new PurgeRecordScheduler__mdt(
            sObjectName__c = 'Account',
            QueryFilter__c = 'CreatedDate = LAST_N_DAYS:30',
            PartialDelete__c = false,
            RunAtSystemLevel__c = true
        );
        
        
        PurgeRecordBatch batch = new PurgeRecordBatch(settings);
        
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        Test.startTest();
        batch.execute(null, accounts);
        Test.stopTest();

        Integer count = [SELECT count() FROM Account WHERE Name LIKE 'Test Account%'];
        System.assertEquals(0, count);
    }

    @isTest
    //Garante que uma exceção é lançada quando sObjectName__c não é fornecido
    static void testMissingObjectName() {
        
        PurgeRecordScheduler__mdt settings = new PurgeRecordScheduler__mdt(
            sObjectName__c = '',
            QueryFilter__c = 'CreatedDate = LAST_N_DAYS:30',
            PartialDelete__c = false,
            RunAtSystemLevel__c = true
        );
        
        PurgeRecordBatch batch = new PurgeRecordBatch(settings);

        Test.startTest();
        try {
            batch.getQueryString();
            System.assert(false, 'Expected PurgeRecordBatchException was not thrown.');
        } catch (PurgeRecordBatch.PurgeRecordBatchException e) {
            System.assertEquals('Error - no SObject Name provided.', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    //Garante que uma exceção é lançada quando um objeto inexistente é fornecido
    static void testNonExistentObject() {
 
        PurgeRecordScheduler__mdt settings = new PurgeRecordScheduler__mdt(
            sObjectName__c = 'NonExistentObject',
            QueryFilter__c = 'CreatedDate = LAST_N_DAYS:30',
            PartialDelete__c = false,
            RunAtSystemLevel__c = true
        );
        
        PurgeRecordBatch batch = new PurgeRecordBatch(settings);
        
        Test.startTest();
        try {
            batch.getQueryString();
            System.assert(false, 'Expected PurgeRecordBatchException was not thrown.');
        } catch (PurgeRecordBatch.PurgeRecordBatchException e) {
            System.assertEquals('Object not found. Please make sure that you are providing the correct API name.', e.getMessage());
        }
        Test.stopTest();
    }
}
