using System;
using System.Collections.Generic;
using System.Text;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Bson.Serialization;
using MongoDB.Bson.Serialization.Serializers;

namespace Capa_Datos
{
    //personalizado para MongoDB. Su función es leer y guardar imágenes y
    //contraseñas almacenadas como arreglos de bytes
    public class FlexibleByteArraySerializer : SerializerBase<byte[]>
    {
        public override byte[] Deserialize(BsonDeserializationContext context, BsonDeserializationArgs args)
        {
            var reader = context.Reader;
            switch (reader.GetCurrentBsonType())
            {
                case BsonType.Null:
                    reader.ReadNull();
                    return null;
                case BsonType.Binary:
                    return reader.ReadBinaryData().Bytes;
                case BsonType.String:
                    var text = reader.ReadString();
                    if (string.IsNullOrEmpty(text))
                        return Array.Empty<byte>();
                    if (EsNombreDeArchivoMigrado(text))
                        return Array.Empty<byte>();
                    try
                    {
                        return Convert.FromBase64String(text);
                    }
                    catch (FormatException)
                    {
                        return Encoding.UTF8.GetBytes(text);
                    }
                case BsonType.Array:
                    var bytes = new List<byte>();
                    reader.ReadStartArray();
                    while (reader.State == BsonReaderState.Type)
                    {
                        reader.ReadBsonType();
                        bytes.Add((byte)reader.ReadInt32());
                    }
                    reader.ReadEndArray();
                    return bytes.ToArray();
                default:
                    reader.SkipValue();
                    return Array.Empty<byte>();
            }
        }

        public override void Serialize(BsonSerializationContext context, BsonSerializationArgs args, byte[] value)
        {
            if (value == null)
            {
                context.Writer.WriteNull();
                return;
            }

            context.Writer.WriteBinaryData(new BsonBinaryData(value, BsonBinarySubType.Binary));
        }

       
        private static bool EsNombreDeArchivoMigrado(string text)
        {
            if (text.Length > 260)
                return false;

            var lower = text.ToLowerInvariant();
            return lower.EndsWith(".jpg") || lower.EndsWith(".jpeg") || lower.EndsWith(".png")
                || lower.EndsWith(".gif") || lower.EndsWith(".bmp") || lower.EndsWith(".webp");
        }
    }
}
