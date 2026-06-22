<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerificarOTP.aspx.cs" Inherits="Monolito_4am.Seguridad.VerificarOTP" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>Escanear QR - Monolito 4am</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/html5-qrcode"></script>
    
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Poppins', sans-serif; 
        }
        
        body { 
            background: linear-gradient(135deg, #e8f5e9 0%, #fff8e7 30%, #fce4ec 70%, #fff0e0 100%);
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            padding: 20px; 
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(200, 230, 180, 0.2) 0%, rgba(200, 230, 180, 0) 70%);
            border-radius: 50%;
            top: -150px;
            right: -150px;
            pointer-events: none;
        }

        body::after {
            content: '';
            position: fixed;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(255, 210, 190, 0.15) 0%, rgba(255, 210, 190, 0) 70%);
            border-radius: 50%;
            bottom: -120px;
            left: -120px;
            pointer-events: none;
        }

        .glass-card { 
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(10px);
            padding: 40px 35px; 
            width: 100%; 
            max-width: 550px; 
            border-radius: 45px; 
            box-shadow: 0 25px 55px rgba(120, 100, 80, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.9);
            text-align: center;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
            animation: fadeInUp 0.5s ease-out;
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

        .icon-container {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .icon-circle {
            width: 85px;
            height: 85px;
            background: linear-gradient(135deg, #c8e0c0, #b8d9a8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 25px rgba(184, 217, 168, 0.3);
        }

        .icon-circle i {
            font-size: 42px;
            color: #6a9c58;
        }

        h2 { 
            margin-bottom: 10px;
            font-weight: 700;
            background: linear-gradient(135deg, #7caf6e, #9bc88a);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            font-size: 32px;
            letter-spacing: -0.5px;
        }

        .subtitle {
            font-size: 14px;
            color: #a8b89e;
            margin-bottom: 20px;
            font-weight: 500;
        }

        #reader { 
            width: 100%; 
            background: #fefcf7;
            border-radius: 25px; 
            overflow: hidden; 
            margin-bottom: 20px;
            border: 3px solid #e8f0e5;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        #reader video {
            border-radius: 22px;
        }

        .btn-hidden { 
            display: none; 
        }

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
            padding: 12px 24px;
            background: #fefcf7;
            border-radius: 35px;
            border: 1px solid #e8f0e5;
        }

        .back-link:hover {
            color: #7caf6e;
            transform: translateX(-3px);
            background: #faf8f2;
            border-color: #b8d9a8;
        }

        /* Indicador de escaneo */
        .scan-status {
            margin-top: 15px;
            font-size: 12px;
            color: #b8b8a8;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .scan-status i {
            font-size: 10px;
            color: #b8d9a8;
        }

        @media (max-width: 550px) {
            .glass-card {
                padding: 30px 25px;
            }
            
            h2 {
                font-size: 26px;
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
        <asp:HiddenField ID="hfCodigoEscaneado" runat="server" />
        
        <div class="glass-card">
            <div class="icon-container">
                <div class="icon-circle">
                    <i class="fas fa-qrcode"></i>
                </div>
            </div>
            
            <h2>Escanea tu QR</h2>
            <p class="subtitle">Apunta con la cámara al código generado en tu aplicación.</p>
            <div style="margin-top:20px;">
        
            <br /><br />

            <asp:Button
                ID="btnVerificarManual"
                runat="server"
                Text="Ingresar Código"
                OnClick="btnVerificarManual_Click"
                style="
                    background:#7caf6e;
                    color:white;
                    border:none;
                    padding:12px 25px;
                    border-radius:12px;
                    cursor:pointer;">
            </asp:Button>

             <asp:TextBox
                ID="txtCodigoManual"
                runat="server"
                placeholder="Ingrese el código"
                style="
                    padding:12px;
                    border-radius:12px;
                    border:1px solid #ccc;
                    width:100%;
                    max-width:250px;
                    text-align:center;
                    font-size:18px;
                    letter-spacing:3px;">
            </asp:TextBox>

            </div>

            <div id="reader"></div>

            <asp:Button ID="btnProcesarQR" runat="server" CssClass="btn-hidden" OnClick="btnProcesarQR_Click" />

            <div class="scan-status">
                <i class="fas fa-circle"></i>
                <span>Cámara activa - Esperando código QR</span>
            </div>

            <asp:LinkButton ID="btnRegresar" runat="server" CssClass="back-link" OnClick="btnRegresarLogin_Click">
                <i class="fas fa-arrow-left"></i> Volver al Login
            </asp:LinkButton>
        </div>

        <!-- SCRIPT ORIGINAL SIN MODIFICAR - EXACTAMENTE IGUAL -->
        <script>
            function onScanSuccess(decodedText, decodedResult) {
                // 1. Guardamos el texto en el HiddenField
                document.getElementById('<%= hfCodigoEscaneado.ClientID %>').value = decodedText;
                
                // 2. Detenemos la cámara
                html5QrcodeScanner.clear();
                
                // 3. Ejecutamos el postback del servidor
                document.getElementById('<%= btnProcesarQR.ClientID %>').click();
            }

            var html5QrcodeScanner = new Html5QrcodeScanner(
                "reader", { fps: 10, qrbox: 250 });
            html5QrcodeScanner.render(onScanSuccess);
        </script>
    </form>
</body>
</html>