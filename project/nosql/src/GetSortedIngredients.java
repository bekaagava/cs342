import oracle.kv.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

/**
 * GetSortedIngredients gets the ingredients that exist in the database sorted by kind. This will be useful to the application developer
 * quick knowledge of the different kinds of ingredients and to approximate which kind is more at first glance. It also provides easy grouping.
 * 
 * Evaluating the database: Since the key-value structure does not care or control what the values are, it is difficult to sort by any of 
 * the values. A special key-value structure kind/-/$kind/$id : $name had to be created to enable sorting. 
 *
 * @author: Beka Agava, baa8
 * @version: Spring 2017
 */
public class GetSortedIngredients {

    public static void main(String[] args) throws SQLException {
        GetSortedIngredients si = new GetSortedIngredients();
        si.run();
    }

    public void run() {


        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

        //Sort the list of ingredients that comes out by kind
        Key matchKey = Key.createKey("kind");
        Iterator<Key> it = store.multiGetKeysIterator(Direction.FORWARD,
                0, matchKey, null, null);
        while(it.hasNext()) {
            Key temp = it.next();
            String ingredientName = new String(store.get(temp).getValue().getValue());
           System.out.println(temp.toString() + "\t" +":" + "\t" + ingredientName);
        }

        store.close();
    }
}
