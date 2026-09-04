<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("./?error=Inicia sesion primero");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/adso_68_jsp";
    String dbUser = "root";
    String dbPassword = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String mensaje = null;
    String error = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection(
            url,
            dbUser,
            dbPassword
        );

        String accion = request.getParameter("accion");

        // ========================
        // CREAR
        // ========================
        if ("crear".equals(accion)) {

            String usuario = request.getParameter("usuario");
            String clave = request.getParameter("clave");

            String sql =
                "INSERT INTO users (user, password) VALUES (?, ?)";

            ps = conn.prepareStatement(sql);

            ps.setString(1, usuario);
            ps.setString(2, clave);

            ps.executeUpdate();

            mensaje = "Usuario creado correctamente";
        }

        // ========================
        // EDITAR
        // ========================
        else if ("editar".equals(accion)) {

            int id =
                Integer.parseInt(
                    request.getParameter("id")
                );

            String usuario =
                request.getParameter("usuario");

            String clave =
                request.getParameter("clave");

            String sql =
                "UPDATE users "
                + "SET user = ?, password = ? "
                + "WHERE id = ?";

            ps = conn.prepareStatement(sql);

            ps.setString(1, usuario);
            ps.setString(2, clave);
            ps.setInt(3, id);

            ps.executeUpdate();

            mensaje = "Usuario actualizado correctamente";
        }

        // ========================
        // ELIMINAR
        // ========================
        else if ("eliminar".equals(accion)) {

            int id =
                Integer.parseInt(
                    request.getParameter("id")
                );

            String sql =
                "DELETE FROM users WHERE id = ?";

            ps = conn.prepareStatement(sql);

            ps.setInt(1, id);

            ps.executeUpdate();

            mensaje = "Usuario eliminado correctamente";
        }

    } catch (Exception e) {
        error = e.getMessage();
    }
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Administración de usuarios</title>

        <!-- TailwindCSS -->
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    </head>

    <body class="bg-slate-100 min-h-screen">

        <!-- NAVBAR -->

        <nav class="bg-slate-900 text-white shadow">
            <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
                <h1 class="font-bold text-xl">CRUD Usuarios</h1>

                <div class="flex items-center gap-4">
                    <div class="text-sm">
                        Sesión: <span class="font-semibold"><%= session.getAttribute("user") %></span>
                    </div>

                    <a href="./Logout"
                       class="bg-red-600 hover:bg-red-700 text-white text-sm font-medium px-4 py-2 rounded-lg transition">
                        Cerrar sesión
                    </a>
                </div>
            </div>
        </nav>


        <!-- CONTENIDO -->

        <main class="max-w-6xl mx-auto px-6 py-10">


            <!-- MENSAJE -->

            <% if (mensaje != null) { %>

            <div
                class="
                mb-6
                bg-green-100
                border
                border-green-300
                text-green-800
                px-5
                py-3
                rounded-lg
                "
                >

                <%= mensaje %>

            </div>

            <% } %>


            <!-- ERROR -->

            <% if (error != null) { %>

            <div
                class="
                mb-6
                bg-red-100
                border
                border-red-300
                text-red-800
                px-5
                py-3
                rounded-lg
                "
                >

                <strong>Error:</strong>

                <%= error %>

            </div>

            <% } %>


            <!-- HEADER -->

            <div
                class="
                flex
                justify-between
                items-center
                mb-6
                "
                >

                <div>

                    <h2
                        class="
                        text-3xl
                        font-bold
                        text-slate-800
                        "
                        >
                        Usuarios
                    </h2>

                    <p class="text-slate-500">
                        Administración de usuarios del sistema
                    </p>

                </div>


                <button
                    onclick="abrirCrear()"

                    class="
                    bg-blue-600
                    hover:bg-blue-700
                    text-white
                    font-medium
                    px-5
                    py-3
                    rounded-lg
                    shadow
                    cursor-pointer
                    transition
                    "
                    >

                    + Nuevo usuario

                </button>

            </div>


            <!-- TABLA -->

            <div
                class="
                bg-white
                rounded-xl
                shadow
                overflow-hidden
                "
                >

                <div class="overflow-x-auto">

                    <table class="w-full">

                        <thead class="bg-slate-50 border-b">

                            <tr>

                                <th
                                    class="
                                    px-6
                                    py-4
                                    text-left
                                    text-sm
                                    font-semibold
                                    text-slate-600
                                    "
                                    >
                                    ID
                                </th>

                                <th
                                    class="
                                    px-6
                                    py-4
                                    text-left
                                    text-sm
                                    font-semibold
                                    text-slate-600
                                    "
                                    >
                                    Usuario
                                </th>

                                <th
                                    class="
                                    px-6
                                    py-4
                                    text-left
                                    text-sm
                                    font-semibold
                                    text-slate-600
                                    "
                                    >
                                    Contraseña
                                </th>

                                <th
                                    class="
                                    px-6
                                    py-4
                                    text-center
                                    text-sm
                                    font-semibold
                                    text-slate-600
                                    "
                                    >
                                    Acciones
                                </th>

                            </tr>

                        </thead>


                        <tbody class="divide-y divide-slate-200">

                            <%

                                try {

                                    String sql =
                                        "SELECT * FROM users "
                                        + "ORDER BY id DESC";

                                    ps = conn.prepareStatement(sql);

                                    rs = ps.executeQuery();

                                    while (rs.next()) {

                                        int id =
                                            rs.getInt("id");

                                        String usuario =
                                            rs.getString("user");

                                        String clave =
                                            rs.getString("password");

                            %>

                            <tr class="hover:bg-slate-50">

                                <td
                                    class="
                                    px-6
                                    py-4
                                    text-slate-600
                                    "
                                    >

                                    <%= id %>

                                </td>


                                <td
                                    class="
                                    px-6
                                    py-4
                                    font-medium
                                    text-slate-800
                                    "
                                    >

                                    <%= usuario %>

                                </td>


                                <td
                                    class="
                                    px-6
                                    py-4
                                    text-slate-500
                                    "
                                    >

                                    ••••••••

                                </td>


                                <td class="px-6 py-4">

                                    <div
                                        class="
                                        flex
                                        justify-center
                                        gap-2
                                        "
                                        >

                                        <button

                                            onclick="
                                                editarUsuario(
                                                        '<%= id %>',
                                                        '<%= usuario %>',
                                                        '<%= clave %>'
                                                        )
                                            "

                                            class="
                                            bg-amber-500
                                            hover:bg-amber-600
                                            text-white
                                            px-4
                                            py-2
                                            rounded-lg
                                            text-sm
                                            cursor-pointer
                                            transition
                                            "
                                            >

                                            Editar

                                        </button>


                                        <button

                                            onclick="
                                                eliminarUsuario(
                                                        '<%= id %>',
                                                        '<%= usuario %>'
                                                        )
                                            "

                                            class="
                                            bg-red-600
                                            hover:bg-red-700
                                            text-white
                                            px-4
                                            py-2
                                            rounded-lg
                                            text-sm
                                            cursor-pointer
                                            transition
                                            "
                                            >

                                            Eliminar

                                        </button>

                                    </div>

                                </td>

                            </tr>

                            <%

                                    }

                                } catch (Exception e) {

                            %>

                            <tr>

                                <td
                                    colspan="4"
                                    class="
                                    px-6
                                    py-10
                                    text-center
                                    text-red-600
                                    "
                                    >

                                    Error cargando usuarios:

                                    <%= e.getMessage() %>

                                </td>

                            </tr>

                            <%

                                }

                            %>

                        </tbody>

                    </table>

                </div>

            </div>

        </main>



        <!-- =================================== -->
        <!-- MODAL CREAR -->
        <!-- =================================== -->

        <div
            id="modalCrear"
            class="
            fixed
            inset-0
            bg-black/50
            hidden
            items-center
            justify-center
            p-4
            "
            >

            <div
                class="
                bg-white
                w-full
                max-w-md
                rounded-xl
                shadow-2xl
                p-6
                "
                >

                <div
                    class="
                    flex
                    justify-between
                    items-center
                    mb-6
                    "
                    >

                    <h2
                        class="
                        text-xl
                        font-bold
                        text-slate-800
                        "
                        >
                        Nuevo usuario
                    </h2>


                    <button
                        onclick="cerrarCrear()"
                        class="
                        text-slate-500
                        hover:text-slate-800
                        text-2xl
                        cursor-pointer
                        "
                        >
                        ×
                    </button>

                </div>


                <form method="POST">

                    <input
                        type="hidden"
                        name="accion"
                        value="crear"
                        >


                    <div class="mb-4">

                        <label
                            class="
                            block
                            mb-2
                            text-sm
                            font-medium
                            text-slate-700
                            "
                            >
                            Usuario
                        </label>

                        <input
                            type="text"
                            name="usuario"
                            required

                            class="
                            w-full
                            border
                            border-slate-300
                            rounded-lg
                            px-4
                            py-3
                            outline-none
                            focus:ring-2
                            focus:ring-blue-500
                            "
                            >

                    </div>


                    <div class="mb-6">

                        <label
                            class="
                            block
                            mb-2
                            text-sm
                            font-medium
                            text-slate-700
                            "
                            >
                            Contraseña
                        </label>

                        <input
                            type="password"
                            name="clave"
                            required

                            class="
                            w-full
                            border
                            border-slate-300
                            rounded-lg
                            px-4
                            py-3
                            outline-none
                            focus:ring-2
                            focus:ring-blue-500
                            "
                            >

                    </div>


                    <div class="flex justify-end gap-3">

                        <button
                            type="button"
                            onclick="cerrarCrear()"

                            class="
                            bg-slate-200
                            hover:bg-slate-300
                            px-5
                            py-2
                            rounded-lg
                            cursor-pointer
                            "
                            >

                            Cancelar

                        </button>


                        <button
                            type="submit"

                            class="
                            bg-blue-600
                            hover:bg-blue-700
                            text-white
                            px-5
                            py-2
                            rounded-lg
                            cursor-pointer
                            "
                            >

                            Guardar

                        </button>

                    </div>

                </form>

            </div>

        </div>



        <!-- =================================== -->
        <!-- MODAL EDITAR -->
        <!-- =================================== -->

        <div
            id="modalEditar"
            class="
            fixed
            inset-0
            bg-black/50
            hidden
            items-center
            justify-center
            p-4
            "
            >

            <div
                class="
                bg-white
                w-full
                max-w-md
                rounded-xl
                shadow-2xl
                p-6
                "
                >

                <div
                    class="
                    flex
                    justify-between
                    items-center
                    mb-6
                    "
                    >

                    <h2
                        class="
                        text-xl
                        font-bold
                        "
                        >
                        Editar usuario
                    </h2>

                    <button
                        onclick="cerrarEditar()"
                        class="
                        text-slate-500
                        text-2xl
                        cursor-pointer
                        "
                        >
                        ×
                    </button>

                </div>


                <form method="POST">

                    <input
                        type="hidden"
                        name="accion"
                        value="editar"
                        >

                    <input
                        type="hidden"
                        name="id"
                        id="editarId"
                        >


                    <div class="mb-4">

                        <label
                            class="
                            block
                            mb-2
                            font-medium
                            "
                            >
                            Usuario
                        </label>

                        <input
                            type="text"
                            name="usuario"
                            id="editarUsuario"
                            required

                            class="
                            w-full
                            border
                            border-slate-300
                            rounded-lg
                            px-4
                            py-3
                            focus:ring-2
                            focus:ring-blue-500
                            outline-none
                            "
                            >

                    </div>


                    <div class="mb-6">

                        <label
                            class="
                            block
                            mb-2
                            font-medium
                            "
                            >
                            Contraseña
                        </label>

                        <input
                            type="password"
                            name="clave"
                            id="editarClave"
                            required

                            class="
                            w-full
                            border
                            border-slate-300
                            rounded-lg
                            px-4
                            py-3
                            focus:ring-2
                            focus:ring-blue-500
                            outline-none
                            "
                            >

                    </div>


                    <div class="flex justify-end gap-3">

                        <button
                            type="button"
                            onclick="cerrarEditar()"

                            class="
                            bg-slate-200
                            px-5
                            py-2
                            rounded-lg
                            cursor-pointer
                            "
                            >
                            Cancelar
                        </button>


                        <button
                            type="submit"

                            class="
                            bg-blue-600
                            hover:bg-blue-700
                            text-white
                            px-5
                            py-2
                            rounded-lg
                            cursor-pointer
                            "
                            >
                            Actualizar
                        </button>

                    </div>

                </form>

            </div>

        </div>



        <!-- =================================== -->
        <!-- MODAL ELIMINAR -->
        <!-- =================================== -->

        <div
            id="modalEliminar"

            class="
            fixed
            inset-0
            bg-black/50
            hidden
            items-center
            justify-center
            p-4
            "
            >

            <div
                class="
                bg-white
                max-w-md
                w-full
                rounded-xl
                shadow-2xl
                p-6
                "
                >

                <h2
                    class="
                    text-xl
                    font-bold
                    text-slate-800
                    mb-4
                    "
                    >
                    Eliminar usuario
                </h2>


                <p class="text-slate-600 mb-6">

                    ¿Está seguro de eliminar al usuario

                    <strong id="nombreEliminar"></strong>?

                </p>


                <form method="POST">

                    <input
                        type="hidden"
                        name="accion"
                        value="eliminar"
                        >

                    <input
                        type="hidden"
                        name="id"
                        id="eliminarId"
                        >


                    <div class="flex justify-end gap-3">

                        <button
                            type="button"
                            onclick="cerrarEliminar()"

                            class="
                            bg-slate-200
                            px-5
                            py-2
                            rounded-lg
                            cursor-pointer
                            "
                            >

                            Cancelar

                        </button>


                        <button
                            type="submit"

                            class="
                            bg-red-600
                            hover:bg-red-700
                            text-white
                            px-5
                            py-2
                            rounded-lg
                            cursor-pointer
                            "
                            >

                            Eliminar

                        </button>

                    </div>

                </form>

            </div>

        </div>



        <!-- JAVASCRIPT -->

        <script>

            function abrirCrear() {

                const modal =
                        document.getElementById("modalCrear");

                modal.classList.remove("hidden");
                modal.classList.add("flex");
            }


            function cerrarCrear() {

                const modal =
                        document.getElementById("modalCrear");

                modal.classList.add("hidden");
                modal.classList.remove("flex");
            }


            function editarUsuario(id, usuario, clave) {

                document.getElementById(
                        "editarId"
                        ).value = id;

                document.getElementById(
                        "editarUsuario"
                        ).value = usuario;

                document.getElementById(
                        "editarClave"
                        ).value = clave;


                const modal =
                        document.getElementById("modalEditar");

                modal.classList.remove("hidden");
                modal.classList.add("flex");
            }


            function cerrarEditar() {

                const modal =
                        document.getElementById("modalEditar");

                modal.classList.add("hidden");
                modal.classList.remove("flex");
            }


            function eliminarUsuario(id, usuario) {

                document.getElementById(
                        "eliminarId"
                        ).value = id;

                document.getElementById(
                        "nombreEliminar"
                        ).textContent = usuario;


                const modal =
                        document.getElementById("modalEliminar");

                modal.classList.remove("hidden");
                modal.classList.add("flex");
            }


            function cerrarEliminar() {

                const modal =
                        document.getElementById("modalEliminar");

                modal.classList.add("hidden");
                modal.classList.remove("flex");
            }

        </script>


    </body>
</html>

<%

    try {

        if (rs != null) {
            rs.close();
        }

        if (ps != null) {
            ps.close();
        }

        if (conn != null) {
            conn.close();
        }

    } catch (Exception e) {

    }

%>