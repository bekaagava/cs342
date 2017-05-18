package models;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.sql.Time;

/**
 * This class defined the Stock entity of the RFID database.
 *
 * Created by baa8 on 5/13/2017.
 */
@Entity
public class Stock {
    private long rfid;
    private Time expirationdate;

    @Id
    @Column(name = "RFID")
    public long getRfid() {
        return rfid;
    }

    public void setRfid(long rfid) {
        this.rfid = rfid;
    }

    @Basic
    @Column(name = "EXPIRATIONDATE")
    public Time getExpirationdate() {
        return expirationdate;
    }

    public void setExpirationdate(Time expirationdate) {
        this.expirationdate = expirationdate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Stock stock = (Stock) o;

        if (rfid != stock.rfid) return false;
        if (expirationdate != null ? !expirationdate.equals(stock.expirationdate) : stock.expirationdate != null)
            return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (int) (rfid ^ (rfid >>> 32));
        result = 31 * result + (expirationdate != null ? expirationdate.hashCode() : 0);
        return result;
    }
}
