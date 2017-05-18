import models.Owner;
import models.Fridge;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.*;


/**
 * This stateless session bean serves as a RESTful resource handler for the RFIDDB.
 * It uses a container-managed entity manager.
 *
 * RFIDDBResource allows the users of this web service to perform data manipulation operations on the
 * RFID database. It tries to reduce the impedance mismatch between the relational database and the object-oriented
 * language, Java. It allows the user to: access information on a specific fridge owner, as well as
 * all the owners stored in the database(GET); update an existing owner's information except the owner's fridge information.
 * This would be useful if things like phone numbers need to be updated for a specific owner (PUT); create a new owner, here the user provides
 * the describing information for the owner, as well as the foreign keys for the owner's fridge and stocks. This could be useful
 * if a person moves into an apartment with a fridge and starts storing things in it (POST); delete an owner. Given the owner
 * id, the user of this webservice can delete an owner if for example, they move out and stop using a smart refrigerator that
 * is monitored by this database.
 *
 * Created by baa8 on 5/13/2017.
 */
@Stateless
@Path("rfiddb")
public class RFIDDBResource {

    /**
     * JPA creates and maintains a managed entity manager with an integrated JTA that can be injected here.
     *  
     */
    @PersistenceContext
    private EntityManager em;

    /**
     * GET an individual owner record.
     * Useful for a business/client manager who may want an owner's contact information
     * @param id the ID of the owner to retrieve
     * @return an owner record
     */
    @GET
    @Path("owner/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Owner getOwner(@PathParam("id") long id) {
        return em.find(Owner.class, id);
    }

    /**
     * GET all owners using the criteria query API.
     * This is useful for a business manager to get information on all the users of the RFID smart refrigerators
     *
     * @return a list of all owner records
     */
    @GET
    @Path("owners")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Owner> getOwners() {
        return em.createQuery(em.getCriteriaBuilder().createQuery(Owner.class)).getResultList();
    }

    /**
     * PUT - modifies the given owner entity, if it exists, using the values in the JSON-formatted owner entity
     * passed with the request
     *
     * @param id the ID of the owner to modify
     * @return an owner record
     *
     * This is useful for an application developer to modify owner records in a case like updating their phone numbers
     * from a null value
     */
    @PUT
    @Path("owner/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response putOwner(Owner updatedOwner, @PathParam("id") long id){
        Owner o = em.find(Owner.class, id);
        //checks to make sure that the id given in the owner entity matches the id in the URL and that the owner exists in the database
        if(updatedOwner.getId() != id || o == null){
            return Response.serverError().entity("Check to make sure the updated person id matches the id given in the URL or that the id exists in the database").build();
        }
        //sets the fridge for the given owner entity
        updatedOwner.setFridge(em.find(Fridge.class, updatedOwner.getFridge().getId()));

        //modifies the owner entity with the updates
        em.merge(updatedOwner);
        return Response.ok(em.find(Owner.class,id), MediaType.APPLICATION_JSON).build();
    }

    /**
     * POST a new owner to the database
     *
     * @param id the ID of the owner to create
     * @return an owner record
     *
     * This is useful to an application developer for creating a new owner for an RFID fridge in the
     * database in the case where the owner has just moved into an apartment with one of the RFID fridges
     */
    @POST
    @Path("owners")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Owner postOwner(Owner newOwner){
        Owner o = new Owner ();
        newOwner.setId(o.getId());
        newOwner.setFridge(em.find(Fridge.class, newOwner.getFridge().getId()));
        em.persist(newOwner);
        return newOwner;
    }

    /**
     * DELETE the person with the given ID, if it exists
     *
     * @param id the ID of the owner to delete
     * @return string : success message
     *
     * This allows an application developer delete an owner who is no longer using an RFID refrigerator
     */
    @DELETE
    @Path("owner/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    public String deleteOwner(@PathParam("id") long id) {
        Owner o = em.find(Owner.class, id);
        //checks to see if an owner with that id exists in the database
        if(o == null){
            return "This id: " + id + " does not exist";
        }
        else {
            em.remove(o);
        }
        return "Deleted Owner: " + id;
    }

}
