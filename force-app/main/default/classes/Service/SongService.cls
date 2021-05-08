public class SongService {
    public static void updateTrackCount(Set<Id> songsToUpdateIdSet) {
        if (songsToUpdateIdSet.isEmpty()) {
            return;
        }

        List<Song__c> songsToUpdateList = [SELECT Id, 
                                                    Track_Amount__c, 
                                                    (SELECT Id FROM Tracks__r) 
                                            FROM Song__c
                                            WHERE Id IN :songsToUpdateIdSet];

        for (Song__c song: songsToUpdateList) {
            song.Track_Amount__c = song.Tracks__r.size();
        }

        update songsToUpdateList;
    }
}
