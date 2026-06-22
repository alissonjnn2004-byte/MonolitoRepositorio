using System;
using System.Security.Cryptography;
using System.Text;
using Capa_Datos;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Driver;

namespace Capa_Negocio
{
    public class CN_tbl_usuario
    {
        private static string Encriptar(string texto)
        {
            if (string.IsNullOrEmpty(texto)) return null;
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(texto));
        }

        private static string Desencriptar(byte[] bytes)
        {
            if (bytes == null || bytes.Length == 0) return null;
            try
            {
                string str = Encoding.UTF8.GetString(bytes);
                if (IsBase64String(str))
                {
                    return Encoding.UTF8.GetString(Convert.FromBase64String(str));
                }
                return str;
            }
            catch
            {
                return Encoding.UTF8.GetString(bytes);
            }
        }

        private static bool IsBase64String(string s)
        {
            s = s.Trim();
            return (s.Length % 4 == 0) && System.Text.RegularExpressions.Regex.IsMatch(s, @"^[a-zA-Z0-9\+/]*={0,3}$", System.Text.RegularExpressions.RegexOptions.None);
        }

        private static byte[] EncriptarToBytes(string texto)
        {
            if (string.IsNullOrEmpty(texto)) return null;
            return Encoding.UTF8.GetBytes(texto);
        }

        // Consulta trae toda la información de la tabla usuario
        public static List<tbl_usuario> ListarUsuario()
        {
            var db = new MongoDBContext();
            // MODIFICADO: "A" con comillas dobles
            return db.Usuarios.Find(u => u.usu_estado == "A").ToList();
        }

        // Consultar si el usuario existe o no en la base de datos
        public static bool autentixnom(string cedula)
        {
            var db = new MongoDBContext();
            // MODIFICADO: "A" con comillas dobles
            return db.Usuarios.Find(u => u.usu_cedula == cedula && u.usu_estado == "A").Any();
        }

        public static bool autentixpass(string cedula, string password)
        {
            var db = new MongoDBContext();
            // MODIFICADO: "A" con comillas dobles
            var usuarios = db.Usuarios.Find(u => u.usu_cedula == cedula && u.usu_estado == "A").ToList();
            return usuarios.Any(u => Desencriptar(u.usu_contraseña) == password);
        }

        // Traemos todo el usuario que coincida con la cedula y el password
        public static tbl_usuario traerUsuario(string cedula, string password)
        {
            var db = new MongoDBContext();
            // MODIFICADO: "A" con comillas dobles
            var usuarios = db.Usuarios.Find(u => u.usu_cedula == cedula && u.usu_estado == "A").ToList();
            return usuarios.FirstOrDefault(u => Desencriptar(u.usu_contraseña) == password);
        }

        // Registrar los usuarios nuevos (versión completa con perfil)
        public static tbl_usuario registrarUsuario(tbl_usuario usuario, string passwordPlano)
        {
            var db = new MongoDBContext();

            if (db.ExisteUsuarioPorCedula(usuario.usu_cedula))
                throw new Exception("La cédula ya está registrada.");

            if (db.ExisteUsuarioPorCorreo(usuario.usu_correo))
                throw new Exception("El correo ya está registrado.");

            // MODIFICADO: "A" con comillas dobles para validar el perfil del usuario
            if (usuario.tusu_id > 0 && !db.TiposUsuario.Find(t => t.tusu_id == usuario.tusu_id && t.tusu_estado == "A").Any())
                throw new Exception("El perfil seleccionado no es válido.");

            // Generar usu_id auto incremental (sin deserializar documentos viejos migrados)
            usuario.usu_id = db.ObtenerMaximoUsuId() + 1;

            usuario.usu_fecha_creacion = DateTime.Now;
            // MODIFICADO: "A" con comillas dobles
            usuario.usu_estado = "A";
            usuario.usu_intento_fallido = 0;
            usuario.usu_bloqueado = false;
            usuario.usu_contraseña = EncriptarToBytes(passwordPlano);

            db.InsertarUsuario(usuario);

            if (!db.ExisteUsuarioPorCedula(usuario.usu_cedula))
            {
                throw new Exception(
                    "El usuario no se encontró después de guardar. En Compass abra: " +
                    $"localhost:27017 → base '{MongoDBContext.NombreBaseDatos}' → colección 'usuarios' y pulse Actualizar.");
            }

            return usuario;
        }

