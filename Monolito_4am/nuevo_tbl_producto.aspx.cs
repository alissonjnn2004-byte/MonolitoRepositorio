using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Monolito_4am
{
    public partial class nuevo_tbl_producto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Simular guardado exitoso
            string script = @"Swal.fire({
                title: '¡Éxito!',
                text: 'El producto se ha registrado correctamente.',
                icon: 'success',
                confirmButtonText: 'Aceptar'
            }).then((result) => {
                window.location = 'listar_tbl_producto.aspx';
            });";

            ScriptManager.RegisterStartupScript(this, GetType(), "SaveProductSuccess", script, true);
        }
    }
}