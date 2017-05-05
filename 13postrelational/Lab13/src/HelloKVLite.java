import java.util.Arrays;

import oracle.kv.KVStore;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.Key;
import oracle.kv.Value;

/**
 * This program connects to kvlite on localhost, puts a single key-value pair,
 * reads/prints it, updates it and then deletes it. It is based on Oracle's
 * example:
 * 
 * 		C:\Program Files\kv-3.0.9\examples\hello\HelloBigDataWorld.java
 * 
 * You'll need to copy the code into a Java class/application file. See lab 13.1 for details.
 * 
 * @author kvlinden, BAA8
 * @version Summer, 2014
 */
public class HelloKVLite {

	public static void main(String[] args) {
		
		KVStore store = KVStoreFactory.getStore(new KVStoreConfig("kvstore", "localhost:5000"));

		// C(reate)
		// This initializes two arbitrary key-value pairs and stores it in KVLite.
		// The key-value structure is /helloKey : $value and /secondKey : $value
		String keyString = "helloKey", valueString = "Hello, Oracle NoSQL!";
		String secondKeyString = "secondKey", secondValueString = "Hey, I made a second key-value pair";
		Key key = Key.createKey(Arrays.asList(keyString));
		Key key2 = Key.createKey(Arrays.asList(secondKeyString));
		Value value = Value.createValue(valueString.getBytes());
		Value value2 = Value.createValue(secondValueString.getBytes());
		store.put(key, value);
		store.put(key2, value2);

		// R(ead)
		// This queries KVLite using the same key.
		// The result, a byte array, is converted into a string.
		String result = new String(store.get(key).getValue().getValue());
		String result2 = new String(store.get(key2).getValue().getValue());
		System.out.println(key.toString() + " : " + result);
		System.out.println(key2.toString() + " : " + result2);

		// U(pdate)
		// This modifies the value, puts the new value, overwriting the old
		// value, and gets/prints it again.
		valueString = "Hello, KVLite!";
		secondValueString = "I changed my second key-value pair!";
		value = Value.createValue(valueString.getBytes());
		value2 = Value.createValue(secondValueString.getBytes());
		store.put(key, value);
		store.put(key2, value2);
		result = new String(store.get(key).getValue().getValue());
		result2 = new String(store.get(key2).getValue().getValue());
		System.out.println(key.toString() + " : " + result);
		System.out.println(key2.toString() + " : " + result2);

		// D(elete)
		// This deletes the key-value pair.
		store.delete(key);
		store.delete(key2);
		if (store.get(key) == null) {
			System.out.println("Good, key successfully deleted...");
		} else {
			System.out.println("Oops, key not deleted...");
		}

		if (store.get(key2) == null) {
			System.out.println("Good, key2 successfully deleted...");
		} else {
			System.out.println("Oops, key2 not deleted...");
		}
		store.close();
	}

}
