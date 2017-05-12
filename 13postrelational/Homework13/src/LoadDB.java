import oracle.kv.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;

/**
 * Created by baa8 on 5/12/2017.
 * LoadDB pulls data from the OracleXE IMDB Movie, Actor and Role tables
 * and loads it into Oracle KVLite using a key-value structure
 */
public class LoadDB {

    public static void main(String[] args) throws SQLException {
        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));
        Connection jdbcConnection = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe", "imdb", "bjarne");
        Statement jdbcStatement = jdbcConnection.createStatement();

        //Pulling data from the OracleXE IMDB Movie
        ResultSet movieResultSet = jdbcStatement.executeQuery("SELECT id, name, year, rank FROM Movie");
        while (movieResultSet.next()) {

            //pulling the name: movie/id/-/name
            Key nameKey = Key.createKey(Arrays.asList("movie", movieResultSet.getString(1)), Arrays.asList("name"));
            Value nameValue = Value.createValue(movieResultSet.getString(2).getBytes());
            store.put(nameKey, nameValue);

            /**
             //test
             String storeResult1 = new String(store.get(nameKey).getValue().getValue());
             System.out.println(nameKey.toString() + "\t" + storeResult1);
            */

            //pulling the year: movie/id/-/year
            Key yearKey = Key.createKey(Arrays.asList("movie", movieResultSet.getString(1)), Arrays.asList("year"));
            Value yearValue = Value.createValue(movieResultSet.getString(3).getBytes());
            store.put(yearKey, yearValue);

            /**
             //test
             String storeResult2 = new String(store.get(yearKey).getValue().getValue());
             System.out.println(yearKey.toString() + "\t" + storeResult2);
            */

            //pulling the rank: movie/id/-/rank
            Key rankKey = Key.createKey(Arrays.asList("movie", movieResultSet.getString(1)), Arrays.asList("rank"));
            if(movieResultSet.getString(4) != null) {
                Value rankValue = Value.createValue(movieResultSet.getString(4).getBytes());
                store.put(rankKey, rankValue);
            }   else {
                Value rankValue = Value.createValue("null".getBytes());
                store.put(rankKey, rankValue);
            }

            /**
             //test
             String storeResult3 = new String(store.get(rankKey).getValue().getValue());
             System.out.println(rankKey.toString() + "\t" + storeResult3);
            */
        }

        //Pulling data from the OracleXE IMDB Actor
        ResultSet actorResultSet = jdbcStatement.executeQuery("SELECT id, firstName, lastName, gender FROM Actor");
        while (actorResultSet.next()) {

            //pulling the firstName: actor/id/-/firstName
            Key firstNameKey = Key.createKey(Arrays.asList("actor", actorResultSet.getString(1)), Arrays.asList("firstName"));
            Value firstNameValue = Value.createValue(actorResultSet.getString(2).getBytes());
            store.put(firstNameKey, firstNameValue);

            /**
             //test
            String storeResult1 = new String(store.get(firstNameKey).getValue().getValue());
            System.out.println(firstNameKey.toString() + "\t" + storeResult1);
             */

            //pulling the lastName: actor/id/-/lastName
            Key lastNameKey = Key.createKey(Arrays.asList("actor", actorResultSet.getString(1)), Arrays.asList("lastName"));
            Value lastNameValue = Value.createValue(actorResultSet.getString(3).getBytes());
            store.put(lastNameKey, lastNameValue);

            /**
             //test
            String storeResult2 = new String(store.get(lastNameKey).getValue().getValue());
            System.out.println(lastNameKey.toString() + "\t" + storeResult2);
             */

            //pulling the gender: actor/id/gender
            Key genderKey = Key.createKey(Arrays.asList("actor", actorResultSet.getString(1)), Arrays.asList("gender"));
            Value genderValue = Value.createValue(actorResultSet.getString(3).getBytes());
            store.put(genderKey, genderValue);

            /**
            //test
            String storeResult3 = new String(store.get(genderKey).getValue().getValue());
            System.out.println(genderKey.toString() + "\t" + storeResult3);
             */
        }

        //Pulling data from the OracleXE IMDB Role
        ResultSet roleResultSet = jdbcStatement.executeQuery("SELECT movieId, actorId, role FROM Role");
        while (roleResultSet.next()) {

            //pulling the role: role/actorId/movieId/-/role
            //this stores the role name as a minor key, so that it returns all the roles an actor played for a movie, if they had multiple
            Key roleKey = Key.createKey(Arrays.asList("role", roleResultSet.getString(1), roleResultSet.getString(2)), Arrays.asList(roleResultSet.getString(3)));
            Value roleValue = Value.createValue(roleResultSet.getString(3).getBytes());
            store.put(roleKey, roleValue);

            /**
             //test
            String storeResult = new String(store.get(roleKey).getValue().getValue());
            System.out.println(roleKey.toString() + "\t" + storeResult);
             */
        }

        //closing the stuff
        movieResultSet.close();
        actorResultSet.close();
        roleResultSet.close();
        jdbcStatement.close();
        jdbcConnection.close();
        store.close();
    }

}
