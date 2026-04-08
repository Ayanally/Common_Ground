import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/nearby")
public class NearbyUsers extends HttpServlet {

    private static final double EARTH_RADIUS_KM = 6371;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        String currentUserEmail = (String) session.getAttribute("userEmail");

        if (currentUserEmail == null) {
            out.print("{\"error\": \"User not logged in\"}");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/new_user";
        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, password);

            // Get current user's location
            PreparedStatement currentUserStmt = con.prepareStatement(
                    "SELECT Latitude, Longitude, Level, City FROM userlist WHERE Email = ?"
            );
            currentUserStmt.setString(1, currentUserEmail);
            ResultSet currentUserRs = currentUserStmt.executeQuery();

            if (!currentUserRs.next()) {
                out.print("{\"error\": \"User location not found\"}");
                con.close();
                return;
            }

            double currentLat = currentUserRs.getDouble("Latitude");
            double currentLng = currentUserRs.getDouble("Longitude");
            String currentLevel = currentUserRs.getString("Level");
            String currentCity = currentUserRs.getString("City");

            if (currentLat == 0 && currentLng == 0) {
                out.print("{\"nearby\": [], \"message\": \"Update your location first\"}");
                con.close();
                return;
            }

            String radius = req.getParameter("radius");
            if (radius == null) radius = "10";

            String query =
                    "SELECT Email, Fname, Level, City, Latitude, Longitude, " +
                            "(" + EARTH_RADIUS_KM + " * acos(cos(radians(?)) * cos(radians(Latitude)) " +
                            "* cos(radians(Longitude) - radians(?)) + sin(radians(?)) * sin(radians(Latitude)))" +
                            ") AS distance_km " +
                            "FROM userlist " +
                            "WHERE Email != ? " +
                            "AND Latitude IS NOT NULL AND Longitude IS NOT NULL " +
                            "HAVING distance_km <= ? " +
                            "ORDER BY distance_km ASC";

            PreparedStatement ps = con.prepareStatement(query);
            ps.setDouble(1, currentLat);
            ps.setDouble(2, currentLng);
            ps.setDouble(3, currentLat);
            ps.setString(4, currentUserEmail);
            ps.setString(5, radius);

            ResultSet rs = ps.executeQuery();

            JSONArray nearbyUsers = new JSONArray();
            while (rs.next()) {
                JSONObject userObj = new JSONObject();
                userObj.put("email", rs.getString("Email"));
                userObj.put("name", rs.getString("Fname"));
                userObj.put("level", rs.getString("Level"));
                userObj.put("city", rs.getString("City"));
                userObj.put("distance_km", Math.round(rs.getDouble("distance_km") * 10) / 10.0);
                userObj.put("latitude", rs.getDouble("Latitude"));
                userObj.put("longitude", rs.getDouble("Longitude"));
                nearbyUsers.put(userObj);
            }

            JSONObject response = new JSONObject();
            response.put("nearby", nearbyUsers);
            response.put("total_nearby", nearbyUsers.length());

            out.print(response.toString());
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            out.print("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }

        String latitude = req.getParameter("latitude");
        String longitude = req.getParameter("longitude");

        if (latitude == null || longitude == null) {
            out.print("{\"success\": false, \"message\": \"Missing location data\"}");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/new_user";
        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, password);

            PreparedStatement ps = con.prepareStatement(
                    "UPDATE userlist SET Latitude = ?, Longitude = ? WHERE Email = ?"
            );
            ps.setDouble(1, Double.parseDouble(latitude));
            ps.setDouble(2, Double.parseDouble(longitude));
            ps.setString(3, userEmail);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                out.print("{\"success\": true, \"message\": \"Location updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update location\"}");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}