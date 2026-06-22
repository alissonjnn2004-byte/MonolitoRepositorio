using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Monolito_4am
{
    public partial class listar_tbl_producto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProductos();
                GenerarCarrusel();
            }
        }

        private void CargarProductos()
        {
            gvProductos.DataSource = Capa_Negocio.CN_tbl_producto.ListarProductosGrid();
            gvProductos.DataBind();
        }

        private void GenerarCarrusel()
        {
            var productos = Capa_Negocio.CN_tbl_producto.ListarProductosGrid();
            System.Text.StringBuilder html = new System.Text.StringBuilder();
            bool isFirst = true;

            foreach (object obj in productos)
            {
                Type t = obj.GetType();
                string nombre = (string)t.GetProperty("pro_nombre").GetValue(obj, null);
                decimal precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null);
                int cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null);

                string activeClass = isFirst ? "active" : "";
                
                html.Append($@"
                    <div class='carousel-item {activeClass}'>
                        <div class='d-flex justify-content-center align-items-center' style='min-height: 120px;'>
                            <div class='text-center p-3' style='background: #fcfdfa; border-radius: 15px; width: 70%; border: 1px solid #e1ecdb;'>
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

        protected void btnExportar_Click(object sender, EventArgs e)
        {
            var productos = Capa_Negocio.CN_tbl_producto.ListarProductosGrid();
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            
            sb.AppendLine("ID,Nombre,Cantidad,Precio,ProvID,ProveedorNombre");

            foreach (object obj in productos)
            {
                Type t = obj.GetType();
                int id = (int)t.GetProperty("pro_id").GetValue(obj, null);
                string nombre = (string)t.GetProperty("pro_nombre").GetValue(obj, null);
                int cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null);
                decimal precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null);
                int provId = t.GetProperty("prov_id").GetValue(obj, null) != null ? (int)t.GetProperty("prov_id").GetValue(obj, null) : 0;
                string proveedor = (string)t.GetProperty("prov_nombre").GetValue(obj, null);

                if(nombre != null) nombre = nombre.Replace(",", " ");
                if(proveedor != null) proveedor = proveedor.Replace(",", " ");

                sb.AppendLine($"{id},{nombre},{cantidad},{precio.ToString(System.Globalization.CultureInfo.InvariantCulture)},{provId},{proveedor}");
            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Productos.csv");
            Response.Charset = "utf-8";
            Response.ContentType = "text/csv";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void btnImportar_Click(object sender, EventArgs e)
        {
            if (fuExcel.HasFile)
            {
                try
                {
                    using (System.IO.StreamReader sr = new System.IO.StreamReader(fuExcel.PostedFile.InputStream))
                    {
                        string line;
                        bool firstRow = true;
                        int count = 0;
                        while ((line = sr.ReadLine()) != null)
                        {
                            if (firstRow) { firstRow = false; continue; } 
                            
                            string[] cols = line.Split(',');
                            if (cols.Length >= 5)
                            {
                                string nombre = cols[1].Trim();
                                int cantidad = 0;
                                decimal precio = 0;
                                int provId = 0;

                                int.TryParse(cols[2], out cantidad);
                                decimal.TryParse(cols[3], System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out precio);
                                int.TryParse(cols[4], out provId);

                                if (!string.IsNullOrEmpty(nombre) && provId > 0)
                                {
                                    Capa_Negocio.CN_tbl_producto.RegistrarProducto(nombre, cantidad, precio, provId, "");
                                    count++;
                                }
                            }
                        }
                        ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                            $"Swal.fire('Éxito', 'Se importaron {count} productos correctamente.', 'success');", true);
                        CargarProductos();
                        GenerarCarrusel();
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                            $"Swal.fire('Error', 'Error al importar CSV: {ex.Message}', 'error');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                            "Swal.fire('Atención', 'Por favor seleccione un archivo CSV primero.', 'warning');", true);
            }
        }
    }
}