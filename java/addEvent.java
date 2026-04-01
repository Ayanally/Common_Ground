import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.swing.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/addEvent")
public class addEvent extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String eventName= req.getParameter("eventName");
        String eventDate= req.getParameter("eventDate");
        String eventTime= req.getParameter("eventTime");
        String eventLocation= req.getParameter("eventLocation");
        String eventSport= req.getParameter("eventSport");
        String eventLevel= req.getParameter("eventLevel");
        String eventDesc= req.getParameter("eventDesc");

        String url= "jdbc:mysql://localhost:3306/users";
        String user="root";
        String password="Salvi360@";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con= DriverManager.getConnection(url, user, password);

            con.setAutoCommit(true);

            PreparedStatement ps= con.prepareStatement("INSERT INTO eventslist(name, eventDate, eventTime, location, sports, level, description) VALUES (?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, eventName);
            ps.setString(2, eventDate);
            ps.setString(3, eventTime);
            ps.setString(4, eventLocation);
            ps.setString(5, eventSport);
            ps.setString(6, eventLevel);
            ps.setString(7, eventDesc);

            ps.executeUpdate();

        }
        catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("ERROR: " + e.getMessage());
        }

        resp.sendRedirect("dashboard.html");

    }
}
