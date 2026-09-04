<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Iniciar sesión</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-slate-100 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white w-full max-w-md rounded-2xl shadow-lg p-8">
        <div class="text-center mb-8">
            <div class="w-14 h-14 bg-blue-600 rounded-xl flex items-center justify-center mx-auto mb-4">
                <span class="text-white text-2xl font-bold">U</span>
            </div>
            <h1 class="text-2xl font-bold text-slate-800">Iniciar sesión</h1>
            <p class="text-slate-500 mt-1">Ingresa tus datos para continuar</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-5 text-sm">
                <strong>Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>

        <% if (request.getParameter("success") != null) { %>
            <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-5 text-sm">
                <%= request.getParameter("success") %>
            </div>
        <% } %>

        <form action="./Login" method="POST" class="space-y-5">
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Usuario</label>
                <input type="text" name="user" placeholder="Ingresa tu usuario" required
                       class="w-full px-4 py-3 border border-slate-300 rounded-lg outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
            </div>

            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Contraseña</label>
                <input type="password" name="password" placeholder="Ingresa tu contraseña" required
                       class="w-full px-4 py-3 border border-slate-300 rounded-lg outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
            </div>

            <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 rounded-lg cursor-pointer transition">
                Ingresar
            </button>
        </form>

        <div class="mt-6 pt-6 border-t border-slate-200 text-center">
            <p class="text-sm text-slate-500">
                ¿No tienes una cuenta?
                <a href="./register.jsp" class="text-blue-600 hover:text-blue-700 font-semibold">
                    Crear cuenta
                </a>
            </p>
        </div>
    </div>
</body>
</html>

