using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Configuration;
using Capa_Datos;

namespace Monolito_4am
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            var conexion = WebConfigurationManager.ConnectionStrings["conexion"];
            if (conexion != null && !string.IsNullOrWhiteSpace(conexion.ConnectionString))
                MongoDbConfig.ConnectionString = conexion.ConnectionString;

            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}