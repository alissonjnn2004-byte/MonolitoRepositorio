<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="listar_tbl_producto.aspx.cs" Inherits="Monolito_4am.listar_tbl_producto" %>

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

        .search-container {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            max-width: 500px;
        }

        .btn-add {
            background: linear-gradient(135deg, #7caf6e, #9bc88a);
            color: white;
            padding: 10px 22px;
            border-radius: 16px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(124, 175, 110, 0.2);
            border: none;
        }

        .btn-add:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(124, 175, 110, 0.3);
            color: white;
        }

        /* Tabla de Productos */
        .table-container {
            overflow-x: auto;
            border-radius: 20px;
            background: white;
            border: 1px solid #e8f0e5;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .table th {
            background: linear-gradient(135deg, #f0f6ec, #eaf3e5);
            color: #7caf6e;
            padding: 18px 15px;
            text-align: left;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2ebd8;
        }

        .table td {
            padding: 16px 15px;
            border-bottom: 1px solid #eef3ea;
            vertical-align: middle;
            color: #5d6b5e;
        }

        .table tr:hover {
            background: #fafcf9;
            transition: background 0.2s;
        }

        .badge-stock {
            padding: 4px 12px;
            border-radius: 30px;
            font-size: 11px;
            font-weight: 600;
        }

        .stock-high {
            background: #d4e8cf;
            color: #5d8b4a;
        }

        .stock-low {
            background: #ffe0d6;
            color: #e08a6e;
        }

        .actions {
            display: flex;
            gap: 8px;
        }

        .btn-action-edit {
            color: #8b6912;
            background: #fff8e1;
            padding: 8px 12px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s ease;
        }

        .btn-action-edit:hover {
            background: #ffe082;
            color: #8b6912;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-boxes" style="color: #7caf6e;"></i>
            Inventario de Productos
        </h2>
        <a href="<%= ResolveUrl("~/nuevo_tbl_producto.aspx") %>" class="btn-add">
            <i class="fas fa-plus"></i> Nuevo Producto
        </a>
    </div>

    <!-- Carrusel de Productos -->
    <div id="carouselProductos" class="carousel slide mb-4" data-bs-ride="carousel" data-bs-interval="3000" style="background: white; border-radius: 20px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.02);">
        <h5 style="color: #7caf6e; text-align: center; margin-bottom: 15px; font-weight: 600;">Productos Destacados</h5>
        <div class="carousel-inner" id="carouselInner" runat="server">
            <!-- Se llenará desde CodeBehind -->
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselProductos" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true" style="background-color: #7caf6e; border-radius: 50%; padding: 15px;"></span>
            <span class="visually-hidden">Anterior</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselProductos" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true" style="background-color: #7caf6e; border-radius: 50%; padding: 15px;"></span>
            <span class="visually-hidden">Siguiente</span>
        </button>
    </div>

    <!-- Opciones de Excel / CSV -->
    <div class="d-flex justify-content-between align-items-center mb-3" style="background: white; padding: 15px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.02); flex-wrap: wrap; gap: 10px;">
        <div style="display: flex; gap: 10px; align-items: center;">
            <asp:FileUpload ID="fuExcel" runat="server" CssClass="form-control" style="width: auto; font-size: 13px;" accept=".csv" />
            <asp:Button ID="btnImportar" runat="server" Text="Importar CSV" CssClass="btn-add" OnClick="btnImportar_Click" style="padding: 8px 15px; height: auto;" />
        </div>
        <div>
            <asp:Button ID="btnExportar" runat="server" Text="Exportar a CSV" CssClass="btn-add" OnClick="btnExportar_Click" style="padding: 8px 15px; height: auto; background: linear-gradient(135deg, #a8d8ea, #8cc9e0); color: #2a7894;" />
        </div>
    </div>

    <!-- Barra de Búsqueda -->
    <div class="search-container">
        <div class="input-group">
            <span class="input-group-text bg-white border-end-0" style="border-radius: 16px 0 0 16px; border-color: #e8f0e5;">
                <i class="fas fa-search text-muted"></i>
            </span>
            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control border-start-0" placeholder="Buscar por nombre o código..." style="border-radius: 0 16px 16px 0; border-color: #e8f0e5;"></asp:TextBox>
        </div>
        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-light" style="border-radius: 16px; border-color: #e8f0e5; font-weight: 600; color: #7caf6e;" />
    </div>

    <!-- Tabla Inventario -->
    <div class="table-container">
        <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="pro_id" HeaderText="ID" />
                <asp:BoundField DataField="pro_nombre" HeaderText="Producto" />
                <asp:BoundField DataField="pro_cantidad" HeaderText="Stock" />
                <asp:BoundField DataField="pro_precio" HeaderText="Precio" DataFormatString="${0:F2}" />
                <asp:BoundField DataField="prov_nombre" HeaderText="Proveedor" />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='badge-stock stock-high'>
                            <i class='fas fa-check-circle'></i> Activo
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
