using Capa_Negocio;
using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Monolito_4am.Seguridad
{
    public partial class CrudProducto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProveedores();
                CargarProductos();

                if (int.TryParse(Request.QueryString["id"], out int productoId))
                {
                    CargarProductoEnFormulario(productoId);
                }
            }
        }

        private void CargarProveedores()
        {
            ddlProveedor.DataSource = CN_tbl_proveedor.ListarProveedores();
            ddlProveedor.DataTextField = "prov_nombre";
            ddlProveedor.DataValueField = "prov_id";
            ddlProveedor.DataBind();
            ddlProveedor.Items.Insert(0, new ListItem("-- Seleccione un Proveedor --", ""));
        }

        private void CargarProductos()
        {
            gvProductos.DataSource = CN_tbl_producto.ListarProductosGrid();
            gvProductos.DataBind();
        }



        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                string nombre = txtNombre.Text.Trim();
                int cantidad = 0;
                decimal precio = 0;
                int provId = 0;

                // Validaciones básicas
                if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(ddlProveedor.SelectedValue))
                {
                    MostrarAlerta("Atención", "Complete todos los campos requeridos.", "warning");
                    return;
                }

                int.TryParse(txtCantidad.Text, out cantidad);
                decimal.TryParse(txtPrecio.Text, out precio);
                int.TryParse(ddlProveedor.SelectedValue, out provId);

                string rutaImagen = "";
                // Comprobamos si el usuario seleccionó uno o múltiples archivos
                if (fuImagen.HasFiles)
                {
                    List<string> rutas = new List<string>();
                    
                    // Recorremos cada archivo que se haya seleccionado en el input
                    foreach (var file in fuImagen.PostedFiles)
                    {
                        string extension = Path.GetExtension(file.FileName).ToLower();
                        
                        // Verificamos que sea una imagen permitida (evitamos .zip, .exe, etc)
                        if (extension == ".jpg" || extension == ".png" || extension == ".jpeg" || extension == ".webp")
                        {
                            // Generamos un nombre único para evitar que se sobrescriban imágenes con el mismo nombre
                            string nombreArchivo = Guid.NewGuid().ToString() + extension;
                            string rutaCarpeta = Server.MapPath("~/Uploads/Productos/");
                            
                            // Si la carpeta no existe, la creamos
                            if (!Directory.Exists(rutaCarpeta))
                            {
                                Directory.CreateDirectory(rutaCarpeta);
                            }
                            
                            // Guardamos el archivo físicamente en el servidor
                            file.SaveAs(rutaCarpeta + nombreArchivo);
                            
                            // Añadimos la ruta relativa a nuestra lista
                            rutas.Add("~/Uploads/Productos/" + nombreArchivo);
                        }
                        else
                        {
                            MostrarAlerta("Error", "Solo se permiten imágenes JPG, JPEG, PNG o WEBP. No se permiten archivos ZIP u otros.", "error");
                            return;
                        }
                    }
                    // Unimos todas las rutas con una coma para guardarlas en un solo campo de texto en la base de datos
                    rutaImagen = string.Join(",", rutas);
                }

                if (string.IsNullOrEmpty(hfProductoID.Value))
                {
                    // CREAR
                    CN_tbl_producto.RegistrarProducto(nombre, cantidad, precio, provId, rutaImagen);
                    MostrarAlerta("Éxito", "Producto registrado correctamente.", "success");
                }
                else
                {
                    // ACTUALIZAR
                    int id = int.Parse(hfProductoID.Value);
                    CN_tbl_producto.ActualizarProducto(id, nombre, cantidad, precio, provId, rutaImagen);
                    MostrarAlerta("Éxito", "Producto actualizado correctamente.", "success");
                }

                LimpiarFormulario();
                CargarProductos();
            }
            catch (Exception ex)
            {
                MostrarAlerta("Error", "Ocurrió un error: " + ex.Message, "error");
            }
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                CargarProductoEnFormulario(id);
            }
            else if (e.CommandName == "EliminarLogico")
            {
                CN_tbl_producto.EliminarProducto(id);
                MostrarAlerta("Eliminado", "Borrado lógico exitoso.", "success");
                CargarProductos();
            }
            else if (e.CommandName == "EliminarFisico")
            {
                CN_tbl_producto.EliminarProductoFisico(id);
                MostrarAlerta("Eliminado", "Borrado físico exitoso.", "success");
                CargarProductos();
            }
        }

        private void CargarProductoEnFormulario(int id)
        {
            var prod = CN_tbl_producto.ObtenerProductoPorId(id);
            if (prod == null)
            {
                return;
            }

            hfProductoID.Value = prod.pro_id.ToString();
            txtNombre.Text = prod.pro_nombre;
            txtCantidad.Text = prod.pro_cantidad.ToString();
            txtPrecio.Text = prod.pro_precio.ToString();

            if (prod.prov_id.HasValue && ddlProveedor.Items.FindByValue(prod.prov_id.Value.ToString()) != null)
            {
                ddlProveedor.SelectedValue = prod.prov_id.Value.ToString();
            }

            btnGuardar.Text = "Actualizar Producto";

            if (!string.IsNullOrWhiteSpace(prod.pro_ruta_imagen))
            {
                string urlImagen = ResolveUrl($"~/Seguridad/VerProductoImagen.ashx?id={prod.pro_id}");
                string script = $"mostrarImagenExistente('{urlImagen.Replace("'", "\\'")}');";
                Page.ClientScript.RegisterStartupScript(GetType(), "ImgExistente", script, true);
            }
        }

        private void LimpiarFormulario()
        {
            hfProductoID.Value = "";
            txtNombre.Text = "";
            txtCantidad.Text = "";
            txtPrecio.Text = "";
            ddlProveedor.SelectedIndex = 0;
            btnGuardar.Text = "Guardar Producto";
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        private void MostrarAlerta(string titulo, string mensaje, string tipo)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                $"Swal.fire('{titulo}', '{mensaje}', '{tipo}');", true);
        }

        [WebMethod]
        public static List<object> BuscarProductos(string termino)
        {
            var productos = CN_tbl_producto.ListarProductosGrid();
            var resultados = new List<object>();

            foreach (var obj in productos)
            {
                Type t = obj.GetType();
                string nombre = (string)t.GetProperty("pro_nombre").GetValue(obj, null);
                
                if (nombre.ToLower().Contains(termino.ToLower()))
                {
                    var imgProp = t.GetProperty("pro_ruta_imagen");
                    string imgPath = imgProp != null ? (string)imgProp.GetValue(obj, null) : "";

                    int id = (int)t.GetProperty("pro_id").GetValue(obj, null);
                    resultados.Add(new
                    {
                        Id = id,
                        Nombre = nombre,
                        Cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null),
                        Precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null),
                        Imagen = ObtenerUrlImagenPorId(id)
                    });
                }
            }
            return resultados.Take(5).ToList();
        }

        protected string ObtenerUrlImagenProducto(object proId)
        {
            if (proId == null || !int.TryParse(proId.ToString(), out int id))
            {
                return ResolveUrl("~/Seguridad/VerProductoImagen.ashx?id=0");
            }
            return ResolveUrl($"~/Seguridad/VerProductoImagen.ashx?id={id}");
        }

        private static string ObtenerUrlImagenPorId(int id)
        {
            string ruta = $"~/Seguridad/VerProductoImagen.ashx?id={id}";
            if (HttpContext.Current == null)
            {
                return "/Seguridad/VerProductoImagen.ashx?id=" + id;
            }
            return VirtualPathUtility.ToAbsolute(ruta);
        }


        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            var productos = CN_tbl_producto.ListarProductosGrid();

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Productos_Reporte.xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.Charset = "utf-8";
            Response.ContentEncoding = Encoding.UTF8;

            // Tabla HTML: Excel en español abre cada dato en su columna (A, B, C...)
            var sb = new StringBuilder();
            sb.AppendLine("<html xmlns:x=\"urn:schemas-microsoft-com:office:excel\">");
            sb.AppendLine("<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/></head>");
            sb.AppendLine("<body><table border=\"0\">");
            sb.AppendLine("<tr>");
            sb.AppendLine("<th>pro_id</th><th>pro_nombre</th><th>pro_cantidad</th><th>pro_precio</th><th>prov_nombre</th><th>pro_ruta_imagen</th>");
            sb.AppendLine("</tr>");

            foreach (object obj in productos)
            {
                Type t = obj.GetType();
                int id = (int)t.GetProperty("pro_id").GetValue(obj, null);
                string nombre = HttpUtility.HtmlEncode((string)t.GetProperty("pro_nombre").GetValue(obj, null));
                int cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null);
                decimal precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null);
                string proveedor = HttpUtility.HtmlEncode((string)t.GetProperty("prov_nombre").GetValue(obj, null));
                string rutaImagen = HttpUtility.HtmlEncode(t.GetProperty("pro_ruta_imagen").GetValue(obj, null) as string ?? "");

                sb.AppendLine("<tr>");
                sb.AppendLine($"<td>{id}</td>");
                sb.AppendLine($"<td>{nombre}</td>");
                sb.AppendLine($"<td>{cantidad}</td>");
                sb.AppendLine($"<td>{precio:F2}</td>");
                sb.AppendLine($"<td>{proveedor}</td>");
                sb.AppendLine($"<td style=\"mso-number-format:\\@;\">{rutaImagen}</td>");
                sb.AppendLine("</tr>");
            }

            sb.AppendLine("</table></body></html>");

            byte[] bom = Encoding.UTF8.GetPreamble();
            byte[] contenido = Encoding.UTF8.GetBytes(sb.ToString());
            Response.BinaryWrite(bom);
            Response.BinaryWrite(contenido);
            Response.Flush();
            Response.End();
        }
    }
}
