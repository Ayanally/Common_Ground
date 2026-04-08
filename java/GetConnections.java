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

@WebServlet("/getConnections")
public class GetConnections extends HttpServlet {

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

            JSONObject response = new JSONObject();

            // 1. Pending requests RECEIVED
            String receivedQuery =
                    "SELECT u.Email, u.Fname, u.Level, u.City " +
                            "FROM connections c " +
                            "JOIN userlist u ON c.user_email = u.Email " +
                            "WHERE c.connected_email = ? AND c.status = 'pending'";
            PreparedStatement psReceived = con.prepareStatement(receivedQuery);
            psReceived.setString(1, currentUser);
            ResultSet rsReceived = psReceived.executeQuery();
            JSONArray received = new JSONArray();
            while (rsReceived.next()) {
                JSONObject obj = new JSONObject();
                obj.put("email", rsReceived.getString("Email"));
                obj.put("name", rsReceived.getString("Fname"));
                obj.put("level", rsReceived.getString("Level"));
                obj.put("city", rsReceived.getString("City"));
                received.put(obj);
            }
            response.put("received", received);

            // 2. Pending requests SENT
            String sentQuery =
                    "SELECT u.Email, u.Fname, u.Level, u.City " +
                            "FROM connections c " +
                            "JOIN userlist u ON c.connected_email = u.Email " +
                            "WHERE c.user_email = ? AND c.status = 'pending'";
            PreparedStatement psSent = con.prepareStatement(sentQuery);
            psSent.setString(1, currentUser);
            ResultSet rsSent = psSent.executeQuery();
            JSONArray sent = new JSONArray();
            while (rsSent.next()) {
                JSONObject obj = new JSONObject();
                obj.put("email", rsSent.getString("Email"));
                obj.put("name", rsSent.getString("Fname"));
                obj.put("level", rsSent.getString("Level"));
                obj.put("city", rsSent.getString("City"));
                sent.put(obj);
            }
            response.put("sent", sent);

            // 3. Connected people (accepted)
            String connectedQuery =
                    "SELECT DISTINCT u.Email, u.Fname, u.Level, u.City " +
                            "FROM connections c " +
                            "JOIN userlist u ON (c.user_email = u.Email OR c.connected_email = u.Email) " +
                            "WHERE c.status = 'accepted' AND u.Email != ? " +
                            "AND (c.user_email = ? OR c.connected_email = ?)";
            PreparedStatement psConnected = con.prepareStatement(connectedQuery);
            psConnected.setString(1, currentUser);
            psConnected.setString(2, currentUser);
            psConnected.setString(3, currentUser);
            ResultSet rsConnected = psConnected.executeQuery();
            JSONArray connected = new JSONArray();
            while (rsConnected.next()) {
                JSONObject obj = new JSONObject();
                obj.put("email", rsConnected.getString("Email"));
                obj.put("name", rsConnected.getString("Fname"));
                obj.put("level", rsConnected.getString("Level"));
                obj.put("city", rsConnected.getString("City"));
                connected.put(obj);
            }
            response.put("connected", connected);

            con.close();
            out.print(response.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}