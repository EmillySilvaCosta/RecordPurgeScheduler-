@isTest
public class PurgeRecordSchedulerTest {

    @isTest
    static void testConstructor() {
        // Simulando os dados de metadados personalizados
        PurgeRecordScheduler__mdt purgeRecordSetting = new PurgeRecordScheduler__mdt();
        purgeRecordSetting.sObjectName__c = 'Account';
        purgeRecordSetting.RunAtSystemLevel__c = false;
        purgeRecordSetting.QueryFilter__c = 'LastModifiedDate < LAST_N_DAYS:30';
        purgeRecordSetting.PartialDelete__c = false;
        purgeRecordSetting.SendNotification__c = 'Always';
        purgeRecordSetting.Active__c = true;
        
        PurgeRecordScheduler scheduler = new PurgeRecordScheduler(purgeRecordSetting);
        System.assertNotEquals(null, scheduler, 'o objeto deve ser criado');
    }
    
    @isTest
    static void testExecute() {
        // Simulando os dados de metadados personalizados
        PurgeRecordScheduler__mdt purgeRecordSetting = new PurgeRecordScheduler__mdt();
        purgeRecordSetting.sObjectName__c = 'Account';
        purgeRecordSetting.RunAtSystemLevel__c = false;
        purgeRecordSetting.QueryFilter__c = 'LastModifiedDate < LAST_N_DAYS:30';
        purgeRecordSetting.PartialDelete__c = false;
        purgeRecordSetting.SendNotification__c = 'Always';
        purgeRecordSetting.Active__c = true;
        
        PurgeRecordScheduler scheduler = new PurgeRecordScheduler(purgeRecordSetting);
        
        // Simulando o batch execution
        Test.startTest();
        // Executa o método execute
         scheduler.execute(null);
        Test.stopTest();
        //Verifica se um novo lote de exclusão de registros foi criado consultando a tabela AsyncApexJob do Salesforce
        Integer batchJobsCount = [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ApexClass.Name = 'PurgeRecordBatch'];
        System.assertNotEquals(0, batchJobsCount, 'Batch job not created');
        
        
    }
    
   
    @isTest
    static void testStartMethod() {
        // Cria uma lista simulada de PurgeRecordScheduler__mdt com valores fictícios
        List<PurgeRecordScheduler__mdt> mockSettingsList = new List<PurgeRecordScheduler__mdt>();
        PurgeRecordScheduler__mdt settings = (PurgeRecordScheduler__mdt) Type.forName('PurgeRecordScheduler__mdt').newInstance();
        settings.sObjectName__c = 'Account';
        settings.QueryFilter__c = 'CreatedDate = LAST_N_DAYS:30';
        settings.PartialDelete__c = false;
        settings.RunAtSystemLevel__c = true;
        settings.SendNotification__c = 'Always';
        settings.Active__c = true;
        mockSettingsList.add(settings);
 
        Test.startTest();
        // Chama o método start() da classe PurgeRecordScheduler com a lista simulada
        PurgeRecordScheduler.startTest(mockSettingsList);
        Test.stopTest();
        // Verifica se os agendamentos foram criados consultando a tabela CronTrigger do Salesforce
        Integer scheduledJobsCount = [SELECT count() FROM CronTrigger WHERE CronJobDetail.Name LIKE 'PurgeRecordScheduler%'];
        System.assertNotEquals(0, scheduledJobsCount, 'Scheduled jobs not created');
    }

    
    @isTest
    static void testAbort() {
        Test.startTest();
        PurgeRecordScheduler.abort();
        Test.stopTest();
        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name LIKE 'PurgeRecordScheduler%'];
        System.assert(scheduledJobs.isEmpty(), 'Todas as tarefas devem ser abortadas');
        
    }


}