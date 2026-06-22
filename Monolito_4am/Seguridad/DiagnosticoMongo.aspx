<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DiagnosticoMongo.aspx.cs" Inherits="Monolito_4am.Seguridad.DiagnosticoMongo" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8" />
    <title>Diagnóstico MongoDB</title>
    <style>
        body { font-family: Consolas, monospace; padding: 20px; background: #f5f5f5; }
        pre { background: #fff; padding: 16px; border-radius: 8px; border: 1px solid #ccc; white-space: pre-wrap; }
        a { color: #2e7d32; }
    </style>
</head>
<body>
    <h2>Diagnóstico de conexión MongoDB</h2>
    <p>Esta página usa la <strong>misma conexión</strong> que el registro de usuarios.</p>
    <pre runat="server" id="salida"></pre>
    <p><a href="Registrar.aspx">Volver a Registrar</a></p>
</body>
</html>
