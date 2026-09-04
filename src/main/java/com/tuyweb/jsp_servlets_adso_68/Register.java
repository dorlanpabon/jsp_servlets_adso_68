package com.tuyweb.jsp_servlets_adso_68;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "Register", urlPatterns = {"/Register"})
public class Register extends HttpServlet {

    private final String url = "jdbc:mysql://localhost:3306/adso_68_jsp";
    private final String dbUser = "root";
    private final String dbPassword = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("./register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("user");
        String clave = request.getParameter("password");
        String confirmarClave = request.getParameter("confirmPassword");

        if (usuario == null || usuario.trim().isEmpty()
                || clave == null || clave.trim().isEmpty()
                || confirmarClave == null || confirmarClave.trim().isEmpty()) {
            redirectError(response, "Todos los campos son obligatorios");
            return;
        }

        if (!clave.equals(confirmarClave)) {
            redirectError(response, "Las contraseñas no coinciden");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPassword)) {

                String sqlBuscar = "SELECT id FROM users WHERE user = ?";

                try (PreparedStatement psBuscar = conn.prepareStatement(sqlBuscar)) {
                    psBuscar.setString(1, usuario);

                    try (ResultSet rs = psBuscar.executeQuery()) {
                        if (rs.next()) {
                            redirectError(response, "El usuario ya existe");
                            return;
                        }
                    }
                }

                String sqlInsert = "INSERT INTO users (user, password) VALUES (?, ?)";

                try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                    psInsert.setString(1, usuario);
                    psInsert.setString(2, clave);
                    psInsert.executeUpdate();
                }

                String mensaje = URLEncoder.encode(
                        "Usuario registrado correctamente",
                        StandardCharsets.UTF_8
                );

                response.sendRedirect("./?success=" + mensaje);
            }

        } catch (ClassNotFoundException e) {
            redirectError(response, "No se encontró el driver de MySQL");
        } catch (Exception e) {
            redirectError(response, "Error al registrar el usuario: " + e.getMessage());
        }
    }

    private void redirectError(HttpServletResponse response, String mensaje)
            throws IOException {

        String error = URLEncoder.encode(
                mensaje,
                StandardCharsets.UTF_8
        );

        response.sendRedirect("./register.jsp?error=" + error);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para registrar usuarios";
    }
}