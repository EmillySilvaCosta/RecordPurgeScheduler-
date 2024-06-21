global class PurgeRecordScheduler implements Schedulable {
    
    private PurgeRecordScheduler__mdt purgeRecordSettings;//um objeto de metadados personalizados
   //construtor
   public PurgeRecordScheduler(PurgeRecordScheduler__mdt purgeRecordSettings) {
       this.purgeRecordSettings = purgeRecordSettings;
   }
   
   public PurgeRecordScheduler() {
   }
   
   //metodo de execução exigido pelo schedule que define a lógica a ser executada quando a tarefa agendada é disparada
   global void execute(SchedulableContext sc) {
       PurgeRecordBatch batchToExecute = new PurgeRecordBatch(this.purgeRecordSettings);//cria uma instância PurgeRecordBatch usando as configurações armazenadas
       Database.executeBatch(batchToExecute);
   }
   //método que consulta até 100 registros
   public static void start() {
       List<PurgeRecordScheduler__mdt> purgeRecordList = [
           SELECT Id, sObjectName__c,RunAtSystemLevel__c, QueryFilter__c, PartialDelete__c,SendNotification__c, Active__c
           FROM PurgeRecordScheduler__mdt
           WHERE Active__c = true
           LIMIT 100  
       ];
       //Itera sobre cada registro retornado pela consulta.
       for(PurgeRecordScheduler__mdt purgeRecord : purgeRecordList){
           new ScheduleHelper()
               .scheduleIntoMinutesInterval(new PurgeRecordScheduler(purgeRecord), 5); //Agenda a execução da tarefa para um intervalo de 15 minutos usando um ScheduleHelper.
       }
       
       
   }
   //cancela as execuções agendadas do PurgeRecordScheduler
   public static void abort() {
       new ScheduleHelper().abort('PurgeRecordScheduler');
   }
   
   // Método adicional para injeção de dependência durante os testes
   public static void startTest(List<PurgeRecordScheduler__mdt> mockPurgeRecordList) {
       List<PurgeRecordScheduler__mdt> purgeRecordList;
       if (mockPurgeRecordList != null) {
           purgeRecordList = mockPurgeRecordList;
       } else {
           purgeRecordList = [
               SELECT Id, sObjectName__c, RunAtSystemLevel__c, QueryFilter__c, PartialDelete__c, SendNotification__c, Active__c
               FROM PurgeRecordScheduler__mdt
               WHERE Active__c = true
               LIMIT 100
           ];
       }
       for (PurgeRecordScheduler__mdt purgeRecord : purgeRecordList) {
           new ScheduleHelper()
               .scheduleIntoMinutesInterval(new PurgeRecordScheduler(purgeRecord), 15);
       }
   }
}