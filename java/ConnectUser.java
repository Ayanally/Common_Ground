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

@WebServlet("/connect")
public class ConnectUser extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        String currentUser = (String) session.getAttribute("userEmail");
        String targetUser = req.getParameter("user_email");
        String action = req.getParameter("action"); // connect, accept, reject, cancel

        if (currentUser == null) {
            out.print("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/new_user";
        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, password);

            if ("connect".equals(action)) {
                // Check if already exists
                PreparedStatement checkStmt = con.prepareStatement(
                        "SELECT status FROM connections WHERE (user_email = ? AND connected_email = ?) OR (user_email = ? AND connected_email = ?)"
                );
                checkStmt.setString(1, currentUser);
                checkStmt.setString(2, targetUser);
                checkStmt.setString(3, targetUser);
                checkStmt.setString(4, currentUser);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    String status = rs.getString("status");
                    if ("pending".equals(status)) {
                        out.print("{\"success\": false, \"message\": \"Request already pending\"}");
                    } else if ("accepted".equals(status)) {
                        out.print("{\"success\": false, \"message\": \"Already connected!\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"Request already exists\"}");
                    }
                    rs.close();
                    checkStmt.close();
                    con.close();
                    return;
                }
                rs.close();
                checkStmt.close();

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO connections (user_email, connected_email, status) VALUES (?, ?, 'pending')"
                );
                ps.setString(1, currentUser);
                ps.setString(2, targetUser);
                ps.executeUpdate();
                out.print("{\"success\": true, \"message\": \"Connection request sent!\"}");

            } else if ("accept".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                        "UPDATE connections SET status = 'accepted' WHERE user_email = ? AND connected_email = ?"
                );
                ps.setString(1, targetUser);
                ps.setString(2, currentUser);
                int updated = ps.executeUpdate();
                if (updated > 0) {
                    out.print("{\"success\": true, \"message\": \"Connection accepted!\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"No pending request found\"}");
                }

            } else if ("reject".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM connections WHERE user_email = ? AND connected_email = ? AND status = 'pending'"
                );
                ps.setString(1, targetUser);
                ps.setString(2, currentUser);
                int deleted = ps.executeUpdate();
                if (deleted > 0) {
                    out.print("{\"success\": true, \"message\": \"Connection rejected\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"No pending request found\"}");
                }

            } else if ("cancel".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM connections WHERE user_email = ? AND connected_email = ? AND status = 'pending'"
                );
                ps.setString(1, currentUser);
                ps.setString(2, targetUser);
                int deleted = ps.executeUpdate();
                if (deleted > 0) {
                    out.print("{\"success\": true, \"message\": \"Request cancelled\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"No pending request found\"}");
                }
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        String currentUser = (String) session.getAttribute("userEmail");

        if (currentUser == null) {
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/new_user";
        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, password);

            // Get pending connection requests (for current user)
            PreparedStatement ps = con.prepareStatement(
                    "SELECT c.user_email, u.Fname, u.Level, u.City " +
                            "FROM connections c " +
                            "JOIN userlist u ON c.user_email = u.Email " +
                            "WHERE c.connected_email = ? AND c.status = 'pending'"
            );
            ps.setString(1, currentUser);
            ResultSet rs = ps.executeQuery();

            JSONObject response = new JSONObject();
            JSONArray requests = new JSONArray();

            while (rs.next()) {
                JSONObject reqObj = new JSONObject();
                reqObj.put("email", rs.getString("user_email"));
                reqObj.put("name", rs.getString("Fname"));
                reqObj.put("level", rs.getString("Level"));
                reqObj.put("city", rs.getString("City"));
                requests.put(reqObj);
            }

            response.put("requests", requests);
            out.print(response.toString());
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}