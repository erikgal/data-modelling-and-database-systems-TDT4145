import java.sql.*;
import java.util.*;

//Controls all the courses (userincourse, courseforum table)
public class CourseCtrl extends DBConn {
    private String userID;

    public CourseCtrl(String userID) {
        this.userID = userID;
    }
    //Return a Hashmap with all courses available to a certain user
    public Map<String, String[]> getCourseDict() {
        Map<String, String[]> map = new HashMap<String, String[]>();
        try {
            Statement stmt = conn.createStatement();
            String query = "select courseName, courseCode, term from user "
            + "natural join userincourse natural join courseforum "
            + "where userID = \""  + userID + "\"";
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                map.put(rs.getString("courseName"), new String[] {rs.getString("courseCode"), rs.getString("term")});
            }
        } catch (Exception e) {
            System.out.println("database error ved uthenting av kurs til bruker = " + e);
        }
        return map;
    }
}