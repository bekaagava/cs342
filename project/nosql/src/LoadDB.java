import oracle.kv.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.Map;

/**
 * Created by baa8 on 5/12/2017.
 * Oracle’s KVLite key-value system is not the best type of noSQL database for my application. 
 * My application contains a lot of many-to-one and many-to-many relationships.
 * Key-Value stores are not very useful for databases that require a lot of join tables.
 *
 * LoadDB pulls data from the OracleXE RFIDDB RECIPE, INGREDIENT and RECIPEINGREDIENT tables
 * and loads it into Oracle KVLite using a key-value structure. It will be useful for application developers to access the RFIDDB database
 * records, and store them in a key-value database that doesn't have most of SQL relational database problems.
 */

public class LoadDB {

    public static void main(String[] args) throws SQLException {
        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));
        Connection jdbcConnection = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe", "rfiddb", "seven");
        Statement jdbcStatement = jdbcConnection.createStatement();

        //Pulling data from the OracleXE RFIDDB Recipe
        ResultSet recipeResultSet = jdbcStatement.executeQuery("SELECT id, name, description, durationUnit, durationNumber FROM Recipe");
        while (recipeResultSet.next()) {

            //pulling the name: recipe/id/-/name
            Key nameKey = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("name"));
            Value nameValue = Value.createValue(recipeResultSet.getString(2).getBytes());
            store.put(nameKey, nameValue);
            
            Key nameKeyPath = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("name"));
            Map<Key, ValueVersion> fields = store.multiGet(nameKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> field : fields.entrySet()) {
                String fieldValue = new String(field.getValue().getValue().getValue());
                System.out.println(nameKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

            //pulling the description: recipe/id/-/description
            Key descriptionKey = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("description"));
            Value descriptionValue = Value.createValue(recipeResultSet.getString(3).getBytes());
            store.put(descriptionKey, descriptionValue);
            
            Key descriptionKeyPath = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("description"));
            Map<Key, ValueVersion> descriptionFields = store.multiGet(descriptionKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> descriptionField : descriptionFields.entrySet()) {
                String fieldValue = new String(descriptionField.getValue().getValue().getValue());
                System.out.println(descriptionKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

            //pulling the durationUnit: recipe/id/-/durationUnit
            Key durationUKey = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("durationUnit"));
            Value durationUValue = Value.createValue(recipeResultSet.getString(4).getBytes());
            store.put(durationUKey, durationUValue);
            
            Key durationUKeyPath = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("durationUnit"));
            Map<Key, ValueVersion> durationUFields = store.multiGet(durationUKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> durationField : durationUFields.entrySet()) {
                String fieldValue = new String(durationField.getValue().getValue().getValue());
                System.out.println(durationUKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

            //pulling the durationNumber: recipe/id/-/durationNumber
            Key durationNKey = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("durationNumber"));
            Value durationNValue = Value.createValue(recipeResultSet.getString(5).getBytes());
            store.put(durationNKey, durationNValue);
            
            Key durationNKeyPath = Key.createKey(Arrays.asList("recipe", recipeResultSet.getString(1)), Arrays.asList("durationNumber"));
            Map<Key, ValueVersion> durationNFields = store.multiGet(durationNKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> durationNField : durationNFields.entrySet()) {
                String fieldValue = new String(durationNField.getValue().getValue().getValue());
                System.out.println(durationNKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

        }


        //Pulling data from the OracleXE RFIDDB Ingredient
        ResultSet ingredientResultSet = jdbcStatement.executeQuery("SELECT id, name, kind FROM Ingredient");
        while (ingredientResultSet.next()) {

            //pulling the name: ingredient/id/-/name
            Key nameKey = Key.createKey(Arrays.asList("ingredient", ingredientResultSet.getString(1)), Arrays.asList("name"));
            Value nameValue = Value.createValue(ingredientResultSet.getString(2).getBytes());
            store.put(nameKey, nameValue);
            
            Key nameKeyPath = Key.createKey(Arrays.asList("ingredient", ingredientResultSet.getString(1)), Arrays.asList("name"));
            Map<Key, ValueVersion> nameFields = store.multiGet(nameKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> nameField : nameFields.entrySet()) {
                String fieldValue = new String(nameField.getValue().getValue().getValue());
                System.out.println(nameKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

            //pulling the kind: ingredient/id/-/kind
            Key kindKey = Key.createKey(Arrays.asList("ingredient", ingredientResultSet.getString(1)), Arrays.asList("kind"));
            Value kindValue = Value.createValue(ingredientResultSet.getString(3).getBytes());
            store.put(kindKey, kindValue);
            
            Key kindKeyPath = Key.createKey(Arrays.asList("ingredient", ingredientResultSet.getString(1)), Arrays.asList("kind"));
            Map<Key, ValueVersion> kindFields = store.multiGet(kindKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> kindField : kindFields.entrySet()) {
                String fieldValue = new String(kindField.getValue().getValue().getValue());
                System.out.println(kindKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

        }

        //Pulling data from the OracleXE RFIDDB RecipeIngredient
        ResultSet riResultSet = jdbcStatement.executeQuery("SELECT recipeId, ingredientId, quantity, unit FROM recipeIngredient");
        while (riResultSet.next()) {

            // recipeIngredient/recipeId/IngredientId/-/quantity/
            //this stores the quantity as a minor key, so that it returns all the quantities for each ingredient, since the quantities apply to multiple
            Key quantityKey = Key.createKey(Arrays.asList("recipeIngredient", riResultSet.getString(1), riResultSet.getString(2)), Arrays.asList("quantity"));
            Value quantityValue = Value.createValue(riResultSet.getString(3).getBytes());
            store.put(quantityKey, quantityValue);
            
            Key quantityKeyPath = Key.createKey(Arrays.asList("recipeIngredient", riResultSet.getString(1), riResultSet.getString(2)), Arrays.asList("quantity"));
            Map<Key, ValueVersion> quantityFields = store.multiGet(quantityKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> quantityField : quantityFields.entrySet()) {
                String fieldValue = new String(quantityField.getValue().getValue().getValue());
                System.out.println(quantityKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }

            // recipeIngredient/recipeId/IngredientId/-/unit/
            //this stores the unit name as a minor key, so that it returns all the units for each ingredient, since the units apply to multiple
            Key unitKey = Key.createKey(Arrays.asList("recipeIngredient", riResultSet.getString(1), riResultSet.getString(2)), Arrays.asList("unit"));
            Value unitValue = Value.createValue(riResultSet.getString(4).getBytes());
            store.put(unitKey, unitValue);
            
            Key unitKeyPath = Key.createKey(Arrays.asList("recipeIngredient", riResultSet.getString(1), riResultSet.getString(2)), Arrays.asList("unit"));
            Map<Key, ValueVersion> unitFields = store.multiGet(unitKeyPath, null, null);
            for (Map.Entry<Key, ValueVersion> unitField : unitFields.entrySet()) {
                String fieldValue = new String(unitField.getValue().getValue().getValue());
                System.out.println(unitKeyPath.toString() + "\t" + ":" + "\t" + fieldValue);
            }
        }


        ResultSet kindResultSet = jdbcStatement.executeQuery("SELECT kind, id, name FROM Ingredient");
        while (kindResultSet.next()) {

            // kind/-/kind/id
            Key key = Key.createKey("kind", Arrays.asList(kindResultSet.getString(1), kindResultSet.getString(2)));
            // name value
            Value value = Value.createValue(kindResultSet.getString(3).getBytes());
            store.putIfAbsent(key, value); 
            
            Key indexKey = Key.createKey("kind", Arrays.asList(kindResultSet.getString(1), kindResultSet.getString(2)));
            Map<Key, ValueVersion> unitFields = store.multiGet(indexKey, null, null);
            for (Map.Entry<Key, ValueVersion> unitField : unitFields.entrySet()) {
                String fieldValue = new String(unitField.getValue().getValue().getValue());
                System.out.println(indexKey.toString() + "\t" + ":" + "\t" + fieldValue);
            }

        }

        //closing the stuff
        recipeResultSet.close();
        ingredientResultSet.close();
        riResultSet.close();
        kindResultSet.close();
        jdbcStatement.close();
        jdbcConnection.close();
        store.close();
    }
}
