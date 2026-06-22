<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="CrudProducto.aspx.cs" Inherits="Monolito_4am.Seguridad.CrudProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .search-container {
            position: relative;
            margin-bottom: 20px;
            width: 100%;
            max-width: 500px;
        }
        .search-input {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 2px solid #e8f0e5;
            border-radius: 20px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #b8d9a8;
            outline: none;
            box-shadow: 0 0 0 4px rgba(184, 217, 168, 0.2);
        }
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #9bb592;
        }
        .search-results {
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            z-index: 1000;
            max-height: 250px;
            overflow-y: auto;
            display: none;
            margin-top: 5px;
        }
        .search-item {
            padding: 10px 15px;
            border-bottom: 1px solid #f4f7f2;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .search-item:hover {
            background: #f8faf7;
        }
        .search-item img {
            width: 30px;
            height: 30px;
            object-fit: cover;
            border-radius: 5px;
        }
        /* Estilos específicos de Gestión de Productos */
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

        .badge-prod {
            background: linear-gradient(135deg, #ffe0d6, #fcd5c7);
            padding: 6px 16px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            color: #d16e4d;
        }

        /* Formulario */
        .form-crear { 
            background: #fefcf7;
            padding: 25px; 
            border-radius: 25px; 
            margin-bottom: 35px; 
            border: 1px solid #e8f0e5;
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
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
            width: 100%;
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
            justify-content: center;
            gap: 8px;
            height: 48px;
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

        .botones-container {
            display: flex;
            gap: 12px;
            grid-column: 1 / -1;
            margin-top: 10px;
        }

        /* Tabla */
        .table-container {
            overflow-x: auto;
            border-radius: 20px;
            background: white;
            padding: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
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
            border-bottom: none;
        }

        .table th:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .table th:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }

        .table td { 
            padding: 16px 15px; 
            border-bottom: 1px solid #f4f7f2;
            vertical-align: middle;
            color: #5a6b57;
        }

        .table tr:hover {
            background: #fafcf9;
        }

        .precio-badge {
            background: #eef5eb;
            color: #5d8b4a;
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 600;
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

        /* Botones de la grilla */
        .acciones {
            display: flex;
            gap: 8px;
        }

        .btn-grid { 
            padding: 8px 12px; 
            border-radius: 10px; 
            border: none; 
            color: white; 
            cursor: pointer; 
            font-size: 12px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            font-weight: 500;
        }

        .btn-edit { 
            background: #fff5e6;
            color: #d99a2b;
        }
        .btn-edit:hover { background: #ffeac2; color: #b87f1e; }

        .btn-delete { 
            background: #ffebe8;
            color: #d15b47;
        }
        .btn-delete:hover { background: #ffd4cd; color: #b34230; }

        @media (max-width: 768px) {
            .botones-container {
                flex-direction: column;
            }
            .btn-accion {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="smCrudProducto" runat="server" EnablePageMethods="true" />
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-boxes" style="color: #7caf6e;"></i> 
            Gestion de Productos
            <span class="badge-prod"><i class="fas fa-box-open"></i> Inventario</span>
        </h2>
        <div class="search-container">
            <i class="fas fa-search search-icon"></i>
            <input type="text" id="txtBuscarProducto" class="search-input" placeholder="Buscar producto estilo Facebook..." autocomplete="off" />
            <div id="searchResults" class="search-results"></div>
        </div>
    </div>

    <div style="margin-bottom: 20px;">
        <asp:LinkButton ID="btnExportarExcel" runat="server" CssClass="btn-accion btn-guardar" OnClick="btnExportarExcel_Click" CausesValidation="false">
            <i class="fas fa-file-excel"></i> Descargar a Excel
        </asp:LinkButton>
    </div>

    <!-- Formulario de Registro/Edición -->
    <div class="form-crear">
        <asp:HiddenField ID="hfProductoID" runat="server" />
        
        <div class="form-group">
            <label><i class="fas fa-tag"></i> Nombre del producto</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej. Laptop HP"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label><i class="fas fa-layer-group"></i> Cantidad</label>
            <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" placeholder="0"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label><i class="fas fa-dollar-sign"></i> Precio</label>
            <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
        </div>

        <div class="form-group">
            <label><i class="fas fa-truck"></i> Proveedor</label>
            <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-control">
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label><i class="fas fa-image"></i> Imagen del Producto (Puedes seleccionar múltiples fotos)</label>
            <div style="display: flex; gap: 10px;">
                <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" AllowMultiple="true" accept="image/png, image/jpeg, image/jpg, image/webp" />
                <button type="button" id="btnPrevisualizar" class="btn-accion" style="background:#e8f0e5; color:#7caf6e;">Previsualizar</button>
            </div>
            <!-- Contenedor donde aparecerán las previsualizaciones -->
            <div id="previewContainer" style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px;"></div>
        </div>

        <div class="botones-container">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" CssClass="btn-accion btn-guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Limpiar" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <!-- Tabla de Productos -->
    <div class="table-container">
        <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="gvProductos_RowCommand" GridLines="None">
            <Columns>
                <asp:BoundField DataField="pro_id" HeaderText="ID" />
                <asp:TemplateField HeaderText="Imagen">
                    <ItemTemplate>
                        <asp:Image ID="imgProductoGrid" runat="server" 
                            ImageUrl='<%# ObtenerUrlImagenProducto(Eval("pro_id")) %>' 
                            style="width:40px; height:40px; object-fit:cover; border-radius:5px;" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="pro_nombre" HeaderText="Producto" />
                <asp:BoundField DataField="pro_cantidad" HeaderText="Stock" />
                
                <asp:TemplateField HeaderText="Precio">
                    <ItemTemplate>
                        <span class="precio-badge">$ <%# Eval("pro_precio", "{0:F2}") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="prov_nombre" HeaderText="Proveedor" />
                
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class="estado-activo">
                            <i class="fas fa-check-circle"></i> Activo
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <div class="acciones">
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Editar" CommandArgument='<%# Eval("pro_id") %>' CssClass="btn-grid btn-edit" ToolTip="Editar producto">
                                <i class="fas fa-pen"></i> Editar
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnLogico" runat="server" CommandName="EliminarLogico" CommandArgument='<%# Eval("pro_id") %>' CssClass="btn-grid" style="background:#fcd5c7; color:#d16e4d;" OnClientClick="return confirm('¿Realizar borrado lógico de este producto?');" ToolTip="Borrado Lógico">
                                <i class="fas fa-eye-slash"></i> B. Lógico
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="EliminarFisico" CommandArgument='<%# Eval("pro_id") %>' CssClass="btn-grid btn-delete" OnClientClick="return confirm('¿ADVERTENCIA: Realizar borrado físico de este producto?');" ToolTip="Borrado Físico">
                                <i class="fas fa-trash"></i> B. Físico
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div style="text-align: center; padding: 30px; color: #a0b898;">
                    <i class="fas fa-box-open" style="font-size: 30px; margin-bottom: 10px; display: block;"></i>
                    No hay productos registrados.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
    
    <script>
        var fileUploadId = '<%= fuImagen.ClientID %>';

        $(document).ready(function () {
            $('#btnPrevisualizar').on('click', function () {
                previsualizarImagenesBtn();
            });

            // Buscador en tiempo real estilo Facebook
            let searchTimeout;
            $('#txtBuscarProducto').on('input', function () {
                clearTimeout(searchTimeout);
                let query = $(this).val().trim();
                let resultsContainer = $('#searchResults');
                
                if (query.length < 2) {
                    resultsContainer.hide();
                    return;
                }
                
                searchTimeout = setTimeout(function () {
                    $.ajax({
                        type: "POST",
                        url: "CrudProducto.aspx/BuscarProductos",
                        data: JSON.stringify({ termino: query }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            let productos = response.d;
                            resultsContainer.empty();
                            if (productos.length > 0) {
                                productos.forEach(p => {
                                    let img = p.Imagen && p.Imagen !== "" ? p.Imagen : '<%= ResolveUrl("~/Seguridad/VerProductoImagen.ashx?id=0") %>';
                                    let item = `<div class="search-item" onclick="seleccionarProducto(${p.Id})">
                                                    <img src="${img}" alt="${p.Nombre}" onerror="this.onerror=null;this.src='<%= ResolveUrl("~/Seguridad/VerProductoImagen.ashx?id=0") %>';" />
                                                    <div>
                                                        <div style="font-weight:600; color:#5a6b57;">${p.Nombre}</div>
                                                        <div style="font-size:11px; color:#9bb592;">Stock: ${p.Cantidad} | $${p.Precio}</div>
                                                    </div>
                                                </div>`;
                                    resultsContainer.append(item);
                                });
                                resultsContainer.show();
                            } else {
                                resultsContainer.append('<div style="padding:10px 15px; color:#9bb592;">No se encontraron resultados</div>');
                                resultsContainer.show();
                            }
                        }
                    });
                }, 300);
            });

            $(document).on('click', function (e) {
                if (!$(e.target).closest('.search-container').length) {
                    $('#searchResults').hide();
                }
            });
        });

        function previsualizarImagenesBtn() {
            var input = document.getElementById(fileUploadId);
            var container = document.getElementById('previewContainer');
            if (!container) return;
            container.innerHTML = '';

            if (!input || !input.files || input.files.length === 0) {
                alert('Por favor selecciona imágenes primero.');
                return;
            }

            for (var i = 0; i < input.files.length; i++) {
                var file = input.files[i];
                if (!file.type || file.type.indexOf('image') !== 0) {
                    alert('Solo se permiten subir imágenes (jpg, png, etc).');
                    input.value = '';
                    container.innerHTML = '';
                    return;
                }

                (function (archivo) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var img = document.createElement('img');
                        img.src = e.target.result;
                        img.style.width = '60px';
                        img.style.height = '60px';
                        img.style.objectFit = 'cover';
                        img.style.borderRadius = '5px';
                        img.style.border = '1px solid #ccc';
                        container.appendChild(img);
                    };
                    reader.readAsDataURL(archivo);
                })(file);
            }
        }

        function mostrarImagenExistente(url) {
            var container = document.getElementById('previewContainer');
            if (!container || !url) return;
            container.innerHTML = '';
            var img = document.createElement('img');
            img.src = url;
            img.alt = 'Imagen actual del producto';
            img.style.width = '60px';
            img.style.height = '60px';
            img.style.objectFit = 'cover';
            img.style.borderRadius = '5px';
            img.style.border = '1px solid #ccc';
            container.appendChild(img);
        }

        function seleccionarProducto(id) {
            $('#searchResults').hide();
            window.location.href = 'CrudProducto.aspx?id=' + id;
        }
    </script>
</asp:Content>
