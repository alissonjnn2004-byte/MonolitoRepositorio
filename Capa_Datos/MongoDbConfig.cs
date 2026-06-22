namespace Capa_Datos
{
    /// <summary>
    /// Cadena de conexión definida al iniciar la aplicación web (Global.asax).
    /// Evita que Capa_Datos lea un .config incorrecto de la DLL.
    /// </summary>
    public static class MongoDbConfig
    {
        public static string ConnectionString { get; set; }
    }
}
