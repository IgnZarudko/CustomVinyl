trigger TrackTrigger on Track__c (after insert, after update, after delete) {
    TriggerTemplate.TriggerManager triggerManager = new TriggerTemplate.TriggerManager();
    
    triggerManager.addHandler(new TrackTriggerHandler(), new List<TriggerTemplate.TriggerAction>{
        TriggerTemplate.TriggerAction.afterinsert, 
        TriggerTemplate.TriggerAction.afterdelete
    });

    triggerManager.runHandlers();
}