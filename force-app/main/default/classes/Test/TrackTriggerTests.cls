@isTest
public class TrackTriggerTests {
    @testSetup
    public static void createData() {
        Song__c hipHop1 = new Song__c(Artist__c = 'name1', Name = 'hip_hop_1', Duration__c = 2.42, Genre__c = 'Hip hop', Track_Amount__c = 1, Track_Licenses__c = 3);
        Song__c hipHop2 = new Song__c(Artist__c = 'name1', Name = 'hip_hop_2', Duration__c = 3.37, Genre__c = 'Hip hop', Track_Amount__c = 0, Track_Licenses__c = 3);
        Song__c hipHop3 = new Song__c(Artist__c = 'name1', Name = 'hip_hop_3', Duration__c = 3.45, Genre__c = 'Hip hop', Track_Amount__c = 0, Track_Licenses__c = 3);

        Song__c rock1 = new Song__c(Artist__c = 'name1', Name = 'rock_1', Duration__c = 4.17, Genre__c = 'Rock', Track_Amount__c = 0, Track_Licenses__c = 3);
        Song__c rock2 = new Song__c(Artist__c = 'name1', Name = 'rock_2', Duration__c = 4.21, Genre__c = 'Rock', Track_Amount__c = 0, Track_Licenses__c = 3);
        
        Mix__c mixWithTracks = new Mix__c(Name = 'Mix One');
        Mix__c mixWithoutTracks = new Mix__c(Name = 'Mix Two');

        insert new List<SObject> {
            hipHop1,
            hipHop2,
            hipHop3,
            rock1,
            rock2,
            mixWithTracks, 
            mixWithoutTracks
        };
        
        insert new List<Track__c> {
            new Track__c(Song__c = hipHop1.Id, Mix__c = mixWithTracks.Id)
        };
    }

    @isTest
    public static void trackAmountIsChangedAfterInsertTest() {
        Song__c hipHop1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_1' LIMIT 1];
        Mix__c mixWithoutSongs = [SELECT Id, Song_Amount__c, Primary_Genre__c, Secondary_Genre__c FROM Mix__c WHERE Name = 'Mix Two' LIMIT 1];

        Decimal trackAmountExpected = hipHop1.Track_Amount__c + 1;

        Test.startTest();

            Track__c newTrack = new Track__c(Song__c = hipHop1.Id, Mix__c = mixWithoutSongs.Id);
            insert newTrack;

        Test.stopTest();

        hipHop1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_1' LIMIT 1];
        mixWithoutSongs = [SELECT Id, Song_Amount__c, Primary_Genre__c, Secondary_Genre__c FROM Mix__c WHERE Name = 'Mix One' LIMIT 1];

        System.assertEquals(trackAmountExpected, hipHop1.Track_Amount__c, 'Track amount is not like expected');
    }

    @isTest
    public static void trackAmountIsChangedAfterDeleteTest() {
        Song__c hipHop1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_1' LIMIT 1];

        Decimal hipHop1ExpectedCount = hipHop1.Track_Amount__c - 1;

        Test.startTest();

            Track__c track = [SELECT Id FROM Track__c WHERE Song__c = :hipHop1.Id LIMIT 1];
            delete track;

        Test.stopTest();

        hipHop1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_1' LIMIT 1];        

        System.assertEquals(hipHop1ExpectedCount, hipHop1.Track_Amount__c, 'Track count is not like expected (hipHop1)');
    }

    @isTest
    public static void mixGenresAreUpdatedAfterInsertTest() {
        Song__c hipHop1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_1' LIMIT 1];
        Song__c hipHop2 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_3' LIMIT 1];
        Song__c hipHop3 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_3' LIMIT 1];
        Song__c rock1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'rock_1' LIMIT 1];
        Song__c rock2 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'rock_2' LIMIT 1];

        Mix__c mixWithoutSongs = [SELECT Id, Song_Amount__c, Primary_Genre__c, Secondary_Genre__c FROM Mix__c WHERE Name = 'Mix Two' LIMIT 1];

        Test.startTest();

            insert new List<Track__c>{
                new Track__c(Song__c = hipHop1.Id, Mix__c = mixWithoutSongs.Id),
                new Track__c(Song__c = hipHop2.Id, Mix__c = mixWithoutSongs.Id),
                new Track__c(Song__c = hipHop3.Id, Mix__c = mixWithoutSongs.Id),
                new Track__c(Song__c = rock1.Id, Mix__c = mixWithoutSongs.Id),
                new Track__c(Song__c = rock2.Id, Mix__c = mixWithoutSongs.Id)
            };

        Test.stopTest();

        mixWithoutSongs = [SELECT Id, Song_Amount__c, Primary_Genre__c, Secondary_Genre__c FROM Mix__c WHERE Name = 'Mix Two' LIMIT 1];

        System.assertEquals('Hip hop', mixWithoutSongs.Primary_Genre__c, 'Primary genre was not updated');

        System.assertEquals('Rock', mixWithoutSongs.Secondary_Genre__c, 'Secondary genre was not updated');
    }

    @isTest
    public static void mixGenresAreUpdatedAfterDeleteTest() {
        Song__c hipHop1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_1' LIMIT 1];
        Song__c hipHop2 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_2' LIMIT 1];
        Song__c hipHop3 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'hip_hop_3' LIMIT 1];
        Song__c rock1 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'rock_1' LIMIT 1];
        Song__c rock2 = [SELECT Id, Track_Amount__c FROM Song__c WHERE Name = 'rock_2' LIMIT 1];

        Mix__c mixWithSongs = [SELECT Id, Song_Amount__c, Primary_Genre__c, Secondary_Genre__c FROM Mix__c WHERE Name = 'Mix One' LIMIT 1];


        insert new List<Track__c>{
            new Track__c(Song__c = hipHop2.Id, Mix__c = mixWithSongs.Id),
            new Track__c(Song__c = hipHop3.Id, Mix__c = mixWithSongs.Id),
            new Track__c(Song__c = rock1.Id, Mix__c = mixWithSongs.Id),
            new Track__c(Song__c = rock2.Id, Mix__c = mixWithSongs.Id)
        };

        Test.startTest();

            Set<Id> hipHopToDeleteIdSet = new Set<Id>{hipHop1.Id, hipHop2.Id};

            delete [SELECT Id FROM Track__c WHERE Song__c IN :hipHopToDeleteIdSet AND Mix__c = :mixWithSongs.Id];

        Test.stopTest();

        mixWithSongs = [SELECT Id, Song_Amount__c, Primary_Genre__c, Secondary_Genre__c FROM Mix__c WHERE Name = 'Mix One' LIMIT 1];

        System.assertEquals('Rock', mixWithSongs.Primary_Genre__c, 'Primary Genre was not updated');

        System.assertEquals('Hip hop', mixWithSongs.Secondary_Genre__c, 'Secondary Genre was not updated');

    }
}
