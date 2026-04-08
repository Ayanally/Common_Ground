import com.mysql.cj.jdbc.Driver;
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
import java.sql.Statement;

@WebServlet("/getData")
public class EventList extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/new_user", user, password
            );

            Statement stmt = conn.createStatement();
            // Note: eventslist has no Email column
            ResultSet rs = stmt.executeQuery("SELECT name, level, city, sports, description FROM eventslist");

            JSONArray users = new JSONArray();
            while (rs.next()) {
                JSONObject userx = new JSONObject();
                userx.put("name", rs.getString("name"));
                userx.put("level", rs.getString("level"));
                userx.put("city", rs.getString("city"));
                userx.put("sports", rs.getString("sports"));
                userx.put("description", rs.getString("description"));
                // No email – events are not users
                users.put(userx);
            }
            out.print(users);
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        out.flush();
    }

    // POST method for updating user level (already implemented)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        String newLevel = req.getParameter("level");
        HttpSession session = req.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null || newLevel == null) {
            out.print("{\"success\": false, \"message\": \"User not logged in or invalid level\"}");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/new_user";
        String user = "root";
        String password = "root123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, password);

            String query = "UPDATE userlist SET Level = ? WHERE Email = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, newLevel);
            ps.setString(2, userEmail);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                session.setAttribute("userLevel", newLevel);
                out.print("{\"success\": true, \"message\": \"Level updated successfully!\", \"newLevel\": \"" + newLevel + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update level\"}");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Database error: " + e.getMessage() + "\"}");
        }
        out.flush();
    }
}