using System;
using System.Web.UI;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using Capa_Negocio;
using Capa_Datos;

namespace Monolito4am.Seguridad
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string cedula = txtCedula.Text.Trim();
            string pass = txtPassword.Text.Trim();

            // Obtenemos el resultado de la validación
            string resultado = CN_tbl_usuario.ValidarAccesoConContador(cedula, pass);

            // LA LÍNEA SIGUIENTE ES LA QUE FALTABA O ESTABA MAL:
            switch (resultado)
            {
                case "OK":
                    // 1. Buscamos al usuario para obtener su correo
                    var usuarioLogueado = CN_tbl_usuario.traerUsuarioPorCedula(cedula);

                    if (usuarioLogueado != null && !string.IsNullOrEmpty(usuarioLogueado.usu_correo))
                    {
                        // 2. Generamos el código OTP
                        Random rnd = new Random();
                        string codigoGenerado = rnd.Next(100000, 999999).ToString();

                        // 3. Guardamos el código en la base de datos
                        CN_tbl_usuario.GuardarOTP(cedula, codigoGenerado);

                        // 4. Enviamos el correo con el QR
                        Mail.EnviarOTP(usuarioLogueado.usu_correo, codigoGenerado);

                        // 5. Redirigimos a la verificación
                        Response.Redirect("VerificarOTP.aspx?cedula=" + cedula);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                            "Swal.fire('Error', 'El usuario no tiene un correo registrado.', 'error');", true);
                    }
                    break;

                case "FALLO_1":
                    ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                        "Swal.fire('Intento 1', 'Contraseña incorrecta. Te quedan 2 intentos.', 'warning');", true);
                    break;

                case "FALLO_2":
                    ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                        "Swal.fire('Intento 2', 'Contraseña incorrecta. ¡Última oportunidad!', 'error');", true);
                    break;

                case "BLOQUEADO_RECIEN":
                    ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                        "Swal.fire('Intento 3', 'Cuenta bloqueada por seguridad.', 'error');", true);
                    break;

                case "BLOQUEADO":
                    ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                        "Swal.fire('Bloqueado', 'Esta cuenta ya está fuera de servicio.', 'error');", true);
                    break;
            }
        }


        protected void lnk_login_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");


        }
    }
}


