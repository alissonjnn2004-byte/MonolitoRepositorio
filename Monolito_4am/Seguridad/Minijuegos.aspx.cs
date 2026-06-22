using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Monolito4am.Seguridad
{
    public partial class Minijuegos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Validar que el usuario esté logueado (sesión iniciada)
            if (Session["UsuarioID"] == null)
            {
                Response.Redirect("~/Seguridad/Login.aspx");
            }
        }
    }
}
