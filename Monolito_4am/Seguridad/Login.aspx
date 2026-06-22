<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Monolito4am.Seguridad.Login" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Monolito 4am</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Poppins', sans-serif; 
        }
        
        body {
            background: linear-gradient(135deg, #f5f0ff 0%, #e8e0ff 50%, #f0e6ff 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            position: relative;
        }

        /* Decoración de fondo con círculos pastel */
        body::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(198, 177, 255, 0.3) 0%, rgba(198, 177, 255, 0) 70%);
            border-radius: 50%;
            top: -100px;
            left: -100px;
        }

        body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255, 214, 214, 0.3) 0%, rgba(255, 214, 214, 0) 70%);
            border-radius: 50%;
            bottom: -150px;
            right: -150px;
        }

        .glass-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 50px 40px;
            width: 480px;
            border-radius: 35px;
            box-shadow: 0 20px 60px rgba(149, 120, 200, 0.25), 0 0 0 1px rgba(255, 255, 255, 0.8);
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 1;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 70px rgba(149, 120, 200, 0.3);
        }

        /* Logo o ícono decorativo */
        .logo-circle {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #c6b1ff 0%, #b8a3ff 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            box-shadow: 0 8px 20px rgba(184, 163, 255, 0.3);
        }

        .logo-circle i {
            font-size: 40px;
            color: white;
        }

        h2 { 
            margin-bottom: 8px;
            font-weight: 700;
            background: linear-gradient(135deg, #9b7bdf 0%, #b8a3ff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 32px;
        }

        .welcome-text { 
            font-size: 14px;
            margin-bottom: 30px;
            color: #a888c5;
            font-weight: 400;
        }

        /* Barra de progreso */
        .progress-wrapper { 
            width: 100%;
            height: 6px;
            background: #f0eaff;
            border-radius: 10px;
            margin-bottom: 25px;
            overflow: hidden;
            display: none;
        }

        .progress-bar-fill { 
            height: 100%;
            background: linear-gradient(90deg, #c6b1ff, #9b7bdf);
            width: 0%;
            transition: width 0.1s linear;
            border-radius: 10px;
        }

        #progressText {
            font-size: 11px;
            display: block;
            margin-top: 8px;
            color: #9b7bdf;
            font-weight: 500;
            text-align: center;
        }

        .input-wrapper { 
            width: 100%;
            margin-bottom: 20px;
            text-align: left;
        }

        .input-label { 
            font-size: 13px;
            margin-bottom: 8px;
            display: block;
            margin-left: 5px;
            color: #7a609b;
            font-weight: 500;
        }

        .input-group-custom { 
            position: relative;
            width: 100%;
        }

        .input-group-custom i { 
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #b8a3ff;
            z-index: 10;
            font-size: 16px;
            transition: color 0.3s ease;
        }
        
        .input-group-custom .eye-icon { 
            left: auto;
            right: 18px;
            cursor: pointer;
            color: #b8a3ff;
            transition: color 0.3s ease;
        }

        .input-group-custom .eye-icon:hover {
            color: #9b7bdf;
        }

        .input-group-custom input {
            width: 100%;
            background: #fbf9ff;
            border: 2px solid #e8e0ff;
            border-radius: 15px;
            padding: 14px 20px 14px 48px;
            color: #5a4a7a;
            outline: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .input-group-custom input:focus {
            border-color: #c6b1ff;
            background: white;
            box-shadow: 0 0 0 4px rgba(198, 177, 255, 0.2);
        }

        .input-group-custom input::placeholder {
            color: #cdc0e0;
            font-weight: 400;
        }

        .extra-options { 
            width: 100%;
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            margin-bottom: 25px;
            padding: 0 5px;
        }

        .extra-options label {
            color: #7a609b;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .extra-options input[type="checkbox"] {
            accent-color: #c6b1ff;
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .extra-options a { 
            color: #9b7bdf;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .extra-options a:hover {
            color: #7a609b;
            text-decoration: underline;
        }

        .login-btn { 
            width: 100%;
            padding: 14px;
            border-radius: 15px;
            border: none;
            background: linear-gradient(135deg, #c6b1ff 0%, #b8a3ff 100%);
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 15px;
            box-shadow: 0 4px 15px rgba(184, 163, 255, 0.3);
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(184, 163, 255, 0.4);
            background: linear-gradient(135deg, #d0bcff 0%, #c6b1ff 100%);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        .separator { 
            margin: 25px 0 20px;
            font-size: 12px;
            position: relative;
            width: 100%;
            text-align: center;
            color: #b8a3ff;
            font-weight: 500;
        }

        .separator::before, 
        .separator::after { 
            content: "";
            position: absolute;
            top: 50%;
            width: 35%;
            height: 1px;
            background: linear-gradient(90deg, transparent, #e8e0ff, transparent);
        }

        .separator::before { 
            left: 0;
        }

        .separator::after { 
            right: 0;
        }

        .social-buttons { 
            display: flex;
            gap: 12px;
            width: 100%;
            margin-bottom: 25px;
        }

        .social-btn { 
            flex: 1;
            padding: 12px;
            border-radius: 12px;
            border: 2px solid #e8e0ff;
            background: #fbf9ff;
            color: #7a609b;
            font-size: 13px;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .social-btn:hover {
            background: #f5f0ff;
            border-color: #c6b1ff;
            transform: translateY(-2px);
            color: #9b7bdf;
        }

        .social-btn i {
            font-size: 18px;
        }

        .register-text {
            font-size: 13px;
            margin-top: 5px;
            color: #a888c5;
        }

        .register-text a {
            color: #9b7bdf;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .register-text a:hover {
            color: #7a609b;
            text-decoration: underline;
        }

        /* Animación de entrada */
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

        .glass-container {
            animation: fadeInUp 0.6s ease-out;
        }
    </style>
</head>
<body>

    <form id="form1" runat="server">
        <div class="glass-container">
            <div class="logo-circle">
                <i class="fas fa-leaf"></i>
            </div>
            <h2>Bienvenido</h2>
            <p class="welcome-text">Inicia sesión para continuar</p>

            <div id="loadingArea" class="progress-wrapper">
                <div id="pbar" class="progress-bar-fill"></div>
                <small id="progressText">Procesando...</small>
            </div>

            <div class="input-wrapper">
                <span class="input-label">
                    <i class="fas fa-user" style="font-size: 11px; margin-right: 5px;"></i>
                    Usuario
                </span>
                <div class="input-group-custom">
                    <i class="fas fa-user"></i>
                    <asp:TextBox ID="txtCedula" runat="server" placeholder="Ingrese su cédula" required="required"></asp:TextBox>
                </div>
            </div>

            <div class="input-wrapper">
                <span class="input-label">
                    <i class="fas fa-lock" style="font-size: 11px; margin-right: 5px;"></i>
                    Contraseña
                </span>
                <div class="input-group-custom">
                    <i class="fas fa-lock"></i>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Ingrese su contraseña" required="required"></asp:TextBox>
                    <i class="fas fa-eye eye-icon" id="togglePassword"></i>
                </div>
            </div>

            <div class="extra-options">
                <label>
                    <asp:CheckBox ID="chkRecordarme" runat="server" />
                    Recordarme
                </label>
                <a href="Recuperar.aspx">¿Olvidaste tu contraseña?</a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" 
                CssClass="login-btn" OnClick="btnLogin_Click" />

            <div class="separator">o continúa con</div>
            <div class="social-buttons">
                <a href="#" class="social-btn"><i class="fab fa-google"></i> Google</a>
                <a href="#" class="social-btn"><i class="fab fa-github"></i> GitHub</a>
            </div>

            <p class="register-text">
                ¿No tienes una cuenta? <a href="Registrar.aspx">Regístrate</a>
            </p>
        </div>
    </form>

    <script>
        let formSubmitted = false;

        function startLoading(btn) {
            if (!document.getElementById('form1').checkValidity()) {
                return true;
            }

            if (formSubmitted) return false;
            formSubmitted = true;

            $("#loadingArea").fadeIn();
            $(btn).fadeOut(200);

            let width = 0;
            const duration = 3000;
            const intervalTime = 30;
            const step = (intervalTime / duration) * 100;

            const interval = setInterval(function () {
                width += step;
                if (width >= 100) {
                    $("#pbar").css("width", "100%");
                    $("#progressText").text("Completado");
                    clearInterval(interval);

                    setTimeout(function () {
                        __doPostBack(btn.name, '');
                    }, 200);
                } else {
                    $("#pbar").css("width", width + "%");
                }
            }, intervalTime);

            return false;
        }

        const togglePassword = document.querySelector('#togglePassword');
        const passwordInput = document.querySelector('#<%= txtPassword.ClientID %>');

        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function () {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.classList.toggle('fa-eye-slash');
            });
        }
    </script>
</body>
</html>