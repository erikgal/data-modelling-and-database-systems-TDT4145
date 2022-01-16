import java.util.*;

public class Main {
    public static Scanner scannerObjekt = new Scanner(System.in);
    private static String userID;
    private static String type;
    private static String name;

    private static String courseCode;
    private static String courseName;
    private static String term;

    private static String folderID;
    private static String folderName;
    private static String allowAnonymity; // String of '0' or '1'

    // Main program
    public static void main(String[] args) {
        loggIn();

        while (userID != null) { // Access to Piazza

            ActivityCtrl activityCtrl = new ActivityCtrl(); // Log activity, not part of any use case
            activityCtrl.connect();
            activityCtrl.log(userID);

            chooseCourse();
            System.out.println("\n\nDu er naa i " + courseCode + " - " + term + " kurset");

            chooseAction(); // Search, Statistics or choose folder

            chooseFolder();
            System.out.println("\n\nDu er naa i " + folderName + "-mappen");

            choosePost(); // Create post/reply or read post
            break;
        }
    }

    // Returns int userinput
    public static int getInt() {
        while (true) {
            try {
                return scannerObjekt.nextInt();
            } catch (InputMismatchException e) {
                scannerObjekt.next();
                System.out.println("Du maa skrive et heltall. \n");
            }
        }
    }

    // Loggs in user
    private static void loggIn() {
        boolean loggedIn = false;

        while (!loggedIn) {// Continues until correct userinput/login
            System.out.println("\nStartside: \n");
            System.out.println("0: Avslutt programmet \n");
            System.out.println("1: Logge inn \n");

            int input = getInt();

            if (input == 0) { // Quit
                System.out.print("Avslutter programmet...");
                break;

            } else if (input == 1) { // Login
                System.out.println("\nSkriv inn mailen din:");
                String mail = "\'" + scannerObjekt.next() + "\'";

                System.out.println("\nSkriv inn passorder ditt:");
                String password = "\'" + scannerObjekt.next() + "\'";

                LoginCtrl loginCtrl = new LoginCtrl();
                loginCtrl.connect();
                String[] response = loginCtrl.loggIn(mail, password);
                if (response[0] != "error") { // Successful authorization
                    userID = response[0];
                    type = response[1];
                    name = response[2];
                    loggedIn = true;
                }
            } else {
                System.out.println("Skriv inn et av de mulige tallene\n");
            }
        }
    }

    // User chooses course (needs to have access)
    private static void chooseCourse() {
        boolean choosenCourse = false;

        CourseCtrl courseCtrl = new CourseCtrl(userID);
        courseCtrl.connect();
        // Courses user has access to
        Map<String, String[]> courseDict = courseCtrl.getCourseDict(); // coursename : [courseCode, term]

        while (!choosenCourse) { // Continues until correct userinput/login, meaning course user has access to
            System.out.println("\nDette er kursene du har tilgang til:");
            // Displays all available courses to user
            for (String key : courseDict.keySet()) {
                System.out.println(key);
            }
            System.out.println("\nSkriv navnet paa kurset du vil velge:");
            scannerObjekt.nextLine();
            String name = scannerObjekt.nextLine();

            // Itterates through all courses the user has access to
            for (String key : courseDict.keySet()) {
                if (name.equals(key)) { // Valid input
                    courseName = name;
                    courseCode = courseDict.get(key)[0];
                    term = courseDict.get(key)[1];
                    choosenCourse = true;
                }
            }

        }
    }

    // Depending on user type, user can choose what to do
    private static void chooseAction() {
        boolean actionComplete = false;

        while (!actionComplete) {
            if (type.equals("Instructor")) {
                System.out.println("\nVelg hva du vil gjoere \nSoek \nStatistikk \nVelg mappe");
                String input = scannerObjekt.nextLine();

                if (input.equals("Soek")) {
                    chooseSearch();
                }

                else if (input.equals("Statistikk")) {// Only accessible by instructor
                    showStatistics();
                }

                else if (input.equals("Velg mappe")) {
                    actionComplete = true;
                }
            } else { // Student
                System.out.println("\nVelg hva du vil gjoere \nSoek \nVelg mappe");
                String input = scannerObjekt.nextLine();

                if (input.equals("Soek")) {
                    chooseSearch();
                }

                else if (input.equals("Velg mappe")) {
                    actionComplete = true;
                }
            }
        }
    }

    // Shows statistics to instructor
    private static void showStatistics() {
        StatCtrl statCtrl = new StatCtrl();
        statCtrl.connect();
        statCtrl.getMostActiveUsers(courseCode, term);
    }

