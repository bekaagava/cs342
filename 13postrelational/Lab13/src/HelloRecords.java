/**
 * Created by baa8 on 5/5/2017.
 *  This program creates a new movie record and outputs the name, year and rating fields
 *
 * @author baa8
 * @version CS 342 Spring 2017
 */

import java.util.Arrays;
import java.util.Map;

import oracle.kv.*;

/**
 * This program connects to kvlite on localhost, puts a single key-value pair,
 * reads/prints it, updates it and the deletes it. It is based on Oracle's
 * example:
 *
 * 		C:\Program Files\kv-3.0.9\examples\hello\HelloBigDataWorld.java
 *
 * You'll need to copy the code into a Java class/application file. See lab 13.1 for details.
 *
 * @author kvlinden
 * @version Summer, 2014
 */
public class HelloRecords {

    public static void main(String[] args) {

        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

        // C(reate)
        // This initializes an movie record key-value pair and stores it in KVLite.
        // The key-value structure is /movie/92616 : $fieldName
        String nameString = "Dr. Strangelove";
        Key key = Key.createKey(Arrays.asList("movie", "92616"), Arrays.asList("name"));
        Value value = Value.createValue(nameString.getBytes());
        store.put(key, value);

        String yearString = "1964";
        Key yearKey = Key.createKey(Arrays.asList("movie", "92616"), Arrays.asList("year"));
        Value yearValue = Value.createValue(yearString.getBytes());
        store.put(yearKey, yearValue);

        String ratingString = "8.7";
        Key ratingKey = Key.createKey(Arrays.asList("movie", "92616"), Arrays.asList("rating"));
        Value ratingValue = Value.createValue(ratingString.getBytes());
        store.put(ratingKey, ratingValue);

        // R(ead)
        // This queries KVLite using the same major key path.
        // The result, a movie record, is converted into a string.

        //Without using the major key path
        /*
        String result = new String(store.get(key).getValue().getValue());
        System.out.println(key.toString() + " : " + result);

        String yearResult = new String(store.get(yearKey).getValue().getValue());
        System.out.println(yearKey.toString() + " : " + yearResult);

        String ratingResult = new String(store.get(ratingKey).getValue().getValue());
        System.out.println(ratingKey.toString() + " : " + ratingResult);
        */

        //using the multiGet with the major key path
        Key majorKeyPathOnly = Key.createKey(Arrays.asList("movie", "92616"));
        Map<Key, ValueVersion> fields = store.multiGet(majorKeyPathOnly, null, null);
        for (Map.Entry<Key, ValueVersion> field : fields.entrySet()) {
            String fieldName = field.getKey().getMinorPath().get(0);
            String fieldValue = new String(field.getValue().getValue().getValue());
            System.out.println(majorKeyPathOnly.toString() + "/-/" + fieldName + " : " + fieldValue);
        }

        store.close();
    }

}
