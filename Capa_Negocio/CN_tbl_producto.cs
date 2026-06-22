using System;
using System.Collections.Generic;
using System.Linq;
using Capa_Datos;
using MongoDB.Driver;

namespace Capa_Negocio
{
    public class CN_tbl_producto
    {
        public static List<object> ListarProductosGrid()
        {
            var db = new MongoDBContext();
            var productos = db.Productos.Find(p => p.pro_estado == "A").ToList();
            var proveedores = db.Proveedores.Find(FilterDefinition<tbl_proveedor>.Empty).ToList();

            var consulta = from p in productos
                           join prov in proveedores
                           on p.prov_id equals prov.prov_id into provJoin
                           from proveedor in provJoin.DefaultIfEmpty()
                           select new
                           {
                               p.pro_id,
                               p.pro_nombre,
                               p.pro_cantidad,
                               p.pro_precio,
                               p.pro_estado,
                               p.pro_ruta_imagen,
                               p.prov_id,
                               prov_nombre = (proveedor != null && proveedor.prov_estado == "A")
                                   ? proveedor.prov_nombre
                                   : "Sin proveedor"
                           };

            return consulta.ToList<object>();
        }

        public static tbl_producto ObtenerProductoPorId(int id)
        {
            var db = new MongoDBContext();
            return db.Productos.Find(p => p.pro_id == id).FirstOrDefault();
        }

        public static void RegistrarProducto(string nombre, int cantidad, decimal precio, int provId, string rutaImagen)
        {
            var db = new MongoDBContext();
            var maxId = db.Productos.Find(FilterDefinition<tbl_producto>.Empty).SortByDescending(p => p.pro_id).Limit(1).FirstOrDefault()?.pro_id ?? 0;
            
            tbl_producto nuevo = new tbl_producto();
            nuevo.pro_id = maxId + 1;
            nuevo.pro_nombre = nombre;
            nuevo.pro_cantidad = cantidad;
            nuevo.pro_precio = precio;
            nuevo.pro_estado = "A";
            nuevo.prov_id = provId;
            nuevo.pro_ruta_imagen = rutaImagen;

            db.Productos.InsertOne(nuevo);
        }

        public static void ActualizarProducto(int id, string nombre, int cantidad, decimal precio, int provId, string rutaImagen)
        {
            var db = new MongoDBContext();
            var update = Builders<tbl_producto>.Update
                .Set(p => p.pro_nombre, nombre)
                .Set(p => p.pro_cantidad, cantidad)
                .Set(p => p.pro_precio, precio)
                .Set(p => p.prov_id, provId > 0 ? (int?)provId : null);

            if (!string.IsNullOrEmpty(rutaImagen))
            {
                update = update.Set(p => p.pro_ruta_imagen, rutaImagen);
            }

            db.Productos.UpdateOne(p => p.pro_id == id, update);
        }

        public static void EliminarProducto(int id)
        {
            var db = new MongoDBContext();
            db.Productos.UpdateOne(p => p.pro_id == id, Builders<tbl_producto>.Update.Set(p => p.pro_estado, "I"));
        }

        public static void EliminarProductoFisico(int id)
        {
            var db = new MongoDBContext();
            db.Productos.DeleteOne(p => p.pro_id == id);
        }
    }
}
