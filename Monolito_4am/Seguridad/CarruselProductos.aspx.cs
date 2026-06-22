using Capa_Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace Monolito_4am.Seguridad
{
    public partial class CarruselProductos : System.Web.UI.Page
    {
        protected string DatosGraficaJson { get; private set; } = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerarCarrusel();
                DatosGraficaJson = new JavaScriptSerializer().Serialize(ObtenerDatosGraficaLista());
            }
        }

        private void GenerarCarrusel()
        {
            var productos = CN_tbl_producto.ListarProductosGrid();
            System.Text.StringBuilder html = new System.Text.StringBuilder();
            bool isFirst = true;

            foreach (object obj in productos)
            {
                Type t = obj.GetType();
                string nombre = (string)t.GetProperty("pro_nombre").GetValue(obj, null);
                decimal precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null);
                int cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null);
                int proId = (int)t.GetProperty("pro_id").GetValue(obj, null);
                string urlImagen = ResolveUrl($"~/Seguridad/VerProductoImagen.ashx?id={proId}");
                string activeClass = isFirst ? "active" : "";

                html.Append($@"
                    <div class='carousel-item {activeClass}'>
                        <div class='d-flex justify-content-center align-items-center' style='min-height: 120px;'>
                            <div class='text-center p-3' style='background: #fcfdfa; border-radius: 15px; width: 70%; border: 1px solid #e1ecdb;'>
                                <img src='{urlImagen}' alt='{nombre}' style='height: 150px; object-fit: contain; margin-bottom: 15px;' />
                                <h4 style='color: #5d8b4a; font-weight: 700; margin-bottom: 8px;'>{nombre}</h4>
                                <div style='display: flex; justify-content: center; gap: 20px; font-size: 14px;'>
                                    <span style='color: #7caf6e;'><i class='fas fa-tag'></i> Precio: ${precio:F2}</span>
                                    <span style='color: #9bb592;'><i class='fas fa-box'></i> Stock: {cantidad}</span>
                                </div>
                            </div>
                        </div>
                    </div>");
                isFirst = false;
            }

            if (productos.Count == 0)
            {
                html.Append("<div class='carousel-item active'><div class='text-center p-4' style='color: #a0b898;'>No hay productos registrados.</div></div>");
            }

            carouselInner.InnerHtml = html.ToString();
        }

        private static List<GraficaProductoDto> ObtenerDatosGraficaLista()
        {
            var productos = CN_tbl_producto.ListarProductosGrid();
            var lista = new List<GraficaProductoDto>();

            foreach (var obj in productos)
            {
                Type t = obj.GetType();
                lista.Add(new GraficaProductoDto
                {
                    Nombre = (string)t.GetProperty("pro_nombre").GetValue(obj, null),
                    Cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null),
                    Precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null)
                });
            }

            return lista
                .OrderByDescending(p => p.Cantidad)
                .Take(10)
                .ToList();
        }

        [WebMethod]
        public static List<GraficaProductoDto> ObtenerDatosGrafica()
        {
            return ObtenerDatosGraficaLista();
        }

        public class GraficaProductoDto
        {
            public string Nombre { get; set; }
            public int Cantidad { get; set; }
            public decimal Precio { get; set; }
        }
    }
}
