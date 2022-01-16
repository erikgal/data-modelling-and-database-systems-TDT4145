import java.sql.*; 

// Controls user login (user table)
public class LoginCtrl extends DBConn {

    public String[] loggIn(String mail, String password) {
        String error = "error";
        try {
            Statement stmt = conn.createStatement();
            String query = "select userid, type, name from user where mail = " + mail + " and password = " + password;
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) { //Successful login
                return new String[] {rs.getString("userid"), rs.getString("type"), rs.getString("name")};
            }
            System.out.println("Mailen eller passordet du skrev inn finnes ikke i databasen");
            return new String[] {error};
        } catch (Exception e) {
            System.out.println("database error når brukeren prøver å logge inn = " + e); 
            return new String[] {error};
        }

    }
}