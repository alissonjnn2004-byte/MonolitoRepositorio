<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registrar.aspx.cs" Inherits="Monolito_4am.Seguridad.Registrar" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuario - Monolito 4am</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <script type="text/javascript">
        // Restringe entrada a solo números
        function soloNumeros(e) {
            var key = e.keyCode || e.which;
            var teclado = String.fromCharCode(key);
            var numeros = "0123456789";
            if (numeros.indexOf(teclado) == -1 && key != 8 && key != 0) return false;
        }

        // Restringe entrada a solo letras
        function soloLetras(e) {
            var key = e.keyCode || e.which;
            var teclado = String.fromCharCode(key).toLowerCase();
            var letras = " áéíóúabcdefghijklmnñopqrstuvwxyz";
            if (letras.indexOf(teclado) == -1 && key != 8 && key != 0) return false;
        }
    </script>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: linear-gradient(135deg, #e8f5e9 0%, #fff8e7 30%, #fce4ec 70%, #fff0e0 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 30px 20px; position: relative; overflow-x: hidden; }
        .glass-container { background: rgba(255, 255, 255, 0.97); backdrop-filter: blur(10px); padding: 40px 45px; width: 100%; max-width: 950px; border-radius: 45px; box-shadow: 0 25px 55px rgba(120, 100, 80, 0.12); text-align: center; position: relative; z-index: 1; animation: fadeInUp 0.5s ease-out; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .header-icon { display: flex; justify-content: center; margin-bottom: 15px; }
        .icon-circle { width: 75px; height: 75px; background: linear-gradient(135deg, #c8e0c0, #b8d9a8); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 10px 25px rgba(184, 217, 168, 0.3); }
        .icon-circle i { font-size: 38px; color: #6a9c58; }
        h2 { margin-bottom: 8px; font-weight: 700; background: linear-gradient(135deg, #7caf6e, #9bc88a); -webkit-background-clip: text; background-clip: text; color: transparent; font-size: 32px; }
        .subtitle { color: #a8b89e; font-size: 13px; margin-bottom: 25px; font-weight: 500; }
        .progress-wrapper { width: 60%; height: 5px; background: #eef3ea; border-radius: 10px; margin: 0 auto 30px auto; overflow: hidden; }
        #progress-bar { width: 100%; height: 100%; background: linear-gradient(90deg, #b8d9a8, #ffcdb0, #ffb8a0); border-radius: 10px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px 30px; text-align: left; }
        .input-group { position: relative; margin-bottom: 5px; }
        .input-group label { display: block; font-size: 12px; margin-bottom: 8px; color: #9bb592; font-weight: 600; text-transform: uppercase; }
        .input-control { width: 100%; background: #fefcf7; border: 2px solid #e8f0e5; border-radius: 20px; padding: 12px 18px; color: #5d6b5e; font-size: 13px; outline: none; transition: 0.3s; }
        .input-control:focus { border-color: #b8d9a8; box-shadow: 0 0 0 4px rgba(184, 217, 168, 0.15); }
        .full-width { grid-column: span 2; }
        .btn-preview { background: #f0f2ea; color: #a0b898; border: none; padding: 8px 18px; border-radius: 30px; font-size: 12px; cursor: pointer; margin-top: 10px; }
        .previews-panel { margin-top: 12px; display: flex; gap: 12px; flex-wrap: wrap; padding: 10px; background: #fefcf7; border-radius: 20px; min-height: 70px; }
        .register-btn { grid-column: span 2; margin-top: 15px; padding: 14px; border-radius: 30px; border: none; background: linear-gradient(135deg, #b8d9a8, #a2cd8a); color: white; font-weight: 700; cursor: pointer; transition: 0.3s; }
        .register-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(162, 205, 138, 0.4); }
        .validation-message { font-size: 11px; color: #e08a6e; margin-top: 5px; font-weight: 500; }
        .msg-error { display: block; background: #fff0eb; border: 2px solid #e08a6e; color: #c0392b; padding: 12px 18px; border-radius: 15px; margin-bottom: 20px; font-size: 13px; font-weight: 600; text-align: left; }
        .msg-ok { display: block; background: #eef8ea; border: 2px solid #a2cd8a; color: #4a7c3f; padding: 12px 18px; border-radius: 15px; margin-bottom: 20px; font-size: 13px; font-weight: 600; text-align: left; }
        .back-link { margin-top: 25px; display: inline-flex; align-items: center; gap: 10px; font-size: 13px; color: #b0bc9a; text-decoration: none; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="glass-container">
            <div class="header-icon">
                <div class="icon-circle"><i class="fas fa-user-plus"></i></div>
            </div>
            <h2>Crear Cuenta</h2>
            <p class="subtitle">Completa todos los campos para registrarte</p>
            
            <div class="progress-wrapper">
                <div id="progress-bar"></div>
            </div>

            <asp:ValidationSummary ID="vsRegistro" runat="server" CssClass="validation-message" DisplayMode="BulletList" ShowSummary="true" HeaderText="Corrige los siguientes campos:" />

            <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="msg-error" />

            <div class="form-grid">
                <div class="input-group">
                    <label><i class="fas fa-id-card"></i> Cédula</label>
                    <asp:TextBox ID="txtCedula" runat="server" CssClass="input-control" placeholder="10 dígitos" onkeypress="return soloNumeros(event)" MaxLength="10"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCedula" runat="server" ControlToValidate="txtCedula" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revCedula" runat="server" ControlToValidate="txtCedula" ValidationExpression="^\d{10}$" ErrorMessage="10 números exactos" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-user-tag"></i> Apodo / Nick</label>
                    <asp:TextBox ID="txtNick" runat="server" CssClass="input-control" placeholder="Tu nombre de usuario"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNick" runat="server" ControlToValidate="txtNick" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                    <!-- Contenedor para sugerencias de apodos -->
                    <div id="sugerenciasApodo" style="display:flex; gap:5px; flex-wrap:wrap; margin-top:5px;"></div>
                </div>

                <div class="input-group">
                    <label><i class="fas fa-user"></i> Nombres</label>
                    <asp:TextBox ID="txtNombres" runat="server" CssClass="input-control" placeholder="Ej: Juan Carlos" onkeypress="return soloLetras(event)" onkeyup="generarApodos()"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNombres" runat="server" ControlToValidate="txtNombres" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-user-friends"></i> Apellidos</label>
                    <asp:TextBox ID="txtApellidos" runat="server" CssClass="input-control" placeholder="Ej: Pérez García" onkeypress="return soloLetras(event)" onkeyup="generarApodos()"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvApellidos" runat="server" ControlToValidate="txtApellidos" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-calendar-alt"></i> Fecha de Nacimiento</label>
                    <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="input-control" TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFecha" runat="server" ControlToValidate="txtFechaNacimiento" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-envelope"></i> Correo Electrónico</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="input-control" TextMode="Email" placeholder="usuario@ejemplo.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtCorreo" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revCorreo" runat="server" ControlToValidate="txtCorreo" ValidationExpression="^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$" ErrorMessage="Correo inválido" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-phone-alt"></i> Celular</label>
                    <asp:TextBox ID="txtCelular" runat="server" CssClass="input-control" placeholder="0998765432" onkeypress="return soloNumeros(event)" MaxLength="10"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCelular" runat="server" ControlToValidate="txtCelular" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revCelular" runat="server" ControlToValidate="txtCelular" ValidationExpression="^09\d{8}$" ErrorMessage="Formato: 09XXXXXXXX" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-user-shield"></i> Perfil</label>
                    <asp:DropDownList ID="ddl_Perfil" runat="server" CssClass="input-control"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvPerfil" runat="server" ControlToValidate="ddl_Perfil" InitialValue="0" ErrorMessage="Seleccione un perfil" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group full-width">
                    <label><i class="fas fa-map-marker-alt"></i> Dirección</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="input-control" placeholder="Ciudad, Barrio y Calle"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-lock"></i> Contraseña</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="input-control" TextMode="Password" placeholder="Min. 8 caracteres"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ValidationExpression="^.{8,}$" ErrorMessage="Mínimo 8 caracteres" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group">
                    <label><i class="fas fa-check-circle"></i> Confirmar Contraseña</label>
                    <asp:TextBox ID="txtConfirmar" runat="server" CssClass="input-control" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmar" runat="server" ControlToValidate="txtConfirmar" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmar" ControlToCompare="txtPassword" ErrorMessage="No coinciden" CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="input-group full-width">
                    <label><i class="fas fa-images"></i> Fotos de Perfil (Solo JPG/PNG - Máx 2MB)</label>
                    <asp:FileUpload ID="fuFoto" runat="server" CssClass="input-control" AllowMultiple="true" accept=".jpg,.jpeg,.png" onchange="validarArchivos(this);" />
                    
                    <asp:CustomValidator ID="cvFotos" runat="server" 
                        ValidationGroup="Fotos"
                        ClientValidationFunction="validarArchivosJS" 
                        ErrorMessage="Archivo muy pesado o formato no permitido (Solo JPG/PNG)" 
                        CssClass="validation-message" Display="Dynamic" />

                    <asp:Button ID="btnSubirPreview" runat="server" Text="Ver Fotos" OnClick="btnSubirPreview_Click" CausesValidation="false" CssClass="btn-preview" />
                    <asp:Panel ID="pnlPreviews" runat="server" CssClass="previews-panel"></asp:Panel>
                </div>

                <script type="text/javascript">
                    function validarArchivos(sender) {
                        return validarArchivosAntesDeSubir();
                    }

                    function validarArchivosJS(source, args) {
                        args.IsValid = validarArchivosAntesDeSubir();
                    }

                    function validarArchivosAntesDeSubir() {
                        var fup = document.getElementById('<%= fuFoto.ClientID %>');
                        var maxSise = 2 * 1024 * 1024; // 2MB

                        if (fup && fup.files && fup.files.length > 0) {
                            for (var i = 0; i < fup.files.length; i++) {
                                if (fup.files[i].size > maxSise) {
                                    alert("¡El archivo " + fup.files[i].name + " es muy pesado! Máximo 2MB por foto.");
                                    fup.value = ''; // Limpia la selección
                                    return false;
                                }
                            }
                        }
                        return true;
                    }

                    // Función para generar apodos sugeridos
                    function generarApodos() {
                        var txtNombres = document.getElementById('<%= txtNombres.ClientID %>').value.trim().toLowerCase();
                        var txtApellidos = document.getElementById('<%= txtApellidos.ClientID %>').value.trim().toLowerCase();
                        var contenedor = document.getElementById('sugerenciasApodo');
                        
                        contenedor.innerHTML = '';
                        
                        if (txtNombres.length < 2) return;

                        var partesNombre = txtNombres.split(/\s+/);
                        var primerNombre = partesNombre[0];
                        var primerApellido = txtApellidos.split(/\s+/)[0] || '';
                        
                        var sugerencias = [];
                        
                        // Diferentes lógicas para sugerir
                        if (primerApellido) sugerencias.push(primerNombre + primerApellido);
                        sugerencias.push(primerNombre + "123");
                        sugerencias.push(primerNombre + new Date().getFullYear());
                        if (primerApellido) sugerencias.push(primerNombre.charAt(0) + primerApellido);
                        if (primerApellido) sugerencias.push(primerNombre + '_' + primerApellido);

                        // Quitar acentos para el apodo
                        sugerencias = sugerencias.map(s => s.normalize("NFD").replace(/[\u0300-\u036f]/g, ""));
                        // Quitar duplicados y tomar 4
                        sugerencias = [...new Set(sugerencias)].slice(0, 4);

                        if (sugerencias.length > 0) {
                            var label = document.createElement('span');
                            label.textContent = "Sugerencias:";
                            label.style.cssText = "font-size:11px; color:#a8b89e; margin-right:5px; align-self:center; font-weight:600;";
                            contenedor.appendChild(label);
                        }

                        sugerencias.forEach(function(sug) {
                            var badge = document.createElement('span');
                            badge.textContent = sug;
                            badge.style.cssText = "background: #eef8ea; color: #5d8b4a; padding: 4px 10px; border-radius: 12px; font-size: 11px; cursor: pointer; border: 1px solid #b8d9a8; transition: 0.2s;";
                            badge.onmouseover = function() { this.style.background = '#d4e8cf'; }
                            badge.onmouseout = function() { this.style.background = '#eef8ea'; }
                            badge.onclick = function() {
                                document.getElementById('<%= txtNick.ClientID %>').value = sug;
                            };
                            contenedor.appendChild(badge);
                        });
                    }
                </script>

                <asp:Button ID="btn_Registrar" runat="server" Text="REGISTRAR USUARIO" CssClass="register-btn" CausesValidation="true" OnClick="btn_Registrar_Click" />
            </div>

            <a href="Login.aspx" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Login</a>
        </div>
    </form>
</body>
</html>