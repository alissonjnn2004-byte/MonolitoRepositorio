using Capa_Negocio;
using System;
using System.Web.UI;

namespace Monolito_4am.Seguridad
{
    public partial class CrudProveedor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProveedores();
            }
        }

        private void CargarProveedores()
        {
            gvProveedores.DataSource = CN_tbl_proveedor.ListarProveedoresGrid();
            gvProveedores.DataBind();
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombreProv.Text.Trim();

            if (string.IsNullOrEmpty(nombre))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                    "Swal.fire('Atención', 'Debe ingresar el nombre del proveedor.', 'warning');", true);
                return;
            }

            if (string.IsNullOrEmpty(hfProveedorID.Value))
            {
                // CREAR
                CN_tbl_proveedor.RegistrarProveedor(nombre);

                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                    "Swal.fire('Éxito', 'Proveedor registrado correctamente.', 'success');", true);
            }
            else
            {
                // ACTUALIZAR
                int id = int.Parse(hfProveedorID.Value);
                CN_tbl_proveedor.ActualizarProveedor(id, nombre);

                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                    "Swal.fire('Éxito', 'Proveedor actualizado correctamente.', 'success');", true);
            }

            LimpiarFormulario();
            CargarProveedores();
        }

        protected void gvProveedores_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                var prov = CN_tbl_proveedor.ObtenerProveedorPorId(id);
                if (prov != null)
                {
                    hfProveedorID.Value = prov.prov_id.ToString();
                    txtNombreProv.Text = prov.prov_nombre;
                    btnGuardar.Text = "Actualizar";
                }
            }
            else if (e.CommandName == "EliminarLogico")
            {
                CN_tbl_proveedor.EliminarProveedor(id);

                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                    "Swal.fire('Eliminado', 'Proveedor inactivado. Los productos quedaron sin proveedor asignado.', 'success');", true);
            }
            else if (e.CommandName == "EliminarFisico")
            {
                CN_tbl_proveedor.EliminarProveedorFisico(id);

                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                    "Swal.fire('Eliminado', 'Borrado físico exitoso. Productos desvinculados.', 'success');", true);
            }

            CargarProveedores();
        }

        private void LimpiarFormulario()
        {
            hfProveedorID.Value = "";
            txtNombreProv.Text = "";
            btnGuardar.Text = "Guardar";
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }
    }
}
