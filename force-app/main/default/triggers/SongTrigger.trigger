trigger SongTrigger on Song__c (after update) {
    TriggerTemplate.TriggerManager triggerManager = new TriggerTemplate.TriggerManager();

    triggerManager.addHandler(new SongTriggerHandler(), new List<TriggerTemplate.TriggerAction>{
        TriggerTemplate.TriggerAction.afterupdate
    });

    triggerManager.runHandlers();
}