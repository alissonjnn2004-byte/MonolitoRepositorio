using Capa_Datos;
using Capa_Negocio;
using System;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Linq;
namespace Monolito_4am.Seguridad
{
    public partial class MenuAdministrador :
        System.Web.UI.Page
    {
        protected void Page_Load(
            object sender,
            EventArgs e
        )
        {
            if (!IsPostBack)
            {
                // Solo cargamos la tabla de usuarios
                CargarUsuarios();
            }
        }

        private void CargarUsuarios()
        {
            gvUsuarios.DataSource = CN_tbl_usuario.ListarUsuariosConFoto();
            gvUsuarios.DataBind();
        }



        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Creamos un objeto temporal con los datos de los cuadritos de texto
            tbl_usuario usuario = new tbl_usuario
            {
                usu_nombres = txtNombres.Text.Trim(),
                usu_cedula = txtCedula.Text.Trim(),
                usu_correo = txtCorreo.Text.Trim()
            };

            if (string.IsNullOrEmpty(hfUsuarioID.Value))
            {
                CN_tbl_usuario.registrarUsuario(usuario, "1234");
            }
            else
            {
                // ES EDICIÓN: Si tiene ID, actualizamos
                usuario.usu_id = int.Parse(hfUsuarioID.Value);
                CN_tbl_usuario.ActualizarUsuario(usuario);
            }

            LimpiarFormulario();
            CargarUsuarios();
        }

        protected void gvUsuariosRowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {

            {
                int id = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "Desbloquear")
                {
                    CN_tbl_usuario.DesbloquearUsuario(id);
                }
                else if (e.CommandName == "Editar")
                {
                    // Buscamos al usuario y ponemos sus datos en los cuadros de texto
                    var usu = CN_tbl_usuario.ObtenerUsuarioPorId(id);
                    if (usu != null)
                    {
                        hfUsuarioID.Value = usu.usu_id.ToString();
                        txtNombres.Text = usu.usu_nombres;
                        txtCedula.Text = usu.usu_cedula;
                        txtCorreo.Text = usu.usu_correo;
                        btnGuardar.Text = "Actualizar"; // Cambiamos el texto del botón
                    }
                }
                else if (e.CommandName == "Eliminar")
                {
                    CN_tbl_usuario.EliminarUsuario(id);
                }

                CargarUsuarios();
            }
        }

        private void LimpiarFormulario()
        {
            hfUsuarioID.Value = "";
            txtNombres.Text = "";
            txtCedula.Text = "";
            txtCorreo.Text = "";
            btnGuardar.Text = "Guardar";
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        // Restored btnCerrarSesion
        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear(); // Limpia las variables
            Session.Abandon(); // Destruye la sesión en el servidor
            Response.Redirect("Login.aspx");
        }
    }
}