public class SongTriggerHandler implements TriggerTemplate.Handler {
    
    private List<Song__c> newValues;
	private Map<Id, Song__c> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues)
	{
		this.newValues = (List<Song__c>)newValues;
		this.oldValues = (Map<Id, Song__c>)oldValues;
	}

    public void handle(TriggerTemplate.TriggerAction action) {
        Set<Id> songsWithMixesToBeUpdatedIdSet = new Set<Id>();

        if (action == TriggerTemplate.TriggerAction.afterupdate) {
            for (Song__c newSong: newValues) {
                if (newSong.Genre__c != oldValues.get(newSong.Id).Genre__c) {
                    songsWithMixesToBeUpdatedIdSet.add(newSong.Id);
                }
            }
        }

        Set<Id> mixesToUpdateIdSet = SongTriggerHelper.getMixesToUpdateGenres(songsWithMixesToBeUpdatedIdSet);

        MixService.updateMixesInfo(mixesToUpdateIdSet);
    }
}
