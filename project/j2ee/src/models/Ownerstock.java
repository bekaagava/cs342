package models;

import javax.persistence.*;

/**
 * Created by baa8 on 5/13/2017.
 */
@Entity
@IdClass(OwnerStockPK.class)
public class Ownerstock {
    private long ownerid;
    private long stockid;

    @Id
    @Column(name = "OWNERID")
    public long getOwnerid() {
        return ownerid;
    }

    public void setOwnerid(long ownerid) {
        this.ownerid = ownerid;
    }

    @Id
    @Column(name = "STOCKID")
    public long getStockid() {
        return stockid;
    }

    public void setStockid(long stockid) {
        this.stockid = stockid;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Ownerstock that = (Ownerstock) o;

        if (ownerid != that.ownerid) return false;
        if (stockid != that.stockid) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (int) (ownerid ^ (ownerid >>> 32));
        result = 31 * result + (int) (stockid ^ (stockid >>> 32));
        return result;
    }
}
