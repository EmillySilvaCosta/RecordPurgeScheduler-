@istest
public class PurgeRecordBatchTest {
	@istest
    static void testPurgeEventLogLinkBatchTest() {
     
        PurgeRecordScheduler__mdt prs = new PurgeRecordScheduler__mdt();
        prs.sObjectName__c ='Account';
        prs.Active__c = true;
        prs.PartialDelete__c = false;
        prs.QueryFilter__c = ' name != \'1\' ';
        prs.RunAtSystemLevel__c = true;
        prs.SendNotification__c = 'Always';
        
        Test.startTest();
        PurgeRecordBatch b = new PurgeRecordBatch(prs);
        b.execute(null, null);
        Database.executeBatch(b, 10000);
        Test.stopTest();
    }
}