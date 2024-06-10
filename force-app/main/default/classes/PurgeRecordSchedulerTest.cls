@isTest
public class PurgeRecordSchedulerTest {
    
    @isTest
    static void processErrorEvents() {

       // PurgeRecordScheduler job = new PurgeRecordScheduler();
        ScheduleHelper helper = new ScheduleHelper();

        Test.startTest();


        PurgeRecordScheduler.start();

        List<CronTrigger> cronTriggers = helper.findJobsByName('PurgeRecordScheduler');

        System.assert(cronTriggers.size() > 0);

        PurgeRecordScheduler.abort();


        Test.stopTest();


    }
}