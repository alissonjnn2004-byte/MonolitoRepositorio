<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="MenuAdministrador.aspx.cs" Inherits="Monolito_4am.Seguridad.MenuAdministrador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Solo estilos para Gestión de Usuarios -->
    <style>
        /* Estilos específicos de Gestión de Usuarios adaptados a la Master Page */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e8f0e5;
        }

        .page-title {
            color: #7caf6e;
            font-weight: 700;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        .badge-admin {
            background: linear-gradient(135deg, #d4e8cf, #c8e0c0);
            padding: 6px 16px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            color: #5d8b4a;
        }

        /* Formulario */
        .form-crear { 
            background: #fefcf7;
            padding: 25px; 
            border-radius: 25px; 
            margin-bottom: 35px; 
            border: 1px solid #e8f0e5;
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
            gap: 20px; 
            align-items: end;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
        }

        .form-group { 
            display: flex; 
            flex-direction: column; 
        }

        .form-group label { 
            font-size: 12px; 
            margin-bottom: 8px; 
            color: #9bb592;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group label i {
            margin-right: 6px;
            font-size: 11px;
        }

        .form-control { 
            padding: 12px 15px; 
            border: 2px solid #e8f0e5;
            border-radius: 16px;
            outline: none; 
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            border-color: #b8d9a8;
            box-shadow: 0 0 0 4px rgba(184, 217, 168, 0.2);
        }

        /* Botones del formulario */
        .btn-accion { 
            padding: 12px 22px; 
            border: none; 
            border-radius: 16px; 
            cursor: pointer; 
            font-weight: 600; 
            transition: all 0.3s ease;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-guardar { 
            background: linear-gradient(135deg, #b8d9a8, #a2cd8a);
            color: white;
            box-shadow: 0 3px 10px rgba(162, 205, 138, 0.3);
        }

        .btn-guardar:hover { 
            background: linear-gradient(135deg, #c5e2b5, #b0d498);
            transform: translateY(-2px);
        }

        .btn-cancelar { 
            background: #f0f2ea;
            color: #a0b898;
        }

        .btn-cancelar:hover { 
            background: #e5e8dd;
            transform: translateY(-1px);
        }

        /* Tabla */
        .table-container {
            overflow-x: auto;
            border-radius: 20px;
        }

        .table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 10px;
            font-size: 13px;
        }

        .table th { 
            background: linear-gradient(135deg, #f0f6ec, #eaf3e5);
            color: #7caf6e;
            padding: 18px 12px; 
            text-align: left;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        .table td { 
            padding: 16px 12px; 
            border-bottom: 1px solid #eef3ea;
            vertical-align: middle;
        }

        .table tr:hover {
            background: #fefcf7;
            transition: background 0.2s;
        }

        /* Estados */
        .estado-activo {
            display: inline-block;
            padding: 4px 12px;
            background: #d4e8cf;
            color: #5d8b4a;
            border-radius: 30px;
            font-size: 11px;
            font-weight: 600;
        }

        .estado-bloqueado {
            display: inline-block;
            padding: 4px 12px;
            background: #ffe0d6;
            color: #e08a6e;
            border-radius: 30px;
            font-size: 11px;
            font-weight: 600;
        }

        /* Botones de la grilla */
        .acciones {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-grid { 
            padding: 8px 12px; 
            border-radius: 12px; 
            border: none; 
            color: white; 
            cursor: pointer; 
            font-size: 13px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
        }

        .btn-edit { 
            background: linear-gradient(135deg, #ffd966, #ffcd4a);
            color: #8b6912;
        }
        .btn-edit:hover { background: linear-gradient(135deg, #ffe085, #ffd45e); transform: scale(1.02); color: #8b6912; }

        .btn-delete { 
            background: linear-gradient(135deg, #ffb7a8, #ffa08c);
            color: #c55a3a;
        }
        .btn-delete:hover { background: linear-gradient(135deg, #ffc8bc, #ffb2a0); transform: scale(1.02); color: #c55a3a; }

        .btn-unlock { 
            background: linear-gradient(135deg, #a8d8ea, #8cc9e0);
            color: #2a7894;
        }
        .btn-unlock:hover { background: linear-gradient(135deg, #bbe2f0, #9ed4e8); transform: scale(1.02); color: #2a7894; }

        /* Fotos */
        .fotos-container {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }
        
        .foto-miniatura {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e8f0e5;
            background: #fafaf5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-crear {
                grid-template-columns: 1fr;
            }
            
            .table th, .table td {
                padding: 12px 8px;
            }
            
            .acciones {
                flex-direction: column;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-users-cog" style="color: #7caf6e;"></i> 
            Gestion de Usuarios
            <span class="badge-admin"><i class="fas fa-shield-alt"></i> Administrador</span>
        </h2>
    </div>

    
    <!-- Formulario de Registro/Edición -->
    <div class="form-crear">
        <asp:HiddenField ID="hfUsuarioID" runat="server" />
        <div class="form-group">
            <label><i class="fas fa-user"></i> Nombres completos</label>
            <asp:TextBox ID="txtNombres" runat="server" CssClass="form-control" placeholder="Ej. Juan Pérez García"></asp:TextBox>
        </div>
        <div class="form-group">
            <label><i class="fas fa-id-card"></i> Cédula</label>
            <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" placeholder="1723456789"></asp:TextBox>
        </div>
        <div class="form-group">
            <label><i class="fas fa-envelope"></i> Correo electrónico</label>
            <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" placeholder="usuario@ejemplo.com"></asp:TextBox>
        </div>
        <div style="display:flex; gap:12px; align-items:center;">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn-accion btn-guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Limpiar" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" />
        </div>
    </div>

    <!-- Tabla de Usuarios -->
    <div class="table-container">
        <asp:GridView ID="gvUsuarios" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="gvUsuariosRowCommand" GridLines="None">
            <Columns>
                <asp:TemplateField HeaderText="Foto">
                    <ItemTemplate>
                        <div class="fotos-container">
                            <asp:Repeater ID="rpFotos" runat="server" DataSource='<%# Eval("Fotos") %>'>
                                <ItemTemplate>
                                    <img src='data:image/jpg;base64,<%# Container.DataItem %>' class="foto-miniatura" />
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:BoundField DataField="usu_id" HeaderText="ID" />
                <asp:BoundField DataField="usu_nombres" HeaderText="Nombre completo" />
                <asp:BoundField DataField="usu_cedula" HeaderText="Cédula" />
                
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='<%# (Eval("usu_bloqueado") != null && Eval("usu_bloqueado").ToString() == "True") ? "estado-bloqueado" : "estado-activo" %>'>
                            <i class='<%# (Eval("usu_bloqueado") != null && Eval("usu_bloqueado").ToString() == "True") ? "fas fa-lock" : "fas fa-check-circle" %>'></i>
                            <%# Eval("usu_bloqueado") != null && Eval("usu_bloqueado").ToString() == "True" ? "Bloqueado" : "Activo" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <div class="acciones">
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Editar" CommandArgument='<%# Eval("usu_id") %>' CssClass="btn-grid btn-edit" ToolTip="Editar usuario">
                                <i class="fas fa-edit"></i> Editar
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("usu_id") %>' CssClass="btn-grid btn-delete" OnClientClick="return confirm('¿Eliminar este usuario?');" ToolTip="Eliminar usuario">
                                <i class="fas fa-trash-alt"></i> Eliminar
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnUnlock" runat="server" CommandName="Desbloquear" CommandArgument='<%# Eval("usu_id") %>' CssClass="btn-grid btn-unlock" Visible='<%# Eval("usu_bloqueado") != null && Convert.ToBoolean(Eval("usu_bloqueado")) %>' ToolTip="Desbloquear usuario">
                                <i class="fas fa-unlock-alt"></i> Desbloquear
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>