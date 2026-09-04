package com.tuyweb.jsp_servlets_adso_68;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "Login", urlPatterns = {"/Login"})
public class Login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException {
        String url = "jdbc:mysql://localhost:3306/adso_68_jsp";
        String user = "root";
        String password = "";

        String userForm = request.getParameter("user");
        String passwordForm = request.getParameter("password");
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(url, user, password); Statement stmt = conn.createStatement();) {

            ResultSet rs = stmt.executeQuery("SELECT * FROM users "
                    + "WHERE user='" + userForm + "' AND password='" + passwordForm + "'");
            if (rs.next()) {
                String userDB = rs.getString("user");
                System.out.println(userDB + ":" + rs.getString("password"));

                HttpSession session = request.getSession();
                session.setAttribute("user", userDB);
                response.sendRedirect("./dashboard.jsp");
            }else{
                response.sendRedirect("./?error=Usuario o clave incorrecta");
            }
        } catch (SQLException e) {
            e.printStackTrace();            
            response.sendRedirect("./?error=Hubo un error, comuniquese con soporte.");
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
