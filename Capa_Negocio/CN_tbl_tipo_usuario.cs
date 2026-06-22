using System;
using System.Collections.Generic;
using System.Linq;
using Capa_Datos;
using MongoDB.Driver;

namespace Capa_Negocio
{
    public class CN_tbl_tipo_usuario
    {
        public static List<tbl_tipo_usuario> ListarTipoUsuario()
        {
            try
            {
                var db = new MongoDBContext();
                // MODIFICADO: Uso de comillas dobles "A" en lugar de comillas simples
                return db.TiposUsuario.Find(tu => tu.tusu_estado == "A").ToList();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al conectar a la base de datos MongoDB: " + ex.Message);
            }
        }
    }
}