import java.sql.*;
import java.util.*;

//Controlls all folders in a course (folder table, not subfolder since usecase does not demand it)
public class FolderCtrl extends DBConn {
    private String courseCode;
    private String term;

    public FolderCtrl(String courseCode, String term) {
        this.courseCode = courseCode;
        this.term = term;
    }
    //Returns a Hashmap with all folders available to a certain user
    public Map<String, String[]> getFolderDict() {
        Map<String, String[]> map = new HashMap<String, String[]>();
        try {
            Statement stmt = conn.createStatement();
            String query = "select folderName, folderID, allowAnonymity from folder " + "natural join courseForum "
                    + "where courseCode = \"" + courseCode + "\" and " + "term = \"" + term + "\"";
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                map.put(rs.getString("folderName"),
                        new String[] { rs.getString("folderID"), rs.getString("allowAnonymity") });
            }
        } catch (Exception e) {
            System.out.println("database error under uthenting av mapper = " + e);
        }
        return map;
    }
}