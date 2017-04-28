/**
 * Created by baa8 on 4/21/2017.
 */
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.POST;
import javax.ws.rs.DELETE;
import javax.ws.rs.PathParam;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.Consumes;

// The Java class will be hosted at the URI path "/hello"
@Path("/hello")
public class HelloWorld {
    // The Java method will process HTTP GET requests
    @GET
    // The Java method will produce content identified by the MIME Media type "text/plain"
    @Produces("text/plain")
    public String getClichedMessage() {
        // Return some cliched textual content
        return "Hello World";
    }

    @Path("/api")
    @GET
    @Produces("text/plain")
    public String getSimpleMessage() {
        return "Getting...";
    }

    @Path("/api/{x}")
    @PUT
    @Produces("text/plain")
    public String putIntegerTo(@PathParam("x") Integer x){
        return "Putting: " + x;
    }

    @Path("/api/{s}")
    @POST
    @Produces("text/plain")
    public String postStringTo(@PathParam("s") String s){
        return "Posting: " + s;
    }

    @Path("/api/{x}")
    @DELETE
    @Consumes("text/plain")
    public String deleteIntegerFrom(@PathParam("x") Integer x){
        if (x < 0 || x > 9){
            return "This integer is not in the range 0-9";
        }
        return "Deleting: " + x;
    }
}