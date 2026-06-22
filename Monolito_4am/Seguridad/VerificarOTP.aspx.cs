using Capa_Negocio;
using System;
using System.Web.UI;

namespace Monolito_4am.Seguridad
{
    public partial class VerificarOTP : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(Request.QueryString["cedula"]))
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        // Este es el método que detecta el QR
        protected void btnProcesarQR_Click(object sender, EventArgs e)
        {
            string codigoLeido = hfCodigoEscaneado.Value.Trim();
            string cedula = Request.QueryString["cedula"];

            if (!string.IsNullOrEmpty(cedula) && !string.IsNullOrEmpty(codigoLeido))
            {
                var usuario = CN_tbl_usuario.traerUsuarioPorCedula(cedula);

                // Comparamos el código escaneado con el de la base de datos
                string codigoEncriptado =
                CN_tbl_usuario.EncriptarOTP(codigoLeido);

                if (usuario != null &&
                    usuario.usu_codigo_OTP.Trim()
                    == codigoEncriptado)
                {
                    // Creamos las sesiones
                    Session["Perfil"] = usuario.tusu_id;
                    Session["UsuarioID"] = usuario.usu_id;
                    Session["usuario"] = usuario.usu_nombres;

                    // Redirección según rol
                    if (usuario.tusu_id == 1)
                        Response.Redirect("MenuAdministrador.aspx");
                    else
                        Response.Redirect("nuevo_tbl_producto.aspx");
                }
                else
                {
                    // Si falla, recargamos la página para que el escáner se reinicie
                    Response.Write("<script>alert('Código QR no válido'); window.location=window.location.href;</script>");
                }
            }
        }

        protected void btnRegresarLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        protected void btnVerificarManual_Click(object sender, EventArgs e)
        {
            string codigoIngresado =
                txtCodigoManual.Text.Trim();

            string cedula =
                Request.QueryString["cedula"];

            if (!string.IsNullOrEmpty(cedula)
                && !string.IsNullOrEmpty(codigoIngresado))
            {
                var usuario =
                    CN_tbl_usuario
                    .traerUsuarioPorCedula(cedula);

                string codigoEncriptado =
                    CN_tbl_usuario
                    .EncriptarOTP(codigoIngresado);

                if (usuario != null
                    && usuario.usu_codigo_OTP.Trim()
                    == codigoEncriptado)
                {
                    Session["Perfil"] =
                        usuario.tusu_id;

                    Session["UsuarioID"] =
                        usuario.usu_id;

                    Session["usuario"] =
                        usuario.usu_nombres;

                    if (usuario.tusu_id == 1)
                        Response.Redirect(
                            "MenuAdministrador.aspx");
                    else
                        Response.Redirect(
                            "Minijuegos.aspx");
                }
                else
                {
                    Response.Write(
                        "<script>alert('Código incorrecto');</script>");
                }
            }
        
    }
    }
}