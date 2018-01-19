public class BillingCalloutService {

  public static void callBillingService(List<Project__c> newList, Map<Id, Project__c> newMap, List<Project__c> oldList, Map<Id, Project__c> oldMap){

    if(!newList.isEmpty()) {
      Project__c project = newList[0];
      if (project.Status__c == 'Billable' && oldMap.get(project.Id).Status__c != 'Billable') {
        ServiceCredentials__c credentials = ServiceCredentials__c.getInstance('BillingServiceCredential');
        billProject(project.ProjectRef__c, project.Billable_Amount__c, credentials.Username__c, credentials.Password__c);
      }
    }
  }

  @future(callout=true)
  private static void billProject(String projectRef, Decimal billAmount, String username, String password) {

    BillingServiceProxy.project project = new BillingServiceProxy.project();
    project.projectRef = projectRef;
    project.billAmount = billAmount;
    project.username = username;
    project.password = password;

    BillingServiceProxy.InvoicesPortSoap11 invoicePortSoap11 = new BillingServiceProxy.InvoicesPortSoap11();
    String response = invoicePortSoap11.billProject(project);

    if(response != null && response.equalsIgnoreCase('OK')) {
      List<Project__c> projects = [SELECT Id, Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
      if(!projects.isEmpty()) {
        projects[0].Status__c = 'Billed';
        update projects;
      }
    }
  }
}
