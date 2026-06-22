using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Monolito4am.Mantenimiento
{
    public partial class Principal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect(ResolveUrl("~/Seguridad/Login.aspx"));
                return;
            }

            if (!IsPostBack)
            {
                string username = Session["usuario"].ToString();
                lblUsername.Text = username;

                // Generar iniciales del avatar
                if (!string.IsNullOrEmpty(username))
                {
                    var parts = username.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length > 0)
                    {
                        string initials = parts[0][0].ToString();
                        if (parts.Length > 1)
                        {
                            initials += parts[1][0].ToString();
                        }
                        lblAvatarInitials.Text = initials.ToUpper();
                    }
                }

                // Mostrar rol
                if (Session["Perfil"] != null)
                {
                    int perfilId = Convert.ToInt32(Session["Perfil"]);
                    lblUserRole.Text = (perfilId == 1) ? "Administrador" : "Jugador";
                }
            }
        }

        protected void btnCerrarSesionGlobal_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect(ResolveUrl("~/Seguridad/Login.aspx"));
        }
    }
}