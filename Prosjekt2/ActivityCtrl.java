import java.sql.*;

//Controls actvivity of all users (active table)
public class ActivityCtrl extends DBConn {
    private PreparedStatement regStatement;
    private java.sql.Date sqlDate;

    public ActivityCtrl() {
        java.util.Date date = new java.util.Date();
        sqlDate = new java.sql.Date(date.getTime());
    }
    //Saves every time a user logs in on a given day
    public void log(String userID) {
        try {
            Statement stmt = conn.createStatement();
            String query = "select dailyCount from active where userID = \"" + userID + "\" and date = \"" + sqlDate
                    + "\"";

            ResultSet rs = stmt.executeQuery(query);

            int count = 0;
            while (rs.next()) { //Checks if user has already logged in today
                if (rs.getString("dailyCount") != null) {
                    count = rs.getInt("dailyCount") + 1;
                }
            }
            if (count != 0) { //User has already logged in this day
                String query2 = "update active set dailyCount = ? where userID = \"" + userID + "\" and date = \""
                        + sqlDate + "\"";
                PreparedStatement preparedStmt = conn.prepareStatement(query2);
                preparedStmt.setInt(1, count);
                preparedStmt.executeUpdate();
                
            } else { //User has not logged this day
                regStatement = conn.prepareStatement("INSERT INTO active VALUES ( (?), (?), (?))");
                regStatement.setDate(1, sqlDate);
                regStatement.setString(2, userID);
                regStatement.setInt(3, 1);
                regStatement.execute();
            }

        } catch (Exception e) {
            System.out.println("database error i activity ved loggfoering = " + e);

        }

    }
}