        public static void GuardarOTP(string cedula, string otp)
        {
            var db = new MongoDBContext();
            var usuario = db.Usuarios.Find(u => u.usu_cedula == cedula).FirstOrDefault();

            if (usuario != null)
            {
                string otpEncriptado = EncriptarOTP(otp);
                var filter = Builders<tbl_usuario>.Filter.Eq(u => u._id, usuario._id);
                var update = Builders<tbl_usuario>.Update.Set(u => u.usu_codigo_OTP, otpEncriptado);
                db.Usuarios.UpdateOne(filter, update);
            }
        }

        public static tbl_usuario traerUsuarioPorCedula(string cedula)
        {
            try
            {
                var db = new MongoDBContext();
                // MODIFICADO: "A" con comillas dobles
                return db.Usuarios.Find(u => u.usu_cedula == cedula && u.usu_estado == "A").FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al buscar usuario: " + ex.Message);
            }
        }

        public static void BloquearUsuario(string cedula)
        {
            var db = new MongoDBContext();
            var filter = Builders<tbl_usuario>.Filter.Eq(u => u.usu_cedula, cedula);
            var update = Builders<tbl_usuario>.Update.Set(u => u.usu_bloqueado, true);
            db.Usuarios.UpdateOne(filter, update);
        }

        public static void DesbloquearUsuario(int idUsuario)
        {
            var db = new MongoDBContext();
            var filter = Builders<tbl_usuario>.Filter.Eq(u => u.usu_id, idUsuario);
            var update = Builders<tbl_usuario>.Update
                .Set(u => u.usu_bloqueado, false)
                .Set(u => u.usu_intento_fallido, 0)
                // MODIFICADO: "A" con comillas dobles
                .Set(u => u.usu_estado, "A")
                .Set(u => u.usu_fecha_ultimo_intento, (DateTime?)null);

            db.Usuarios.UpdateOne(filter, update);
        }

        public static List<object> ListarUsuariosConFoto()
        {
            var db = new MongoDBContext();
            var usuarios = db.Usuarios.Find(FilterDefinition<tbl_usuario>.Empty).ToList();
            var imagenes = db.UsuarioImagenes.Find(FilterDefinition<tbl_usuario_imagen>.Empty).ToList();

            var consulta = usuarios.Select(u => new
            {
                u.usu_id,
                u.usu_nombres,
                u.usu_cedula,
                u.usu_bloqueado,
                Fotos = imagenes
                    .Where(i => i.usu_id == u.usu_id && i.img_archivo != null && i.img_archivo.Length > 0)
                    .Select(i => Convert.ToBase64String(i.img_archivo))
                    .ToList()
            });

            return consulta.ToList<object>();
        }

