import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/signup")
public class SignupPage extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String role= req.getParameter("signup-role");
        String Fname= req.getParameter("signup-fullname");
        String Email= req.getParameter("signup-email");
        String Password= req.getParameter("signup-pass");

        String url= "jdbc:mysql://localhost:3306/users";
        String user= "root";
        String pass= "Salvi360@";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, user, pass);

            PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM userlist WHERE Email = ?");
            checkStmt.setString(1, Email);
            ResultSet rs = checkStmt.executeQuery();

            if(rs.next()) {
                resp.sendRedirect("common-ground-simple.html?error=exists");
            }

            else {
                PreparedStatement ps = con.prepareStatement("INSERT INTO userlist(Fname, Email, Password, role) VALUES (?, ?, ?, ?)");
                ps.setString(1, Fname);
                ps.setString(2, Email);
                ps.setString(3, Password);
                ps.setString(4, role);

                int result = ps.executeUpdate();

                if(result>0) {
                    HttpSession session = req.getSession();
                    session.setAttribute("userEmail", Email);
                    session.setAttribute("userRole", role);
                    resp.sendRedirect("dashboard.html");
                }

                ps.close();
            }

            checkStmt.close();
            con.close();
        }

        catch (Exception e) {
            e.printStackTrace();
        }


    }
}
