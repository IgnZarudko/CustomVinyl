public class MixService {
    public static void updateMixesInfo(Set<Id> mixesToUpdateIdSet) {
        List<Mix__c> mixesToUpdateList = [SELECT Id, 
                                                    Primary_Genre__c, 
                                                    Secondary_Genre__c, 
                                                    Duration__c,
                                                    Song_Amount__c,
                                                    (SELECT Song__r.Genre__c, Song__r.Duration__c FROM Tracks__r)
                                            FROM Mix__c
                                            WHERE Id IN :mixesToUpdateIdSet];

        for (Mix__c mix: mixesToUpdateList) {
            Map<String, Integer> genresAndAmount = getGenresAndAmount(mix);
            
            mix = getMixWithRecountedDuration(mix);

            mix = getMixWithRecountedGenres(mix, genresAndAmount);
        }

        update mixesToUpdateList;
    }

    private static Mix__c getMixWithRecountedDuration(Mix__c mix) {
        mix.Song_Amount__c = mix.Tracks__r.size();

        Decimal mixDuration = 0.0;
        
        for(Track__c track: mix.Tracks__r) {
            mixDuration += track.Song__r.Duration__c;
        }

        mix.Duration__c = mixDuration;

        return mix;
    }

    private static Mix__c getMixWithRecountedGenres(Mix__c mix, Map<String, Integer> genresAndAmount) {
        Integer primaryGenreCount = 0;
        String primaryGenre;

        Integer secondaryGenreCount = 0;
        String secondaryGenre;

        for (String key: genresAndAmount.keySet()) {
            if (primaryGenreCount < genresAndAmount.get(key)) {
                secondaryGenreCount = primaryGenreCount;
                secondaryGenre = primaryGenre;

                primaryGenreCount = genresAndAmount.get(key);
                primaryGenre = key;
            }
            else if (primaryGenreCount == genresAndAmount.get(key)) {
                secondaryGenreCount = genresAndAmount.get(key);
                secondaryGenre = key;
            }
            else if (secondaryGenreCount < genresAndAmount.get(key)) {
                secondaryGenreCount = genresAndAmount.get(key);
                secondaryGenre = key;
            }
        }

        mix.Primary_Genre__c = primaryGenre;
        mix.Secondary_Genre__c = secondaryGenre;

        return mix;
    }

    private static Map<String, Integer> getGenresAndAmount(Mix__c mix) {

        Map<String, Integer> genresWithAmount = new Map<String,Integer>();

        for(Track__c track: mix.Tracks__r) {
            String genre = track.Song__r.Genre__c;
            if (genresWithAmount.keySet().contains(genre)) {
                genresWithAmount.put(genre, genresWithAmount.get(genre) + 1);
            }
            else {
                genresWithAmount.put(genre, 1);
            }
        }

        return genresWithAmount;
    }
}   
