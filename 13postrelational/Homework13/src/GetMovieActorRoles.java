import oracle.kv.*;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Map;

/**
 * Created by baa8 on 5/12/2017.
 * GetMovieActorRoles - Gets the roles, if any, for which a given actor is cast in a give movie
 */
public class GetMovieActorRoles {

    public static void main(String[] args) throws SQLException {
        GetMovieActorRoles maRoles = new GetMovieActorRoles();
        maRoles.run();
    }

    public void run() {
        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

        String movieID = "92616";
        String actorID = "429719";

        Key majorKeyPathOnly = Key.createKey(Arrays.asList("role", movieID, actorID));
        Map<Key, ValueVersion> fields = store.multiGet(majorKeyPathOnly, null, null);
        for (Map.Entry<Key, ValueVersion> field : fields.entrySet()) {
            String fieldValue = new String(field.getValue().getValue().getValue());
            System.out.println(fieldValue);
        }
        store.close();
    }
}
