<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="nuevo_tbl_producto.aspx.cs" Inherits="Monolito_4am.nuevo_tbl_producto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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

        /* Formulario */
        .form-crear-prod { 
            background: #fefcf7;
            padding: 35px; 
            border-radius: 25px; 
            border: 1px solid #e8f0e5;
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 25px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            max-width: 900px;
            margin: 0 auto;
        }

        .form-group { 
            display: flex; 
            flex-direction: column; 
        }

        .full-width {
            grid-column: span 2;
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

        /* Botones */
        .btn-actions-container {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }

        .btn-accion { 
            padding: 12px 25px; 
            border: none; 
            border-radius: 16px; 
            cursor: pointer; 
            font-weight: 600; 
            transition: all 0.3s ease;
            font-size: 14px;
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
            text-decoration: none;
        }

        .btn-cancelar:hover { 
            background: #e5e8dd;
            transform: translateY(-1px);
            color: #a0b898;
        }

        .validation-message {
            font-size: 11px;
            color: #e08a6e;
            margin-top: 5px;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .form-crear-prod {
                grid-template-columns: 1fr;
            }
            .full-width {
                grid-column: span 1;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-plus-circle" style="color: #7caf6e;"></i>
            Registrar Nuevo Producto
        </h2>
    </div>

    <div class="form-crear-prod">
        <div class="form-group">
            <label><i class="fas fa-barcode"></i> Código de Producto</label>
            <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" placeholder="Ej. PROD-004"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvCodigo" runat="server" ControlToValidate="txtCodigo" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
        </div>

        <div class="form-group">
            <label><i class="fas fa-tag"></i> Nombre del Producto</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej. Vaso Térmico Elegante"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
        </div>

        <div class="form-group">
            <label><i class="fas fa-filter"></i> Categoría</label>
            <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control">
                <asp:ListItem Value="0">Seleccionar Categoría</asp:ListItem>
                <asp:ListItem Value="1">Cristalería</asp:ListItem>
                <asp:ListItem Value="2">Muebles</asp:ListItem>
                <asp:ListItem Value="3">Juegos</asp:ListItem>
                <asp:ListItem Value="4">Decoración</asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvCategoria" runat="server" ControlToValidate="ddlCategoria" InitialValue="0" ErrorMessage="Seleccione una categoría" CssClass="validation-message" Display="Dynamic" />
        </div>

        <div class="form-group">
            <label><i class="fas fa-dollar-sign"></i> Precio Unitario</label>
            <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="Ej. 12.99"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecio" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
        </div>

        <div class="form-group">
            <label><i class="fas fa-sort-amount-up"></i> Stock Inicial</label>
            <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" placeholder="Ej. 50" TextMode="Number"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock" ErrorMessage="Obligatorio" CssClass="validation-message" Display="Dynamic" />
        </div>

        <div class="form-group full-width">
            <label><i class="fas fa-info-circle"></i> Descripción Detallada</label>
            <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Escriba las características principales del producto..."></asp:TextBox>
        </div>

        <div class="btn-actions-container full-width">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" CssClass="btn-accion btn-guardar" OnClick="btnGuardar_Click" />
            <a href="<%= ResolveUrl("~/listar_tbl_producto.aspx") %>" class="btn-accion btn-cancelar">Cancelar</a>
        </div>
    </div>
</asp:Content>
