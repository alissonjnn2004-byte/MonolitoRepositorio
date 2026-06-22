using Capa_Datos;
using Capa_Negocio;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace Monolito_4am.Seguridad
{
    public partial class Registrar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarPerfiles();
            }
        }

        private void CargarPerfiles()
        {
            var perfiles = CN_tbl_tipo_usuario.ListarTipoUsuario();
            perfiles.Insert(0, new tbl_tipo_usuario { tusu_id = 0, tusu_nombre = "-- Seleccione Perfil --" });
            ddl_Perfil.DataSource = perfiles;
            ddl_Perfil.DataTextField = "tusu_nombre";
            ddl_Perfil.DataValueField = "tusu_id";
            ddl_Perfil.DataBind();
        }

        protected void btn_Registrar_Click(object sender, EventArgs e)
        {
            // Limpiamos mensajes anteriores en el Label
            lblMensaje.Text = "";
            lblMensaje.ForeColor = System.Drawing.Color.Red;
            lblMensaje.Visible = false;

            Page.Validate();
            if (!Page.IsValid)
            {
                lblMensaje.Visible = true;
                lblMensaje.Text = "Faltan campos por llenar. Revisa el formulario.";
                return;
            }

            string valorSeleccionado = ddl_Perfil.SelectedValue;
            string textoSeleccionado = ddl_Perfil.SelectedItem != null ? ddl_Perfil.SelectedItem.Text : "Ninguno";

            if (valorSeleccionado == "0" || string.IsNullOrEmpty(valorSeleccionado))
            {
                lblMensaje.Visible = true;
                lblMensaje.Text = $"Por favor, seleccione un perfil válido. El sistema detectó que seleccionó: {textoSeleccionado}";
                return;
            }

            try
            {
                // 1. Instancia limpia: Dejamos que la Capa de Negocio maneje fechas, estados y bloqueos automáticamente
                tbl_usuario u = new tbl_usuario
                {
                    usu_cedula = txtCedula.Text.Trim(),
                    usu_nick = txtNick.Text.Trim(),
                    usu_nombres = txtNombres.Text.Trim().ToUpper(),
                    usu_apellidos = txtApellidos.Text.Trim().ToUpper(),
                    usu_fecha_cumple = DateTime.Parse(txtFechaNacimiento.Text),
                    usu_correo = txtCorreo.Text.Trim(),
                    usu_celular = txtCelular.Text.Trim(),
                    usu_direccion = txtDireccion.Text.Trim(),
                    tusu_id = int.Parse(valorSeleccionado)
                };

                // 2. CORRECCIÓN CENTRAL: Llamamos al método pasando el objeto Y la contraseña en texto plano
                var resultado = CN_tbl_usuario.registrarUsuario(u, txtPassword.Text);

                if (resultado != null && resultado.usu_id > 0)
                {
                    // Lista donde consolidaremos las imágenes a guardar
                    List<byte[]> imagenesAGuardar = new List<byte[]>();

                    // 3. SOLUCIÓN AL POSTBACK: Si el control trae archivos los usamos; si no, jalamos de la sesión del Preview
                    if (fuFoto.HasFiles)
                    {
                        foreach (var archivo in fuFoto.PostedFiles)
                        {
                            byte[] imgBytes = new byte[archivo.ContentLength];
                            archivo.InputStream.Read(imgBytes, 0, archivo.ContentLength);
                            imagenesAGuardar.Add(imgBytes);
                        }
                    }
                    else if (Session["FotosTemp"] != null)
                    {
                        imagenesAGuardar = (List<byte[]>)Session["FotosTemp"];
                    }

                    // 4. Guardar imágenes asociadas al ID del usuario recién creado
                    if (imagenesAGuardar.Count > 0)
                    {
                        CN_tbl_usuario.GuardarImagenesUsuario(resultado.usu_id, imagenesAGuardar);
                    }

                    // Limpiamos la variable de sesión temporal por seguridad
                    Session["FotosTemp"] = null;

                    // Éxito: Mostrar mensaje verde y redirigir
                    lblMensaje.Visible = true;
                    lblMensaje.ForeColor = System.Drawing.Color.Green;
                    lblMensaje.Text = $"¡Usuario registrado correctamente! (ID {resultado.usu_id} en {Capa_Datos.MongoDBContext.NombreBaseDatos}.usuarios)";

                    ClientScript.RegisterStartupScript(this.GetType(), "success",
                        "setTimeout(function() { window.location='Login.aspx'; }, 1500);", true);
                }
                else
                {
                    lblMensaje.Visible = true;
                    lblMensaje.Text = "Error: No se pudo registrar el usuario en la base de datos (ID devuelto = 0).";
                }
            }
            catch (Exception ex)
            {
                lblMensaje.Visible = true;
                lblMensaje.Text = "Error de Base de Datos: " + ex.Message;
            }
        }

        protected void btnSubirPreview_Click(object sender, EventArgs e)
        {
            if (fuFoto.HasFiles)
            {
                List<byte[]> listaBytes = new List<byte[]>();
                pnlPreviews.Controls.Clear();
                long maxTamano = 2 * 1024 * 1024; // 2MB

                foreach (var archivo in fuFoto.PostedFiles)
                {
                    string extension = System.IO.Path.GetExtension(archivo.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "pop", "alert('Solo se aceptan imágenes JPG o PNG');", true);
                        return;
                    }

                    if (archivo.ContentLength > maxTamano)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "pop", "alert('El archivo " + archivo.FileName + " es demasiado grande (Máx 2MB)');", true);
                        return;
                    }

                    byte[] datos = new byte[archivo.ContentLength];
                    archivo.InputStream.Read(datos, 0, archivo.ContentLength);
                    listaBytes.Add(datos);

                    Image img = new Image();
                    img.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(datos);
                    img.CssClass = "preview-img";
                    img.Style.Add("width", "65px");
                    img.Style.Add("height", "65px");
                    img.Style.Add("border-radius", "50%");
                    img.Style.Add("margin-right", "10px");

                    pnlPreviews.Controls.Add(img);
                }

                // Guardamos en sesión para que persistan al hacer clic en el botón "Registrar"
                Session["FotosTemp"] = listaBytes;
            }
        }
    }
}