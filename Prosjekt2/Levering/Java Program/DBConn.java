import java.sql.*;

public abstract class DBConn {
    protected Connection conn;

    public DBConn() {
    }

    public void connect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db1", "brukernavn", "passord");
        } catch (Exception e) {
            throw new RuntimeException("Unable to connect", e);
        }
    }
}