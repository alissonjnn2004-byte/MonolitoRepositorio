<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Recuperar.aspx.cs" Inherits="Monolito_4am.Seguridad.Recuperar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña - Monolito 4am</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #e8f5e9 0%, #fff8e7 30%, #fce4ec 70%, #fff0e0 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* Decoración de fondo */
        body::before {
            content: '';
            position: absolute;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(200, 230, 180, 0.2) 0%, rgba(200, 230, 180, 0) 70%);
            border-radius: 50%;
            top: -150px;
            left: -150px;
        }

        body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255, 210, 190, 0.15) 0%, rgba(255, 210, 190, 0) 70%);
            border-radius: 50%;
            bottom: -150px;
            right: -150px;
        }

        .card {
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(10px);
            padding: 45px 35px;
            border-radius: 45px;
            box-shadow: 0 25px 55px rgba(120, 100, 80, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.9);
            text-align: center;
            width: 100%;
            max-width: 400px;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
            animation: fadeInUp 0.5s ease-out;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Icono decorativo */
        .icon-circle {
            width: 85px;
            height: 85px;
            background: linear-gradient(135deg, #c8e0c0, #b8d9a8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 25px rgba(184, 217, 168, 0.3);
        }

        .icon-circle i {
            font-size: 42px;
            color: #6a9c58;
        }

        h2 {
            color: #7caf6e;
            margin-bottom: 12px;
            font-weight: 700;
            font-size: 28px;
            letter-spacing: -0.5px;
        }

        .subtitle {
            color: #a8b89e;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 30px;
        }

        /* Estilos para el input */
        .input-group {
            margin-bottom: 25px;
            text-align: left;
        }

        .input-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #9bb592;
            margin-bottom: 8px;
            margin-left: 5px;
        }

        .input-label i {
            margin-right: 6px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i.input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #c5d6bb;
            font-size: 16px;
        }

        .input-pastel {
            width: 100%;
            padding: 14px 16px 14px 45px;
            border: 2px solid #e8f0e5;
            border-radius: 25px;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background: #fefcf7;
            color: #5d6b5e;
            font-weight: 500;
            outline: none;
        }

        .input-pastel:focus {
            border-color: #b8d9a8;
            background: white;
            box-shadow: 0 0 0 4px rgba(184, 217, 168, 0.15);
        }

        .input-pastel::placeholder {
            color: #d4cfc0;
            font-weight: 400;
        }

        /* Botón principal */
        .btn-recuperar {
            background: linear-gradient(135deg, #b8d9a8, #a2cd8a);
            color: white;
            border: none;
            padding: 14px 20px;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            font-size: 15px;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(162, 205, 138, 0.3);
        }

        .btn-recuperar:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(162, 205, 138, 0.4);
            background: linear-gradient(135deg, #c5e2b5, #b0d498);
        }

        .btn-recuperar:active {
            transform: translateY(0);
        }

        /* Mensaje de resultado - MISMA ESTRUCTURA ORIGINAL */
        .mensaje {
            margin-top: 15px;
            display: block;
            font-size: 13px;
            font-weight: 500;
            padding: 12px;
            border-radius: 25px;
            background: #fefcf7;
            color: #e08a6e;
        }

        /* Enlace volver */
        .back-link {
            margin-top: 20px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: #b0bc9a;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: #7caf6e;
            transform: translateX(-3px);
        }

        /* Responsive */
        @media (max-width: 480px) {
            .card {
                padding: 35px 25px;
            }
            
            h2 {
                font-size: 24px;
            }
            
            .icon-circle {
                width: 70px;
                height: 70px;
            }
            
            .icon-circle i {
                font-size: 34px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <div class="icon-circle">
                <i class="fab fa-whatsapp"></i>
            </div>
            
            <h2>Recuperar Cuenta</h2>
            <p class="subtitle">Ingresa tu cédula para generar una clave temporal.</p>

            <div class="input-group">
                <span class="input-label">
                    <i class="fas fa-id-card"></i>
                    Número de Cédula
                </span>
                <div class="input-wrapper">
                    <i class="fas fa-id-card input-icon"></i>
                    <!-- ID EXACTO: txtCedulaRecuperar -->
                    <asp:TextBox ID="txtCedulaRecuperar" runat="server" CssClass="input-pastel" 
                        placeholder="Ej: 1234567890" MaxLength="10"></asp:TextBox>
                </div>
            </div>
            
            <asp:Button ID="btnRecuperar" runat="server" Text="Enviar a WhatsApp" 
                CssClass="btn-recuperar" OnClick="btnRecuperar_Click" />
            
            <!-- ID EXACTO: lblMensaje - MISMA ESTRUCTURA ORIGINAL -->
            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje"></asp:Label>
            
            <div class="back-link">
                <a href="Login.aspx" style="color: inherit; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fas fa-arrow-left"></i> Volver al Login
                </a>
            </div>
        </div>
    </form>
</body>
</html>