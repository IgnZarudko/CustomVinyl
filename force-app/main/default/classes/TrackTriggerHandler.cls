public class TrackTriggerHandler implements TriggerTemplate.Handler {
    private List<Track__c> newValues;
	private Map<Id, Track__c> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues)
	{
		this.newValues = (List<Track__c>)newValues;
		this.oldValues = (Map<Id, Track__c>)oldValues;
	}
    
    public void handle(TriggerTemplate.TriggerAction action) {
        Set<Id> songsToUpdateIdSet = new Set<Id>();
        Set<Id> mixesToUpdateIdSet = new Set<Id>();

        if (action == TriggerTemplate.TriggerAction.afterinsert) {            
            for (Track__c track: newValues) {
                songsToUpdateIdSet.add(track.Song__c);
                mixesToUpdateIdSet.add(track.Mix__c);
            }
        }

        if (action == TriggerTemplate.TriggerAction.afterupdate) {
            for (Track__c newTrack: newValues) {
                if(newTrack.Song__c != oldValues.get(newTrack.Id).Song__c) {
                    songsToUpdateIdSet.add(newTrack.Song__c);
                    songsToUpdateIdSet.add(oldValues.get(newTrack.Id).Song__c);

                    mixesToUpdateIdSet.add(newTrack.Mix__c);
                    mixesToUpdateIdSet.add(oldValues.get(newTrack.Id).Mix__c);

                }
            }
        }

        if (action == TriggerTemplate.TriggerAction.afterdelete) {
            for (Track__c track: oldValues.values()) {
                songsToUpdateIdSet.add(track.Song__c);
                mixesToUpdateIdSet.add(track.Mix__c);
            }
        }

        SongService.updateTrackCount(songsToUpdateIdSet);
        MixService.updateMixesGenres(mixesToUpdateIdSet);
    }
}
