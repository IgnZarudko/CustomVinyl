public class SongTriggerHelper {
    public static Set<Id> getMixesToUpdateGenres(Set<Id> songsWithMixesToBeUpdatedIdSet) {
        List<Song__c> songsWithMixesToBeUpdated = [SELECT Id, 
                                                    (SELECT Mix__c FROM Tracks__r)
                                                    FROM Song__c
                                                    WHERE Id IN :songsWithMixesToBeUpdatedIdSet];

        Set<Id> mixesToUpdateIdSet = new Set<Id>();                                                

        for(Song__c song: songsWithMixesToBeUpdated) {
            for(Track__c track: song.Tracks__r) {
                mixesToUpdateIdSet.add(track.Mix__c);
            }
        }

        return mixesToUpdateIdSet;
    }
}
