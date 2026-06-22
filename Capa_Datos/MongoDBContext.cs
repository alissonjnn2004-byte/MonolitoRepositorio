using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using MongoDB.Driver;

//Conectarse a MongoDB.
//Acceder a las colecciones (usuarios, productos, proveedores, etc.).

namespace Capa_Datos
{
    public class MongoDBContext
    {
        private const string CadenaPorDefecto = "mongodb://localhost:27017/Monolito4am";

        private readonly IMongoDatabase _database;
        private readonly string _connectionString;

        public static string NombreBaseDatos { get; private set; }
        public static string UltimaCadenaConexion { get; private set; }
        public static string OrigenConexion { get; private set; }

        public IMongoDatabase Database => _database;

        public MongoDBContext()
        {
            if (!string.IsNullOrWhiteSpace(MongoDbConfig.ConnectionString))
            {
                _connectionString = MongoDbConfig.ConnectionString;
                OrigenConexion = "Web.config (inicio de aplicación)";
            }
            else
            {
                var settings = ConfigurationManager.ConnectionStrings["conexion"];
                if (settings != null && !string.IsNullOrWhiteSpace(settings.ConnectionString))
                {
                    _connectionString = settings.ConnectionString;
                    OrigenConexion = "ConfigurationManager";
                }
                else
                {
                    _connectionString = CadenaPorDefecto;
                    OrigenConexion = "Cadena por defecto en código";
                }
            }

            UltimaCadenaConexion = _connectionString;

            if (!_connectionString.TrimStart().StartsWith("mongodb", StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException(
                    "La cadena 'conexion' debe ser MongoDB (mongodb://...). " +
                    "Revise Web.config del proyecto Monolito_4am (no use una publicación Release antigua con SQL).");
            }

            var client = new MongoClient(_connectionString);
            var mongoUrl = new MongoUrl(_connectionString);
            var databaseName = mongoUrl.DatabaseName ?? "Monolito4am";

            NombreBaseDatos = databaseName;
            _database = client.GetDatabase(databaseName);
        }

        public IMongoCollection<tbl_producto> Productos => _database.GetCollection<tbl_producto>("productos");
        public IMongoCollection<tbl_proveedor> Proveedores => _database.GetCollection<tbl_proveedor>("proveedores");
        public IMongoCollection<tbl_tipo_usuario> TiposUsuario => _database.GetCollection<tbl_tipo_usuario>("tipos_usuario");
        public IMongoCollection<tbl_usuario> Usuarios => _database.GetCollection<tbl_usuario>("usuarios");
        public IMongoCollection<tbl_usuario_imagen> UsuarioImagenes => _database.GetCollection<tbl_usuario_imagen>("usuario_imagen");

        public int ObtenerMaximoUsuId()
        {
            var doc = _database.GetCollection<BsonDocument>("usuarios")
                .Find(FilterDefinition<BsonDocument>.Empty)
                .Sort(Builders<BsonDocument>.Sort.Descending("usu_id"))
                .Limit(1)
                .Project(Builders<BsonDocument>.Projection.Include("usu_id"))
                .FirstOrDefault();

            if (doc != null && doc.Contains("usu_id"))
                return doc["usu_id"].ToInt32();

            return 0;
        }

        public bool ExisteUsuarioPorCedula(string cedula)
        {
            return _database.GetCollection<BsonDocument>("usuarios")
                .Find(Builders<BsonDocument>.Filter.Eq("usu_cedula", cedula))
                .Limit(1)
                .Any();
        }

        public bool ExisteUsuarioPorCorreo(string correo)
        {
            return _database.GetCollection<BsonDocument>("usuarios")
                .Find(Builders<BsonDocument>.Filter.Eq("usu_correo", correo))
                .Limit(1)
                .Any();
        }

        ///Inserta el usuario como documento BSON (mismo formato que muestra Compass)
        public void InsertarUsuario(tbl_usuario usuario)
        {
            var doc = new BsonDocument
            {
                { "usu_id", usuario.usu_id },
                { "usu_nombres", usuario.usu_nombres ?? "" },
                { "usu_apellidos", usuario.usu_apellidos ?? "" },
                { "usu_cedula", usuario.usu_cedula ?? "" },
                { "usu_correo", usuario.usu_correo ?? "" },
                { "usu_celular", usuario.usu_celular ?? "" },
                { "usu_direccion", usuario.usu_direccion ?? "" },
                { "usu_nick", usuario.usu_nick ?? "" },
                { "usu_estado", usuario.usu_estado ?? "A" },
                { "usu_intento_fallido", usuario.usu_intento_fallido },
                { "usu_bloqueado", usuario.usu_bloqueado ?? false }
            };

            if (usuario.usu_fecha_cumple.HasValue)
                doc.Add("usu_fecha_cumple", usuario.usu_fecha_cumple.Value);

            if (usuario.usu_fecha_creacion.HasValue)
                doc.Add("usu_fecha_creacion", usuario.usu_fecha_creacion.Value);

            if (usuario.tusu_id.HasValue)
                doc.Add("tusu_id", usuario.tusu_id.Value);

            if (usuario.usu_contraseña != null && usuario.usu_contraseña.Length > 0)
                doc.Add("usu_contraseña", new BsonBinaryData(usuario.usu_contraseña, BsonBinarySubType.Binary));

            _database.GetCollection<BsonDocument>("usuarios").InsertOne(doc);
        }

        public long ContarUsuarios()
        {
            return _database.GetCollection<BsonDocument>("usuarios")
                .CountDocuments(FilterDefinition<BsonDocument>.Empty);
        }

        public List<string> ListarResumenUsuarios(int limite = 20)
        {
            return _database.GetCollection<BsonDocument>("usuarios")
                .Find(FilterDefinition<BsonDocument>.Empty)
                .SortByDescending(d => d["usu_id"])
                .Limit(limite)
                .ToList()
                .Select(d =>
                {
                    var id = d.Contains("usu_id") ? d["usu_id"].ToString() : "?";
                    var cedula = d.Contains("usu_cedula") ? d["usu_cedula"].AsString : "";
                    var nombre = d.Contains("usu_nombres") ? d["usu_nombres"].AsString : "";
                    return $"usu_id={id} | cedula={cedula} | {nombre}";
                })
                .ToList();
        }
    }
}
