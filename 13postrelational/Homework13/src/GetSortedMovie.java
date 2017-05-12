import oracle.kv.*;
import java.sql.SQLException;
import java.util.*;

/**
 * Created by baa8 on 5/12/2017.
 * GetSortedMovie - Lists all the movies in order of year
 */
public class GetSortedMovie {

    public static void main(String[] args) throws SQLException {
        GetSortedMovie sortedMovie = new GetSortedMovie();
        sortedMovie.run();
    }

    public void run() {
        KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

        ArrayList<Movie> movies = new ArrayList<Movie>();

        //creating a major key path
        Key movieKey = Key.createKey(Arrays.asList("movie"));

        //iterating through and getting the movie values and storing them in the Movie class
        Iterator<KeyValueVersion> it = store.storeIterator(Direction.UNORDERED, 0, movieKey, null, null);
        while(it.hasNext()) {
            Key temp1 = it.next().getKey();
            String id = new String(temp1.getMajorPath().get(1));
            String name = new String(store.get(temp1).getValue().getValue());
            Key temp2 = it.next().getKey();
            String rank = new String(store.get(temp2).getValue().getValue());
            Key temp3 = it.next().getKey();
            String year = new String(store.get(temp3).getValue().getValue());

            //adding the movies in the Movie table
            Movie movie = new Movie();
            movie.setId(id);
            movie.setName(name);
            movie.setYear(year);
            movie.setRank(rank);
            movies.add(movie);
        }

        //ordering the movies by year
        Collections.sort(movies, new Comparator<Movie>() {
            @Override
            public int compare(Movie movie1, Movie movie2) {
                return movie1.getYear().compareTo(movie2.getYear());
            }
        });

        //printing out the results
        for(int i = 0; i < movies.size(); i++) {
            System.out.println(movies.get(i).getYear() + "\t" + movies.get(i).getId() + "\t" + movies.get(i).getName());
        }
        store.close();
    }
}
