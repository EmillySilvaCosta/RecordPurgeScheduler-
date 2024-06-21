@isTest
private class ScheduleHelperTest {
    @isTest
    static void testScheduleIntoMinutesInterval() {
        ScheduleHelper scheduleHelper = new ScheduleHelper();
        SchedulableMock service = new SchedulableMock();
        
        // Agendar trabalhos com intervalo de 5 minutos
        scheduleHelper.scheduleIntoMinutesInterval(service, 5);
        
        // Verificar se os trabalhos foram agendados
        List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger];
        System.assertEquals(15, jobs.size(), 'Deveria ter 15 trabalhos agendados.');
        
        // Verificar se os nomes dos trabalhos são únicos
        Set<String> jobNames = new Set<String>();
        for (CronTrigger job : jobs) {
            System.assert(!jobNames.contains(job.CronJobDetail.Name), 'Nome do trabalho deve ser único.');
            jobNames.add(job.CronJobDetail.Name);
        }
    }

    // Mock class para Schedulable
    public class SchedulableMock implements Schedulable {
        public void execute(SchedulableContext ctx) {
        }
    }
}