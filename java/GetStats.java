import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/getStats")
public class GetStats extends HttpServlet {

    private static final double EARTH_RADIUS_KM = 6371;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/new_user";
        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, password);

            // 1. Nearby matches count (users within 10 km who are not self)
            PreparedStatement userStmt = con.prepareStatement(
                    "SELECT Latitude, Longitude FROM userlist WHERE Email = ?"
            );
            userStmt.setString(1, userEmail);
            ResultSet userRs = userStmt.executeQuery();

            int nearbyMatches = 0;
            if (userRs.next()) {
                double lat = userRs.getDouble("Latitude");
                double lng = userRs.getDouble("Longitude");
                if (lat != 0 && lng != 0) {
                    String nearbyQuery =
                            "SELECT COUNT(*) as count FROM userlist " +
                                    "WHERE Email != ? " +
                                    "AND Latitude IS NOT NULL AND Longitude IS NOT NULL " +
                                    "AND (" + EARTH_RADIUS_KM + " * acos(cos(radians(?)) * cos(radians(Latitude)) " +
                                    "  * cos(radians(Longitude) - radians(?)) + sin(radians(?)) * sin(radians(Latitude)))" +
                                    ") <= 10";
                    PreparedStatement nearbyStmt = con.prepareStatement(nearbyQuery);
                    nearbyStmt.setString(1, userEmail);
                    nearbyStmt.setDouble(2, lat);
                    nearbyStmt.setDouble(3, lng);
                    nearbyStmt.setDouble(4, lat);
                    ResultSet nearbyRs = nearbyStmt.executeQuery();
                    if (nearbyRs.next()) {
                        nearbyMatches = nearbyRs.getInt("count");
                    }
                    nearbyRs.close();
                    nearbyStmt.close();
                }
            }
            userRs.close();
            userStmt.close();

            // 2. Upcoming games count (events the user has joined or created with date >= today)
            // Assuming event_participants table exists; if not, fallback to events created by user
            int upcomingGames = 0;
            try {
                PreparedStatement upcomingStmt = con.prepareStatement(
                        "SELECT COUNT(DISTINCT e.id) as count " +
                                "FROM eventslist e " +
                                "LEFT JOIN event_participants ep ON e.id = ep.event_id " +
                                "WHERE (ep.user_email = ? OR e.created_by = ?) AND e.date >= CURDATE()"
                );
                upcomingStmt.setString(1, userEmail);
                upcomingStmt.setString(2, userEmail);
                ResultSet upcomingRs = upcomingStmt.executeQuery();
                if (upcomingRs.next()) {
                    upcomingGames = upcomingRs.getInt("count");
                }
                upcomingRs.close();
                upcomingStmt.close();
            } catch (Exception e) {
                // If event_participants table doesn't exist, just count created events
                PreparedStatement fallbackStmt = con.prepareStatement(
                        "SELECT COUNT(*) as count FROM eventslist WHERE created_by = ? AND date >= CURDATE()"
                );
                fallbackStmt.setString(1, userEmail);
                ResultSet fallbackRs = fallbackStmt.executeQuery();
                if (fallbackRs.next()) {
                    upcomingGames = fallbackRs.getInt("count");
                }
                fallbackRs.close();
                fallbackStmt.close();
            }

            con.close();

            JSONObject response = new JSONObject();
            response.put("nearbyMatches", nearbyMatches);
            response.put("upcomingGames", upcomingGames);
            out.print(response.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}