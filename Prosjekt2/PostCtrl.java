import java.sql.*;
import java.util.*;

//Controls all posts, replys actions (thread, threadviewedliked, reply, replyliked tables)
public class PostCtrl extends DBConn {
    private String folderID;
    private PreparedStatement regStatement;

    public PostCtrl(String folderID) {
        this.folderID = folderID;
    }
    //Returns a Hashmap with all posts available in the current folder
    public Map<String, String[]> getPostDict() {
        Map<String, String[]> map = new HashMap<String, String[]>();
        try {
            Statement stmt = conn.createStatement();
            String query = "select threadID, title, description, tag from folder " + "natural join thread "
                    + "where folderID = \"" + folderID + "\"";
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                map.put(rs.getString("threadID"),
                        new String[] { rs.getString("title"), rs.getString("description"), rs.getString("tag") });
            }
        } catch (Exception e) {
            System.out.println("database error under uthenitng av poster = " + e);
        }
        return map;
    }

    //Creates a post given a users input
    public void createPost(String name, String userID, String titel, String desc, String tag) {
        try {
            String threadID = UUID.randomUUID().toString().substring(0, 15);
            regStatement = conn
                    .prepareStatement("INSERT INTO thread VALUES ( (?), (?), (?), (?), (?), (?), (?), (?), (?), (?) )");
            regStatement.setString(1, threadID);
            regStatement.setString(2, name);
            regStatement.setString(3, titel);
            regStatement.setString(4, desc);
            regStatement.setString(5, tag);
            regStatement.setString(6, null);
            regStatement.setInt(7, 0);
            regStatement.setString(8, folderID);
            regStatement.setString(9, null); // Oppgaven stiller ikke krav til subfolders
            regStatement.setString(10, userID);
            regStatement.execute();

        } catch (Exception e) {
            System.out.println("database error under oppretting av post = " + e);
        }
    }

    //Creates a post given a users input
    public void createReply(String name, String userID, String text, String threadID) {
        try {
            String replyID = UUID.randomUUID().toString().substring(0, 15);
            regStatement = conn.prepareStatement("INSERT INTO reply VALUES ( (?), (?), (?), (?), (?), (?), (?) )");
            regStatement.setString(1, replyID);
            regStatement.setString(2, text);
            regStatement.setString(3, name);
            regStatement.setInt(4, 0);
            regStatement.setString(5, threadID);
            regStatement.setString(6, userID);
            regStatement.setString(7, null);
            regStatement.execute();

        } catch (Exception e) {
            System.out.println("database error under oppretting av svar = " + e);
        }
    }

    //Let's a user search for posts/replys given a keyword
    public Map<String, String[]> searchPosts(String courseCode, String term, String keyword) {
        Map<String, String[]> map = new HashMap<String, String[]>();
        try {
            //Searches through all posts
            Statement stmt = conn.createStatement();
            String queryThread = "select folderName, thread.threadID, title, description from user natural join userincourse "
                    + "natural join courseforum " + "natural join folder " + "natural join thread "
                    + "where courseCode = \'" + courseCode + "\' and term = \'" + term + "\' and " + "(title like \'%"
                    + keyword + "%\' or description like \'%" + keyword + "%\');";
            ResultSet rs1 = stmt.executeQuery(queryThread);
            while (rs1.next()) {
                map.put(rs1.getString("thread.threadID"), new String[] { "thread", rs1.getString("folderName"),
                        rs1.getString("title"), rs1.getString("description") });
            };
            //Searches through all replys
            String queryReply = "select folderName, thread.threadID, title,description, text, replyID from user "
                    + "natural join userincourse " + "natural join courseforum " + "natural join folder "
                    + "natural join thread " + "inner join reply on thread.threadID = reply.threadID "
                    + "where courseCode = \'" + courseCode + "\' and term = \'" + term + "\' and " + "text like \'%"
                    + keyword + "%\';";
            ResultSet rs2 = stmt.executeQuery(queryReply);
            while (rs2.next()) {
                map.put(rs2.getString("replyID"), new String[] { "reply", rs2.getString("folderName"),
                        rs2.getString("title"), rs2.getString("text"), rs2.getString("threadID") });
            }

        } catch (Exception e) {
            System.out.println("database error under søking etter poster/svar = " + e);
        }
        return map;
    }

    //Let's a user view a post and read it
    public void viewPost(String userID, String threadID) {
        try {
            Statement stmt = conn.createStatement();
            String query = "select viewed from threadviewedliked where userID = \"" + userID + "\" and threadID = \""
                    + threadID + "\"";
            ResultSet rs = stmt.executeQuery(query);
            boolean alreadyViewed = false;
            while(rs.next()){ //Checks if the user already has read the post
                System.out.println("Viewd");
                alreadyViewed = true;
            }
            if (!alreadyViewed) { //Logs a new view if the users has not read the post previously
                System.out.println("Add view");
                regStatement = conn.prepareStatement("INSERT INTO threadviewedliked VALUES ( (?), (?), (?), (?) )");
                regStatement.setString(1, userID);
                regStatement.setString(2, threadID);
                regStatement.setInt(3, 1); // Viewed, 0 = false, 1 = true
                regStatement.setInt(4, 0); // Liked, not a requested feature
                regStatement.execute();
            }

        } catch (Exception e) {
            System.out.println("database error under loggfoering av at brukeren leser en post = " + e);
        }
    }
}