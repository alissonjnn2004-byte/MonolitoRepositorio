using System;
using System.Linq;
using System.Web.UI;
using Capa_Negocio;

namespace Monolito_4am.Seguridad
{
    public partial class ImportacionExcel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private static int ObtenerProveedorIdPorNombre(string nombreProveedor)
        {
            if (string.IsNullOrWhiteSpace(nombreProveedor))
            {
                return 0;
            }

            var proveedores = CN_tbl_proveedor.ListarProveedores();
            var prov = proveedores.FirstOrDefault(p =>
                p.prov_nombre != null &&
                p.prov_nombre.Equals(nombreProveedor.Trim(), StringComparison.OrdinalIgnoreCase));

            return prov?.prov_id ?? 0;
        }

        private void MostrarAlerta(string titulo, string mensaje, string tipo)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                $"Swal.fire('{titulo}', '{mensaje}', '{tipo}');", true);
        }

        protected void btnExportarProductos_Click(object sender, EventArgs e)
        {
            var productos = CN_tbl_producto.ListarProductosGrid();
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            
            sb.AppendLine("pro_id,pro_nombre,pro_cantidad,pro_precio,prov_nombre,pro_ruta_imagen");

            foreach (object obj in productos)
            {
                Type t = obj.GetType();
                int id = (int)t.GetProperty("pro_id").GetValue(obj, null);
                string nombre = (string)t.GetProperty("pro_nombre").GetValue(obj, null);
                int cantidad = (int)t.GetProperty("pro_cantidad").GetValue(obj, null);
                decimal precio = (decimal)t.GetProperty("pro_precio").GetValue(obj, null);
                string proveedor = (string)t.GetProperty("prov_nombre").GetValue(obj, null);
                string rutaImagen = t.GetProperty("pro_ruta_imagen").GetValue(obj, null) as string ?? "";

                if (nombre != null) nombre = nombre.Replace(",", " ");
                if (proveedor != null) proveedor = proveedor.Replace(",", " ");
                if (rutaImagen != null) rutaImagen = rutaImagen.Replace(",", " ");

                sb.AppendLine($"{id},{nombre},{cantidad},{precio.ToString(System.Globalization.CultureInfo.InvariantCulture)},{proveedor},{rutaImagen}");
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

        protected void btnImportarProductos_Click(object sender, EventArgs e)
        {
            if (fuExcelProductos.HasFile)
            {
                string extension = System.IO.Path.GetExtension(fuExcelProductos.FileName).ToLower();
                if (extension == ".xlsx" || extension == ".xls")
                {
                    MostrarAlerta("Formato incorrecto", "Por favor, guarde el archivo de Excel como CSV (delimitado por comas o punto y coma) antes de subirlo.", "warning");
                    return;
                }
                if (extension != ".csv" && extension != ".txt")
                {
                    MostrarAlerta("Error", "Debe seleccionar un archivo CSV.", "error");
                    return;
                }

                try
                {
                    using (System.IO.StreamReader sr = new System.IO.StreamReader(fuExcelProductos.PostedFile.InputStream))
                    {
                        string line;
                        bool firstRow = true;
                        int count = 0;
                        int erroresFormato = 0;
                        int erroresProveedor = 0;
                        char separator = ',';

                        // Índices dinámicos
                        int idxNombre = 1;
                        int idxCantidad = 2;
                        int idxPrecio = 3;
                        int idxProvNombre = 4;
                        int idxProvId = -1;
                        int idxRutaImagen = 5;

                        while ((line = sr.ReadLine()) != null)
                        {
                            if (string.IsNullOrWhiteSpace(line)) continue;

                            if (firstRow) 
                            { 
                                firstRow = false; 
                                if (line.Contains(";")) separator = ';';
                                else if (line.Contains("\t")) separator = '\t';
                                
                                // Mapeo de columnas
                                string[] headers = line.Split(separator);
                                for (int i = 0; i < headers.Length; i++)
                                {
                                    string header = headers[i].Trim().Trim('"').ToLower();
                                    if (header == "pro_nombre" || header == "nombre") idxNombre = i;
                                    else if (header == "pro_cantidad" || header == "cantidad") idxCantidad = i;
                                    else if (header == "pro_precio" || header == "precio") idxPrecio = i;
                                    else if (header == "prov_nombre" || header == "proveedor") idxProvNombre = i;
                                    else if (header == "prov_id") idxProvId = i;
                                    else if (header == "pro_ruta_imagen" || header == "imagen") idxRutaImagen = i;
                                }
                                continue; 
                            } 
                            
                            string[] rawCols = line.Split(separator);
                            string[] cols = new string[rawCols.Length];
                            for (int i = 0; i < rawCols.Length; i++)
                            {
                                cols[i] = rawCols[i].Trim().Trim('"');
                            }

                            if (cols.Length > idxNombre)
                            {
                                string nombre = cols[idxNombre];
                                int cantidad = 0;
                                decimal precio = 0;
                                int provId = 0;
                                string rutaImagen = (idxRutaImagen != -1 && cols.Length > idxRutaImagen) ? cols[idxRutaImagen] : "";

                                string strCantidad = (idxCantidad != -1 && cols.Length > idxCantidad) ? cols[idxCantidad] : "0";
                                string strPrecio = (idxPrecio != -1 && cols.Length > idxPrecio) ? cols[idxPrecio] : "0";

                                int.TryParse(strCantidad, out cantidad);

                                if (strPrecio.Contains(",") && !strPrecio.Contains("."))
                                {
                                    strPrecio = strPrecio.Replace(",", ".");
                                }
                                decimal.TryParse(strPrecio, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out precio);

                                // Buscar proveedor por prov_id si existe la columna
                                if (idxProvId != -1 && cols.Length > idxProvId && int.TryParse(cols[idxProvId], out int pId) && pId > 0)
                                {
                                    provId = pId;
                                }
                                // Si no, buscar por prov_nombre
                                else if (idxProvNombre != -1 && cols.Length > idxProvNombre)
                                {
                                    string nombreProv = cols[idxProvNombre];
                                    if (int.TryParse(nombreProv, out int numericProvId) && numericProvId > 0)
                                    {
                                        provId = numericProvId; // Soporte para formato antiguo donde prov_nombre traía el ID
                                    }
                                    else
                                    {
                                        provId = ObtenerProveedorIdPorNombre(nombreProv);
                                    }
                                }

                                if (!string.IsNullOrEmpty(nombre))
                                {
                                    if (provId > 0)
                                    {
                                        CN_tbl_producto.RegistrarProducto(nombre, cantidad, precio, provId, rutaImagen);
                                        count++;
                                    }
                                    else
                                    {
                                        erroresProveedor++;
                                    }
                                }
                                else
                                {
                                    erroresFormato++;
                                }
                            }
                            else
                            {
                                erroresFormato++;
                            }
                        }

                        if (erroresFormato > 0 || erroresProveedor > 0)
                        {
                            string mensaje = $"Se importaron {count} productos correctamente. ";
                            if (erroresProveedor > 0) mensaje += $"{erroresProveedor} fallaron porque el proveedor no existe. ";
                            if (erroresFormato > 0) mensaje += $"{erroresFormato} fallaron por formato incorrecto.";
                            MostrarAlerta("Atención", mensaje, "warning");
                        }
                        else if (count > 0)
                        {
                            MostrarAlerta("Éxito", $"Se importaron los {count} productos correctamente.", "success");
                        }
                        else
                        {
                            MostrarAlerta("Sin datos", "El archivo no contenía productos válidos para importar.", "info");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error", "Error al importar CSV de Productos: " + ex.Message, "error");
                }
            }
            else
            {
                MostrarAlerta("Atención", "Por favor seleccione un archivo CSV para productos.", "warning");
            }
        }

        protected void btnExportarProveedores_Click(object sender, EventArgs e)
        {
            var proveedores = CN_tbl_proveedor.ListarProveedoresGrid();
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            
            sb.AppendLine("ID,Nombre");

            foreach (object obj in proveedores)
            {
                Type t = obj.GetType();
                int id = (int)t.GetProperty("prov_id").GetValue(obj, null);
                string nombre = (string)t.GetProperty("prov_nombre").GetValue(obj, null);
                if(nombre != null) nombre = nombre.Replace(",", " ");

                sb.AppendLine($"{id},{nombre}");
            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Proveedores.csv");
            Response.Charset = "utf-8";
            Response.ContentType = "text/csv";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void btnImportarProveedores_Click(object sender, EventArgs e)
        {
            if (fuExcelProveedores.HasFile)
            {
                string extension = System.IO.Path.GetExtension(fuExcelProveedores.FileName).ToLower();
                if (extension == ".xlsx" || extension == ".xls")
                {
                    MostrarAlerta("Formato incorrecto", "Por favor, guarde el archivo de Excel como CSV (delimitado por comas o punto y coma) antes de subirlo.", "warning");
                    return;
                }
                if (extension != ".csv" && extension != ".txt")
                {
                    MostrarAlerta("Error", "Debe seleccionar un archivo CSV.", "error");
                    return;
                }

                try
                {
                    using (System.IO.StreamReader sr = new System.IO.StreamReader(fuExcelProveedores.PostedFile.InputStream))
                    {
                        string line;
                        bool firstRow = true;
                        int count = 0;
                        int erroresFormato = 0;
                        char separator = ',';

                        while ((line = sr.ReadLine()) != null)
                        {
                            if (string.IsNullOrWhiteSpace(line)) continue;

                            if (firstRow) 
                            { 
                                firstRow = false; 
                                if (line.Contains(";")) separator = ';';
                                else if (line.Contains("\t")) separator = '\t';
                                continue; 
                            }
                            
                            string[] rawCols = line.Split(separator);
                            string[] cols = new string[rawCols.Length];
                            for (int i = 0; i < rawCols.Length; i++)
                            {
                                cols[i] = rawCols[i].Trim().Trim('"');
                            }

                            if (cols.Length >= 2)
                            {
                                string nombre = cols[1];

                                if (!string.IsNullOrEmpty(nombre))
                                {
                                    CN_tbl_proveedor.RegistrarProveedor(nombre);
                                    count++;
                                }
                                else
                                {
                                    erroresFormato++;
                                }
                            }
                            else
                            {
                                erroresFormato++;
                            }
                        }

                        if (erroresFormato > 0)
                        {
                            MostrarAlerta("Atención", $"Se importaron {count} proveedores correctamente. {erroresFormato} fallaron por formato incorrecto.", "warning");
                        }
                        else if (count > 0)
                        {
                            MostrarAlerta("Éxito", $"Se importaron los {count} proveedores correctamente.", "success");
                        }
                        else
                        {
                            MostrarAlerta("Sin datos", "El archivo no contenía proveedores válidos para importar.", "info");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MostrarAlerta("Error", "Error al importar CSV de Proveedores: " + ex.Message, "error");
                }
            }
            else
            {
                MostrarAlerta("Atención", "Por favor seleccione un archivo CSV para proveedores.", "warning");
            }
        }
    }
}
