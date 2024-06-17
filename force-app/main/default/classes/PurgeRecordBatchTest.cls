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
    static void testExecuteMethod() {
        
        PurgeRecordScheduler__mdt prs = new PurgeRecordScheduler__mdt();
        prs.sObjectName__c = 'Account';
        prs.QueryFilter__c = 'name != \'1\'';
        prs.PartialDelete__c = false;
        prs.RunAtSystemLevel__c = true;
        prs.SendNotification__c = 'Always';
        prs.Active__c = true;
        
        
        Test.startTest(); 
        PurgeRecordBatch b = new PurgeRecordBatch(prs);  
        b.execute(null, null); 
        Database.executeBatch(b, 10000); 
        Test.stopTest(); 


         // Verificação se os registros foram excluídos conforme o esperado
         Integer recordCount = [SELECT COUNT() FROM Account WHERE name != '1'];
    	 System.assertEquals(0, recordCount, 'Records were not deleted as expected.');
             
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
