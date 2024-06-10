global class PurgeRecordScheduler implements Schedulable {
    
    private PurgeRecordScheduler__mdt purgeRecordSettings;
    
    public PurgeRecordScheduler(PurgeRecordScheduler__mdt purgeRecordSettings) {
        this.purgeRecordSettings = purgeRecordSettings;
    }
    
    
    
    global void execute(SchedulableContext sc) {
        PurgeRecordBatch batchToExecute = new PurgeRecordBatch(this.purgeRecordSettings);
        Database.executeBatch(batchToExecute);
    }
    
    public static void start() {
        List<PurgeRecordScheduler__mdt> purgeRecordList = [
            SELECT Id, sObjectName__c,RunAtSystemLevel__c, QueryFilter__c, PartialDelete__c,SendNotification__c, Active__c
            FROM PurgeRecordScheduler__mdt
            WHERE Active__c = true
            LIMIT 100  
        ];
        
        for(PurgeRecordScheduler__mdt purgeRecord : purgeRecordList){
            new ScheduleHelper()
                .scheduleIntoMinutesInterval(new PurgeRecordScheduler(purgeRecord), 15);
        }
        
        
    }
    
    public static void abort() {
        new ScheduleHelper().abort('PurgeRecordScheduler');
    }
}