global class PurgeRecordBatch implements Database.Batchable<sObject> {
    
    public class PurgeRecordBatchException extends Exception {}
    private PurgeRecordScheduler__mdt purgeRecordSettings;
    
    
    public string getQueryString()
    {
        if(purgeRecordSettings ==null){ return '';}
        String query='SELECT Id FROM ';
        if(String.isBlank(purgeRecordSettings.sObjectName__c))
        {
            throw new PurgeRecordBatchException('Error - no SObject Name provided.');
        }
        else
        {
            if(Schema.getGlobalDescribe().get(purgeRecordSettings.sObjectName__c.toLowerCase())==null)
                throw new PurgeRecordBatchException('Object not found. Please make sure that you are providing the correct API name.');
            query += purgeRecordSettings.sObjectName__c;
        }
        if(String.isNotBlank(purgeRecordSettings.QueryFilter__c))
           	query+= ' WHERE ' + purgeRecordSettings.QueryFilter__c;  
        system.debug('!!!!!!'+query);
        return query;
                 
    }
    
    public PurgeRecordBatch(PurgeRecordScheduler__mdt purgeRecordSettings){
        this.purgeRecordSettings = purgeRecordSettings;
    } 
   
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.getQueryString());   
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> records){
        try{
            System.debug('PurgeRecordBatch Lines affected: ' + records.size());
            Database.delete(records,purgeRecordSettings.PartialDelete__c,purgeRecordSettings.RunAtSystemLevel__c == true? AccessLevel.SYSTEM_MODE : AccessLevel.USER_MODE);
        }catch(Exception ex){
            System.debug('PurgeRecordBatch Error ' + ex.toString());
        }
    }    
    global void finish(Database.BatchableContext bc){
        
	}
}