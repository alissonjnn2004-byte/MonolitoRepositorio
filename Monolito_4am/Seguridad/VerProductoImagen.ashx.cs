using Capa_Negocio;
using System;
using System.IO;
using System.Web;

namespace Monolito_4am.Seguridad
{
    public class VerProductoImagen : IHttpHandler
    {
        public bool IsReusable => false;

        public void ProcessRequest(HttpContext context)
        {
            if (!int.TryParse(context.Request.QueryString["id"], out int productoId) || productoId <= 0)
            {
                EscribirPlaceholder(context);
                return;
            }

            var producto = CN_tbl_producto.ObtenerProductoPorId(productoId);
            if (producto == null || string.IsNullOrWhiteSpace(producto.pro_ruta_imagen))
            {
                EscribirPlaceholder(context);
                return;
            }

            string rutaVirtual = producto.pro_ruta_imagen.Split(',')[0].Trim();
            if (!rutaVirtual.StartsWith("~"))
            {
                rutaVirtual = rutaVirtual.StartsWith("/") ? "~" + rutaVirtual : "~/" + rutaVirtual.TrimStart('/');
            }

            string rutaFisica = context.Server.MapPath(rutaVirtual);
            if (!File.Exists(rutaFisica))
            {
                EscribirPlaceholder(context);
                return;
            }

            string extension = Path.GetExtension(rutaFisica).ToLowerInvariant();
            context.Response.ContentType = ObtenerContentType(extension);
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.Cache.SetMaxAge(TimeSpan.FromHours(1));
            context.Response.WriteFile(rutaFisica);
        }

        private static string ObtenerContentType(string extension)
        {
            switch (extension)
            {
                case ".png": return "image/png";
                case ".gif": return "image/gif";
                case ".webp": return "image/webp";
                case ".jpg":
                case ".jpeg":
                default: return "image/jpeg";
            }
        }

        private static void EscribirPlaceholder(HttpContext context)
        {
            context.Response.ContentType = "image/svg+xml";
            context.Response.Write(@"<svg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'>
                <rect width='80' height='80' fill='#f0f6ec' rx='8'/>
                <text x='40' y='44' text-anchor='middle' font-family='Arial,sans-serif' font-size='11' fill='#9bb592'>Sin foto</text>
            </svg>");
        }
    }
}
