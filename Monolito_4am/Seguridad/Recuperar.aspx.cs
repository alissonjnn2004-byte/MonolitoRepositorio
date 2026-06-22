using Capa_Datos;
using Capa_Negocio;
using System;
using System.Linq; // Agregado para usar .ToArray() sin problemas
using System.Web;
using System.Web.UI;
using System.Net;
using System.IO;
using System.Text;

namespace Monolito_4am.Seguridad
{
    public partial class Recuperar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private string GenerarClaveTemporal()
        {
            string caracteres = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
            Random rd = new Random();
            char[] clave = new char[8];
            for (int i = 0; i < 8; i++)
            {
                clave[i] = caracteres[rd.Next(caracteres.Length)];
            }
            return new string(clave);
        }

        protected void btnRecuperar_Click(object sender, EventArgs e)
        {
            try
            {
                string cedula = txtCedulaRecuperar.Text.Trim();
                string claveProvisoria = GenerarClaveTemporal();

                byte[] claveCifrada = Encoding.UTF8.GetBytes(claveProvisoria);

                // Llamada a la capa de negocio para actualizar en SQL Server
                bool exito = CN_tbl_usuario.ActualizarPasswordTemporal(cedula, claveCifrada);

                if (exito)
                {
                    EnviarWhatsApp(cedula, claveProvisoria);
                }
                else
                {
                    lblMensaje.Text = "No se encontró el usuario con esa cédula.";
                }
            }
            catch (Exception ex)
            {
                lblMensaje.Text = "Error: " + ex.Message;
            }
        }

        private void EnviarWhatsApp(string cedula, string claveNueva)
        {
            var usuario = CN_tbl_usuario.traerUsuarioPorCedula(cedula);

            if (usuario != null && !string.IsNullOrEmpty(usuario.usu_celular))
            {
                string celular = usuario.usu_celular.Trim();

                // 1. Limpieza total del número: Solo dígitos
                // Esto quita espacios, guiones o el 0 inicial
                celular = new string(celular.Where(char.IsDigit).ToArray());
                if (celular.StartsWith("0")) celular = celular.Substring(1);

                // 2. Mensaje profesional con el nombre del usuario
                string mensaje = $"*CONTRASEÑA TEMPORAL*\n\n" +
                                 $"Hola *{usuario.usu_nombres}*,\n" +
                                 $"Se ha generado tu clave de acceso: *{claveNueva}*\n\n" +
                                 $"Atentamente: Sistema de Seguridad.";

                // 3. LA CLAVE: Usamos 'wa.me' con el código de país (593) 
                // Este formato obliga a WhatsApp a buscar el contacto y crear un chat aparte.
                string url =
                     $"https://api.whatsapp.com/send?phone=593{celular}&text={Uri.EscapeDataString(mensaje)}";

                // 4. Abrir en pestaña nueva
                ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "WhatsApp",
                $"window.open('{url}','_blank');",
                true
                );

                lblMensaje.Text = "Abriendo chat separado para: " + usuario.usu_nombres;
            }
            else
            {
                lblMensaje.Text = "No se pudo crear el chat. Verifique el número de celular.";
            }
        }
    }
}