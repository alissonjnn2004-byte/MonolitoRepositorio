<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="ImportacionExcel.aspx.cs" Inherits="Monolito_4am.Seguridad.ImportacionExcel" %>

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

        .card-import {
            background: #fefcf7;
            padding: 30px;
            border-radius: 25px;
            border: 1px solid #e8f0e5;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            margin-bottom: 25px;
        }

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
            color: white;
        }

        .btn-guardar { 
            background: linear-gradient(135deg, #b8d9a8, #a2cd8a);
            box-shadow: 0 3px 10px rgba(162, 205, 138, 0.3);
        }

        .btn-guardar:hover { 
            background: linear-gradient(135deg, #c5e2b5, #b0d498);
            transform: translateY(-2px);
        }

        .btn-export {
            background: linear-gradient(135deg, #a8d8ea, #8cc9e0);
            box-shadow: 0 3px 10px rgba(168, 216, 234, 0.3);
            color: #2a7894;
        }

        .btn-export:hover {
            background: linear-gradient(135deg, #bbe2f0, #9ed4e8);
            transform: translateY(-2px);
        }

        .alert-info {
            background: #eaf3e5;
            color: #5d8b4a;
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-file-excel" style="color: #7caf6e;"></i> 
            Importación Excel
        </h2>
    </div>

    <div class="card-import">
        <h4 style="color: #5d8b4a; margin-bottom: 15px;">Gestión Masiva de Productos</h4>
        <div class="alert-info">
            <i class="fas fa-info-circle"></i> Descarga la plantilla CSV actual exportando los productos, agrega las nuevas filas siguiendo exactamente el formato, y sube el archivo para registrar masivamente.
        </div>
        
        <div class="d-flex align-items-center" style="gap: 15px; margin-bottom: 20px;">
            <asp:FileUpload ID="fuExcelProductos" runat="server" CssClass="form-control" style="width: auto;" accept=".csv" />
            <asp:Button ID="btnImportarProductos" runat="server" Text="Importar Productos" CssClass="btn-accion btn-guardar" OnClick="btnImportarProductos_Click" />
            <asp:Button ID="btnExportarProductos" runat="server" Text="Exportar Productos" CssClass="btn-accion btn-export" OnClick="btnExportarProductos_Click" />
        </div>
    </div>

    <div class="card-import">
        <h4 style="color: #5d8b4a; margin-bottom: 15px;">Gestión Masiva de Proveedores</h4>
        <div class="alert-info">
            <i class="fas fa-info-circle"></i> Descarga la lista de proveedores actuales y sube un CSV con la misma estructura para agregar nuevos masivamente.
        </div>
        
        <div class="d-flex align-items-center" style="gap: 15px;">
            <asp:FileUpload ID="fuExcelProveedores" runat="server" CssClass="form-control" style="width: auto;" accept=".csv" />
            <asp:Button ID="btnImportarProveedores" runat="server" Text="Importar Proveedores" CssClass="btn-accion btn-guardar" OnClick="btnImportarProveedores_Click" />
            <asp:Button ID="btnExportarProveedores" runat="server" Text="Exportar Proveedores" CssClass="btn-accion btn-export" OnClick="btnExportarProveedores_Click" />
        </div>
    </div>
</asp:Content>
