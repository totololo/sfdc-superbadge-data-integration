trigger ProjectTrigger on Project__c (after update) {
  if (trigger.isAfter && trigger.isUpdate) {
    BillingCalloutService.callBillingService(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
  }
}
