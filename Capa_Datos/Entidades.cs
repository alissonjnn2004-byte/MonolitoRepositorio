using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson.Serialization;//personaliza la forma en que MongoDB guarda y lee datos.

//definir la estructura de los datos que se guardarán en MongoDB


namespace Capa_Datos
{
    //Ignora campos extras que existan en MongoDB y no estén definidos aquí
    [BsonIgnoreExtraElements]
    public class tbl_tipo_usuario
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }

        public int tusu_id { get; set; }
        public string tusu_nombre { get; set; }

        // MODIFICADO: De char? a string para compatibilidad con MongoDB Compass
        public string tusu_estado { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class tbl_usuario_imagen
    {
        // Identificador único de MongoDB
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }

        public int img_id { get; set; }
        public int usu_id { get; set; }

        [BsonSerializer(typeof(FlexibleByteArraySerializer))]
        public byte[] img_archivo { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class tbl_producto
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }

        public int pro_id { get; set; }
        public string pro_nombre { get; set; }
        public int? pro_cantidad { get; set; }
        public decimal? pro_precio { get; set; }

        // MODIFICADO: De char? a string
        public string pro_estado { get; set; }
        public string pro_ruta_imagen { get; set; }
        public int? prov_id { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class tbl_proveedor
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }

        public int prov_id { get; set; }
        public string prov_nombre { get; set; }

        // MODIFICADO: De char? a string
        public string prov_estado { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class tbl_usuario
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }

        public int usu_id { get; set; }
        public string usu_nombres { get; set; }
        public string usu_apellidos { get; set; }
        public string usu_cedula { get; set; }
        public string usu_correo { get; set; }
        public string usu_celular { get; set; }
        public string usu_direccion { get; set; }
        public DateTime? usu_fecha_cumple { get; set; }
        public string usu_nick { get; set; }
        [BsonSerializer(typeof(FlexibleByteArraySerializer))]
        public byte[] usu_contraseña { get; set; }
        public DateTime? usu_fecha_creacion { get; set; }
        public int usu_intento_fallido { get; set; }
        public DateTime? usu_fecha_ultimo_intento { get; set; }
        public bool? usu_bloqueado { get; set; }

        // MODIFICADO: De char? a string
        public string usu_estado { get; set; }
        public int? tusu_id { get; set; }
        public string usu_codigo_OTP { get; set; }
        public string usu_otp_secret { get; set; }
    }
}