        public static bool ActualizarPasswordTemporal(string cedula, byte[] claveCifrada)
        {
            try
            {
                var db = new MongoDBContext();
                var filter = Builders<tbl_usuario>.Filter.Eq(u => u.usu_cedula, cedula);
                var update = Builders<tbl_usuario>.Update
                    .Set(u => u.usu_contraseña, claveCifrada)
                    .Set(u => u.usu_bloqueado, false)
                    .Set(u => u.usu_intento_fallido, 0);

                var result = db.Usuarios.UpdateOne(filter, update);
                return result.ModifiedCount > 0;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public static string ValidarAccesoConContador(string cedula, string password)
        {
            var db = new MongoDBContext();
            var usuario = db.Usuarios.Find(u => u.usu_cedula == cedula).FirstOrDefault();

            if (usuario == null) return "USUARIO_NO_EXISTE";

            if (usuario.usu_bloqueado == true)
            {
                return "BLOQUEADO";
            }

            if (Desencriptar(usuario.usu_contraseña) == password)
            {
                var filter = Builders<tbl_usuario>.Filter.Eq(u => u._id, usuario._id);
                var update = Builders<tbl_usuario>.Update.Set(u => u.usu_intento_fallido, 0);
                db.Usuarios.UpdateOne(filter, update);
                return "OK";
            }
            else
            {
                int actuales = usuario.usu_intento_fallido + 1;
                var filter = Builders<tbl_usuario>.Filter.Eq(u => u._id, usuario._id);
                var update = Builders<tbl_usuario>.Update
                    .Set(u => u.usu_intento_fallido, actuales)
                    .Set(u => u.usu_fecha_ultimo_intento, DateTime.Now)
                    .Set(u => u.usu_otp_secret, "ERROR_AUTH");

                if (actuales >= 3)
                {
                    // MODIFICADO: "B" con comillas dobles para el estado bloqueado
                    update = update.Set(u => u.usu_bloqueado, true).Set(u => u.usu_estado, "B");
                }

                db.Usuarios.UpdateOne(filter, update);

                if (actuales >= 3) return "BLOQUEADO_RECIEN";
                return "FALLO_" + actuales;
            }
        }

        public static tbl_usuario ObtenerUsuarioPorId(int idUsuario)
        {
            var db = new MongoDBContext();
            return db.Usuarios.Find(x => x.usu_id == idUsuario).FirstOrDefault();
        }

        public static void ActualizarUsuario(tbl_usuario usu)
        {
            var db = new MongoDBContext();
            var filter = Builders<tbl_usuario>.Filter.Eq(u => u.usu_id, usu.usu_id);
            var update = Builders<tbl_usuario>.Update
                .Set(u => u.usu_nombres, usu.usu_nombres)
                .Set(u => u.usu_cedula, usu.usu_cedula)
                .Set(u => u.usu_correo, usu.usu_correo);

            db.Usuarios.UpdateOne(filter, update);
        }

        public static void EliminarUsuario(int idUsuario)
        {
            var db = new MongoDBContext();
            var filter = Builders<tbl_usuario>.Filter.Eq(u => u.usu_id, idUsuario);
            db.Usuarios.DeleteOne(filter);
        }

        public static List<object> listarUsuariosConFoto()
        {
            var db = new MongoDBContext();
            var usuarios = db.Usuarios.Find(FilterDefinition<tbl_usuario>.Empty).ToList();
            var imagenes = db.UsuarioImagenes.Find(FilterDefinition<tbl_usuario_imagen>.Empty).ToList();

            var consulta = from u in usuarios
                           join i in imagenes
                           on u.usu_id equals i.usu_id into img
                           from foto in img.DefaultIfEmpty()
                           select new
                           {
                               u.usu_id,
                               u.usu_nombres,
                               u.usu_cedula,
                               u.usu_bloqueado,
                               FotoBinaria = foto != null ? foto.img_archivo : null
                           };

            return consulta.ToList<object>();
        }

        public static bool RegistrarNuevoUsuario(string cedula, string nombres, string apellidos, string direccion, string celular, string correo, DateTime fechaCumple, string nick, string password, int tusu_id, string codigoOTP)
        {
            try
            {
                var db = new MongoDBContext();

                if (db.Usuarios.Find(u => u.usu_cedula == cedula || u.usu_correo == correo).Any())
                {
                    return false;
                }

                tbl_usuario nuevoUsuario = new tbl_usuario();

                var maxId = db.Usuarios.Find(FilterDefinition<tbl_usuario>.Empty).SortByDescending(u => u.usu_id).Limit(1).FirstOrDefault()?.usu_id ?? 0;
                nuevoUsuario.usu_id = maxId + 1;

                nuevoUsuario.usu_cedula = cedula;
                nuevoUsuario.usu_nombres = nombres;
                nuevoUsuario.usu_apellidos = apellidos;
                nuevoUsuario.usu_direccion = direccion;
                nuevoUsuario.usu_celular = celular;
                nuevoUsuario.usu_correo = correo;
                nuevoUsuario.usu_fecha_cumple = fechaCumple;
                nuevoUsuario.usu_nick = nick;
                nuevoUsuario.tusu_id = tusu_id;

                nuevoUsuario.usu_contraseña = Encoding.UTF8.GetBytes(password);
                nuevoUsuario.usu_codigo_OTP = EncriptarOTP(codigoOTP);

                nuevoUsuario.usu_fecha_creacion = DateTime.Now;
                // MODIFICADO: "A" con comillas dobles
                nuevoUsuario.usu_estado = "A";
                nuevoUsuario.usu_intento_fallido = 0;
                nuevoUsuario.usu_bloqueado = false;

                db.Usuarios.InsertOne(nuevoUsuario);
                return true;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al guardar en la base de datos: " + ex.Message);
            }
        }

        public static string EncriptarOTP(string texto)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(texto));
                StringBuilder builder = new StringBuilder();

                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }

                return builder.ToString();
            }
        }

        public static void GuardarImagenesUsuario(int usu_id, List<byte[]> imagenes)
        {
            if (imagenes == null || imagenes.Count == 0) return;

            var db = new MongoDBContext();
            var maxImgId = db.UsuarioImagenes
                .Find(FilterDefinition<tbl_usuario_imagen>.Empty)
                .SortByDescending(i => i.img_id)
                .Limit(1)
                .Project(i => i.img_id)
                .FirstOrDefault();

            foreach (var imgBytes in imagenes)
            {
                maxImgId++;
                tbl_usuario_imagen nuevaImagen = new tbl_usuario_imagen
                {
                    img_id = maxImgId,
                    usu_id = usu_id,
                    img_archivo = imgBytes
                };
                db.UsuarioImagenes.InsertOne(nuevaImagen);
            }
        }
    }
}