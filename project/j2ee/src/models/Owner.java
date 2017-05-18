package models;

import javax.persistence.*;
import java.util.List;

/**
 * This class defines the Owner entity for the RFID database. It defines all the attributes for the entity, including
 * the one-to-many and many-to-many relationships.
 *
 * Created by baa8 on 5/13/2017.
 */
@Entity
public class Owner {
    private long id;
    private String username;
    private String password;
    private String firstname;
    private String lastname;
    private String phonenumber;
    private Fridge fridge;
    private List<Stock> stocks;


    @Id
    @Column(name = "ID")
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "USERNAME")
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Basic
    @Column(name = "PASSWORD")
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Basic
    @Column(name = "FIRSTNAME")
    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    @Basic
    @Column(name = "LASTNAME")
    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    @Basic
    @Column(name = "PHONENUMBER")
    public String getPhonenumber() {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }

    //The many-to-one relationship for owners to their fridge
    @ManyToOne
    @JoinColumn(name = "FRIDGEID", referencedColumnName = "ID")
    public Fridge getFridge() {
        return fridge;
    }
    public void setFridge(Fridge fridgeId) {
        this.fridge = fridgeId;
    }

    //The many-to-many relationship for owners and their stock in their fridge
    @ManyToMany
    @JoinTable(name = "OWNERSTOCK", schema = "RFIDDB",
            joinColumns = @JoinColumn(name = "OWNERID", referencedColumnName = "ID", nullable = false),
            inverseJoinColumns = @JoinColumn(name = "STOCKID", referencedColumnName = "RFID", nullable = false))


    public List<Stock> getStocks() { return stocks;}

    public void setStocks(List<Stock>stock) {this.stocks = stock; }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Owner owner = (Owner) o;

        if (id != owner.id) return false;
        if (username != null ? !username.equals(owner.username) : owner.username != null) return false;
        if (password != null ? !password.equals(owner.password) : owner.password != null) return false;
        if (firstname != null ? !firstname.equals(owner.firstname) : owner.firstname != null) return false;
        if (lastname != null ? !lastname.equals(owner.lastname) : owner.lastname != null) return false;
        if (phonenumber != null ? !phonenumber.equals(owner.phonenumber) : owner.phonenumber != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (int) (id ^ (id >>> 32));
        result = 31 * result + (username != null ? username.hashCode() : 0);
        result = 31 * result + (password != null ? password.hashCode() : 0);
        result = 31 * result + (firstname != null ? firstname.hashCode() : 0);
        result = 31 * result + (lastname != null ? lastname.hashCode() : 0);
        result = 31 * result + (phonenumber != null ? phonenumber.hashCode() : 0);
        return result;
    }
}
