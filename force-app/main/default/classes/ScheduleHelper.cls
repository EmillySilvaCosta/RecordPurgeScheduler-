public class ScheduleHelper {
    public static Integer jobCountForTest = 0;
  
    public ScheduleHelper() {
    }
  
    public void scheduleIntoMinutesInterval(
      Schedulable service,
      Integer minuteInterval
    ) {
      String cronExpression = ' * * * ?';
      Integer i = 0;
      String executionMinute = '';
      while (i < 60) {
        if (i < 10)
          executionMinute = '0';
  
        executionMinute += i;
  
        System.schedule(
          getServiceName(service) +
          '  ' +
          jobCountForTest +
          executionMinute,
          '0 ' +
          executionMinute +
          cronExpression,
          service
        );
  
        i += minuteInterval;
  
        executionMinute = '';
      }
    }
  
     
    public void abort(String jobName) {
      for (CronTrigger cron : findJobsByName(jobName)) {
        System.abortJob(cron.id);
      }
    }
  
    public List<CronTrigger> findJobsByName(String jobName) {
      return [
        SELECT Id, CronJobDetail.Name
        FROM CronTrigger
        WHERE CronJobDetail.Name LIKE :(jobName + '%')
      ];
    }
  
    @TestVisible
    private String getServiceName(Schedulable service) {
      return String.valueOf(service)
        .substring(0, String.valueOf(service).indexOf(':'));
    }

}