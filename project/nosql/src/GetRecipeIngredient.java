import oracle.kv.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

/**
 * GetRecipeIngredient - Gets the ingredients, when given a recipe ID
 * This will be useful to the application developer to produce all the ingredients used in a recipe, as users will need
 * this information to create shopping lists for example.
 *
 * @author: Beka Agava, baa8
 * @version: Spring 2017
 */
public class GetRecipeIngredient {

    public static void main(String[] args) throws SQLException {
        GetRecipeIngredient ri = new GetRecipeIngredient();
        ri.run();
    }

    public void run() {
        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

        String recipeID = "123";

        //creating a major key path
        Key key = Key.createKey(Arrays.asList("recipeIngredient", recipeID));

        ArrayList<String> ingredientIDs = new ArrayList<String>();

        //iterating through and finding the recipe IDs
        Iterator<KeyValueVersion> it = store.storeIterator(Direction.UNORDERED, 0,key, null, null);

        while(it.hasNext()){
            Key tempKey = it.next().getKey();
            String ingredientId = tempKey.getMajorPath().get(2);
            ingredientIDs.add(ingredientId);
        }

        //printing out the results
        for(int i = 0; i < ingredientIDs.size(); i++){
            Key nameKey = Key.createKey(Arrays.asList("ingredient", ingredientIDs.get(i)), Arrays.asList("name"));
            Key kindKey = Key.createKey(Arrays.asList("ingredient", ingredientIDs.get(i)), Arrays.asList("kind"));
            String nameResult = new String(store.get(nameKey).getValue().getValue());
            String kindResult = new String(store.get(kindKey).getValue().getValue());

            System.out.println(ingredientIDs.get(i) + "\t" + nameResult + "\t" + kindResult);
        }
        store.close();
    }
}
