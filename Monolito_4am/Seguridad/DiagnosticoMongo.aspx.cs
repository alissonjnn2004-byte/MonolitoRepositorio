using System;
using System.Text;
using System.Web.UI;
using Capa_Datos;

namespace Monolito_4am.Seguridad
{
    public partial class DiagnosticoMongo : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var sb = new StringBuilder();
            try
            {
                var db = new MongoDBContext();
                sb.AppendLine("Origen configuración: " + MongoDBContext.OrigenConexion);
                sb.AppendLine("Cadena de conexión: " + MongoDBContext.UltimaCadenaConexion);
                sb.AppendLine("Base de datos: " + MongoDBContext.NombreBaseDatos);
                sb.AppendLine("Colección usuarios: usuarios");
                sb.AppendLine();
                sb.AppendLine("Total documentos en 'usuarios': " + db.ContarUsuarios());
                sb.AppendLine();
                sb.AppendLine("Últimos usuarios (lo que la app ve en MongoDB):");
                foreach (var linea in db.ListarResumenUsuarios())
                    sb.AppendLine("  - " + linea);

                sb.AppendLine();
                sb.AppendLine("En Compass abra EXACTAMENTE:");
                sb.AppendLine("  " + MongoDBContext.UltimaCadenaConexion);
                sb.AppendLine("  → base '" + MongoDBContext.NombreBaseDatos + "' → colección 'usuarios' → botón Actualizar");
            }
            catch (Exception ex)
            {
                sb.AppendLine("ERROR: " + ex.Message);
            }

            salida.InnerText = sb.ToString();
        }
    }
}
