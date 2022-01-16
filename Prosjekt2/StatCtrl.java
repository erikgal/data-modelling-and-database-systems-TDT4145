import java.sql.*;
import java.util.*;

//Controll all statistical knowledge in a course (thread, threadviewedliked, reply tables) 
public class StatCtrl extends DBConn {

    public void getMostActiveUsers(String courseCode, String term) {
        Map<String, Integer[]> map = new HashMap<String, Integer[]>();
        try {
            Statement stmt = conn.createStatement();
            ArrayList<String> names = new ArrayList<String>();// Array to sort users, used later

            // Counts all threads all the user in the course has created, even if 0
            String queryThread = "select user.name,  count(thread.threadID) as threadsCreated "
                    + "from user natural join userincourse " + "left join thread on user.userID = thread.createdBy "
                    + "where courseCode = \"" + courseCode + "\" and term = \"" + term + "\" " + "group by user.userID";
            ResultSet rst = stmt.executeQuery(queryThread);
            while (rst.next()) {
                map.put(rst.getString("user.name"), new Integer[] { rst.getInt("threadsCreated") });
            }
            // Counts all replys all the user in the course has created, even if 0
            String queryReply = "select user.name,  count(reply.replyID) as replysCreated "
                    + "from user natural join userincourse " + "left join reply on user.userID = reply.createdBy "
                    + "where courseCode = \"" + courseCode + "\" and term = \"" + term + "\"" + " group by user.userID";
            ResultSet rsr = stmt.executeQuery(queryReply);
            while (rsr.next()) {
                map.put(rsr.getString("user.name"),
                        // Adding number of created posts with number of created replys
                        new Integer[] { rsr.getInt("replysCreated") + map.get(rsr.getString("user.name"))[0] });
            }

            // Counts all posts all the user in the course has read/viewed, even if 0
            String queryViews = "select user.name,  count(threadviewedliked.threadID) as postsViewed "
                    + "from user natural join userincourse "
                    + "left join threadviewedliked on user.userID = threadviewedliked.userID " + "where courseCode = \""
                    + courseCode + "\" and term = \"" + term + "\"" + " group by user.userID order by postsViewed DESC";
            ResultSet rsv = stmt.executeQuery(queryViews);
            while (rsv.next()) {
                names.add(rsv.getString("user.name")); // Saves the order of the user
                map.put(rsv.getString("user.name"),
                        new Integer[] { rsv.getInt("postsViewed"), map.get(rsv.getString("user.name"))[0] });
            }

            System.out.print("\n");
            System.out.format("%-20s%-25s%-25s\n", "user name", "number of posts read", "number of posts created");
            for (String key : names) { // Displays user nam, number of posts read and number of posts created i right
                                       // order
                System.out.format("%-20s%-25s%-25s\n", key, map.get(key)[0], map.get(key)[1]);
            }

        } catch (Exception e) {
            System.out.println("database error oppretting av statistikk = " + e);
        }

    }
}