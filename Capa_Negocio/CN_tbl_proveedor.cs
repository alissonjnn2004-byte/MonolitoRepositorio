using System;
using System.Collections.Generic;
using System.Linq;
using Capa_Datos;
using MongoDB.Driver;

namespace Capa_Negocio
{
    public class CN_tbl_proveedor
    {
        public static List<tbl_proveedor> ListarProveedores()
        {
            var db = new MongoDBContext();
            return db.Proveedores.Find(p => p.prov_estado == "A").ToList();
        }

        public static List<object> ListarProveedoresGrid()
        {
            var db = new MongoDBContext();
            var consulta = db.Proveedores.Find(p => p.prov_estado == "A").ToList()
                .Select(p => new
                {
                    p.prov_id,
                    p.prov_nombre,
                    p.prov_estado
                });

            return consulta.ToList<object>();
        }

        public static tbl_proveedor ObtenerProveedorPorId(int id)
        {
            var db = new MongoDBContext();
            return db.Proveedores.Find(p => p.prov_id == id).FirstOrDefault();
        }

        public static void RegistrarProveedor(string nombre)
        {
            var db = new MongoDBContext();
            var maxId = db.Proveedores.Find(FilterDefinition<tbl_proveedor>.Empty).SortByDescending(p => p.prov_id).Limit(1).FirstOrDefault()?.prov_id ?? 0;

            tbl_proveedor nuevo = new tbl_proveedor();
            nuevo.prov_id = maxId + 1;
            nuevo.prov_nombre = nombre;
            nuevo.prov_estado = "A";

            db.Proveedores.InsertOne(nuevo);
        }

        public static void ActualizarProveedor(int id, string nombre)
        {
            var db = new MongoDBContext();
            var update = Builders<tbl_proveedor>.Update.Set(p => p.prov_nombre, nombre);
            db.Proveedores.UpdateOne(p => p.prov_id == id, update);
        }

        public static void EliminarProveedor(int id)
        {
            var db = new MongoDBContext();
            var updateProductos = Builders<tbl_producto>.Update.Set(p => p.prov_id, (int?)null);
            db.Productos.UpdateMany(p => p.prov_id == id, updateProductos);

            var updateProveedor = Builders<tbl_proveedor>.Update.Set(p => p.prov_estado, "I");
            db.Proveedores.UpdateOne(p => p.prov_id == id, updateProveedor);
        }

        public static void EliminarProveedorFisico(int id)
        {
            var db = new MongoDBContext();
            var updateProductos = Builders<tbl_producto>.Update.Set(p => p.prov_id, (int?)null);
            db.Productos.UpdateMany(p => p.prov_id == id, updateProductos);

            db.Proveedores.DeleteOne(p => p.prov_id == id);
        }
    }
}
