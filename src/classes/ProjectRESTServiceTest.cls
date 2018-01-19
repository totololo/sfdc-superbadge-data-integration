@isTest
private class ProjectRESTServiceTest {

  @testSetup static void testSetupdata(){
    Opportunity opp = New Opportunity(Name='Test Opp', StageName='Prospecting',CloseDate=System.today());
    insert opp;
  }

  @isTest static void testPostProjectDataSucceed(){
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp' Limit 1];

    String projectRef = 'p-001';
    String projectName ='project 1';
    String opportunityId = String.valueOf(opp.Id);
    Date startDate = Date.today();
    Date endDate = startDate.addDays(10);
    Double amount = 10000;
    String status='Running';

    Test.startTest();
    ProjectRESTService.postProjectData(projectRef,projectName,opportunityId,startDate,endDate,amount,status);
    Test.stopTest();

    Opportunity verifyOpportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opportunityId];
    System.assertEquals('In progress', String.valueOf(opportunity.DeliveryInstallationStatus__c));
    List<Project__c> projectList = [SELECT Id FROM Project__c];
    System.assertEquals(1, projectList.size());
  }

  @isTest static void testPostProjectDataFailure(){
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp' Limit 1];

    String projectRef = 'p-002';
    String projectName ='project 2';
    String opportunityId = String.valueOf(opp.Id);
    Date startDate = Date.today();
    Date endDate = startDate.addDays(10);
    Double amount = 10000;
    String status='Something Wrong';

    Test.startTest();
    ProjectRESTService.postProjectData(projectRef,projectName,opportunityId,startDate,endDate,amount,status);
    Test.stopTest();

    Opportunity verifyOpportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opportunityId];
    System.assertNotEquals('In progress', String.valueOf(opportunity.DeliveryInstallationStatus__c));
    List<Project__c> projectList = [SELECT Id FROM Project__c];
    System.assertEquals(0, projectList.size());
  }

}