    // Let's user search for posts with keyword
    private static void chooseSearch() {
        PostCtrl postCtrl = new PostCtrl(folderID);
        postCtrl.connect();
        System.out.println("\nHva vil du soeke etter?");
        String keyword = scannerObjekt.nextLine();

        Map<String, String[]> searchResults = postCtrl.searchPosts(courseCode, term, keyword);
        for (String key : searchResults.keySet()) {// Itterates through all matches

            if (searchResults.get(key)[0].equals("thread")) { // Match was thread
                // threadID : [postType, folderName, thread title, Description]
                System.out.println("\nMatch found in folder " + searchResults.get(key)[1] + " in thread " + " (id: "
                        + key + "):\n" + searchResults.get(key)[2] + "\nBeskrivelse: " + searchResults.get(key)[3]);

            } else { // Match was reply
                // replyID : [postType, folderName, thread title, reply, threadID]
                System.out.println("\nMatch found in folder " + searchResults.get(key)[1] + " in thread "
                        + searchResults.get(key)[2] + " (id: " + searchResults.get(key)[4] + ") in reply " + "(id: "
                        + key + "):\n" + searchResults.get(key)[3]);
            }
        }
    }

    // User chooses folder in course
    private static void chooseFolder() {
        boolean choosenFolder = false;

        FolderCtrl folderCtrl = new FolderCtrl(courseCode, term);
        folderCtrl.connect();
        Map<String, String[]> folderDict = folderCtrl.getFolderDict(); // folderName : [folderCode, allowAnonymity]

        while (!choosenFolder) { // Continues until correct userinput/login, i.e. existing folder
            System.out.println("\nDisse mappene har du tilgang til:");
            for (String key : folderDict.keySet()) { // All folders in the current course
                System.out.println(key);
            }
            System.out.println("\nSkriv navnet paa mappen du vil velge:");
            String name = scannerObjekt.nextLine();

            for (String key : folderDict.keySet()) { // Checks if userinput matches any existing folders
                if (name.equals(key)) {
                    folderName = name;
                    folderID = folderDict.get(key)[0];
                    allowAnonymity = folderDict.get(key)[1];
                    choosenFolder = true;
                }
            }

        }
    }

    // Let's user choose between to create post/reply or read post
    private static void choosePost() {
        boolean choosenPost = false;

        PostCtrl postCtrl = new PostCtrl(folderID);
        postCtrl.connect();
        Map<String, String[]> postDict = postCtrl.getPostDict(); // threadID : [thread title, desc, tag]

        while (!choosenPost) { // Continues until user has finished action
            System.out.println("\nDisse postene har du tilgang til:");
            for (String key : postDict.keySet()) { // All posts/threads in the folder
                System.out.println(postDict.get(key)[0] + " id: " + key);
            }
            System.out.println("Lag ny");
            System.out.println("\nVelg en postID eller lag en ny:");
            String postName = scannerObjekt.nextLine();

            if (postName.equals("Lag ny")) { // If the user chooses to create a new post/thread
                System.out.println("\nSkriv en titel:");
                String in_titel = scannerObjekt.nextLine(); // title

                System.out.println("\nSkriv en beskrivelse:");
                String in_description = scannerObjekt.nextLine(); // Description

                boolean validInput = false;
                String in_tag = new String();
                while (!validInput) { // Continues until user chooses one of the available tags
                    String[] tags = { "Question", "Announcement", "Homework", "Homework solution", "Lectures note", //Available tags
                            "General announcement" };
                    System.out.println("\nVelg en av tagsene;\nQuestion, Announcement, Homework,"
                            + " Homework solution, Lectures note eller General announcement:");
                    in_tag = scannerObjekt.nextLine();
                    if (Arrays.stream(tags).anyMatch(in_tag::equals)) { //Correct input
                        validInput = true;
                    }
                }
                postCtrl.createPost(name, userID, in_titel, in_description, in_tag);
                choosenPost = true;


            } else { //  If the user chooses to view a post
                for (String key : postDict.keySet()) {
                    if (postName.equals(key)) { //Finds choosen post
                        postCtrl.viewPost(userID, key);

                        // threadID : [thread title, desc, tag]
                        System.out.println("\nDu er naa i " + postDict.get(key)[0] + ", id: " + key);
                        System.out.println("\nBeskrivelse:\n" + postDict.get(key)[1]);
                        System.out.println("\n#" + postDict.get(key)[2]);

                        boolean response = false;
                        while (!response) {// Continues until user has choosen between creating a reply, or to quit
                            System.out.println("\nSkriv hva du vil gjoere: \nAvslutt \nSvar\n");
                            String input = scannerObjekt.nextLine();
                            if (input.equals("Avslutt")) { //Quit
                                response = true;
                                choosenPost = true;
                            } else if (input.equals("Svar")) { //Create reply
                                System.out.println("\nSkriv svaret ditt paa posten:");
                                String text = scannerObjekt.nextLine();
                                postCtrl.createReply(name, userID, text, key);
                                response = true;
                                choosenPost = true;
                            }
                        }

                    }
                }
            }

        }
    }
}
