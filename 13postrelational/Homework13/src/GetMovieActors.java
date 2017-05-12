import oracle.kv.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

/**
 * Created by baa8 on 5/12/2017.
 * GetMovieActors - Gets the actors if any, who are cast in a given movie
 */
public class GetMovieActors {

    public static void main(String[] args) throws SQLException {
        GetMovieActors movieActors = new GetMovieActors();
        movieActors.run();
    }

    public void run() {
        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

        String movieID = "92616";
        ArrayList<String> actorID = new ArrayList<String>();
        ArrayList<String> role = new ArrayList<String>();

        //creating a major key path
        Key roleKey = Key.createKey(Arrays.asList("role", movieID));

        //iterating through and finding the actor IDs and their roles for the given movie
        Iterator<KeyValueVersion> it = store.storeIterator(Direction.UNORDERED, 0, roleKey, null, null);

        while(it.hasNext()){
            Key tempKey = it.next().getKey();
            String actor = tempKey.getMajorPath().get(2);
            actorID.add(actor);
            String actorRole = tempKey.getMinorPath().get(0);
            role.add(actorRole);
        }

        //printing out the results
        for(int i = 0; i < actorID.size(); i++){
            Key firstNameKey = Key.createKey(Arrays.asList("actor", actorID.get(i)), Arrays.asList("firstName"));
            Key lastNameKey = Key.createKey(Arrays.asList("actor", actorID.get(i)), Arrays.asList("lastName"));
            String fNameResult = new String(store.get(firstNameKey).getValue().getValue());
            String lNameResult = new String(store.get(lastNameKey).getValue().getValue());

            System.out.println(actorID.get(i) + "\t" + fNameResult + "\t" + lNameResult + "\t" + role.get(i));
        }
        store.close();
    }
}

