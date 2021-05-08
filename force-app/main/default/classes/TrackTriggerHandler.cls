public class TrackTriggerHandler implements TriggerTemplate.Handler {
    private List<Track__c> newValues;
	private Map<Id, Track__c> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues)
	{
		this.newValues = (List<Track__c>)newValues;
		this.oldValues = (Map<Id, Track__c>)oldValues;
	}
    
    public void handle(TriggerTemplate.TriggerAction action) {
        if (action == TriggerTemplate.TriggerAction.afterinsert) {
            Set<Id> songToUpdateIds = new Set<Id>();
            Set<Id> mixesToUpdateIds = new Set<Id>();
            
            for (Track__c track: newValues) {
                songToUpdateIds.add(track.Song__c);
                mixesToUpdateIds.add(track.Mix__c);
            }

            //Service classes call
        }

        if (action == TriggerTemplate.TriggerAction.afterupdate) {
            Set<Id> songToUpdateIds = new Set<Id>();
            Set<Id> mixesToUpdateIds = new Set<Id>();

            for (Track__c newTrack: newValues) {
                if(newTrack.Song__c != oldValues.get(newTrack.Id).Song__c) {
                    songToUpdateIds.add(newTrack.Song__c);
                    songToUpdateIds.add(oldValues.get(newTrack.Id).Song__c);

                    mixesToUpdateIds.add(newTrack.Mix__c);
                    mixesToUpdateIds.add(oldValues.get(newTrack.Id).Mix__c);

                }
            }

            //Service class call
        }

        if (action == TriggerTemplate.TriggerAction.afterdelete) {
            Set<Id> songToUpdateIds = new Set<Id>();
            Set<Id> mixesToUpdateIds = new Set<Id>();

            for (Track__c track: oldValues.values()) {
                songToUpdateIds.add(track.Song__c);
                mixesToUpdateIds.add(track.Mix__c);
            }

            //Service call
        }
    }
}
