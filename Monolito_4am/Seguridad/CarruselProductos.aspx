<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="CarruselProductos.aspx.cs" Inherits="Monolito_4am.Seguridad.CarruselProductos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .badge-carrusel {
            background: linear-gradient(135deg, #d4e8cf, #c8e0c0);
            padding: 6px 16px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            color: #5d8b4a;
        }
        .stats-container {
            background: white;
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            margin-bottom: 20px;
        }
        .chart-wrapper {
            position: relative;
            height: 320px;
            width: 100%;
        }
        .stats-select {
            padding: 8px 12px;
            border: 2px solid #e8f0e5;
            border-radius: 12px;
            font-size: 13px;
            color: #5a6b57;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-store" style="color: #7caf6e;"></i> 
            Carrusel de Productos
            <span class="badge-carrusel"><i class="fas fa-images"></i> Vista Rápida</span>
        </h2>
    </div>

    <div class="stats-container">
        <div style="display:flex; flex-wrap:wrap; justify-content:space-between; align-items:center; gap:12px; margin-bottom:15px;">
            <h5 style="color: #7caf6e; margin:0; font-weight: 600;">
                <i class="fas fa-chart-bar"></i> Estadísticas de productos
            </h5>
            <select id="ddlTipoGraficaCarrusel" class="stats-select">
                <option value="bar">Barras — más stock</option>
                <option value="pie">Torta — por stock</option>
                <option value="line">Líneas — tendencia</option>
            </select>
        </div>
        <div class="chart-wrapper">
            <canvas id="chartProductos"></canvas>
        </div>
        <p id="msgGraficaVacia" style="display:none; text-align:center; color:#9bb592; margin-top:10px;">
            No hay productos para mostrar en la gráfica.
        </p>
    </div>

    <div id="carouselProductos" class="carousel slide mb-4" data-bs-ride="carousel" data-bs-interval="3000" style="background: white; border-radius: 20px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.02);">
        <h5 style="color: #7caf6e; text-align: center; margin-bottom: 15px; font-weight: 600;">Productos Destacados</h5>
        <div class="carousel-inner" id="carouselInner" runat="server"></div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselProductos" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true" style="background-color: #7caf6e; border-radius: 50%; padding: 15px;"></span>
            <span class="visually-hidden">Anterior</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselProductos" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true" style="background-color: #7caf6e; border-radius: 50%; padding: 15px;"></span>
            <span class="visually-hidden">Siguiente</span>
        </button>
    </div>

    <script>
        var datosGraficaCarrusel = <%= DatosGraficaJson %>;
        var graficaCarrusel = null;

        function dibujarGraficaCarrusel() {
            if (typeof Chart === 'undefined') {
                return;
            }
            if (!datosGraficaCarrusel || datosGraficaCarrusel.length === 0) {
                document.getElementById('msgGraficaVacia').style.display = 'block';
                return;
            }

            var tipo = document.getElementById('ddlTipoGraficaCarrusel').value;
            var labels = datosGraficaCarrusel.map(function (d) { return d.Nombre; });
            var valores = datosGraficaCarrusel.map(function (d) { return d.Cantidad; });

            if (graficaCarrusel) {
                graficaCarrusel.destroy();
            }

            var ctx = document.getElementById('chartProductos').getContext('2d');
            graficaCarrusel = new Chart(ctx, {
                type: tipo,
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Stock actual',
                        data: valores,
                        backgroundColor: 'rgba(124, 175, 110, 0.65)',
                        borderColor: 'rgba(93, 139, 74, 1)',
                        borderWidth: 1,
                        borderRadius: 5,
                        tension: 0.3,
                        fill: tipo === 'line'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: tipo === 'pie' } },
                    scales: tipo === 'pie' ? {} : { y: { beginAtZero: true } }
                }
            });
        }

        $(document).ready(function () {
            dibujarGraficaCarrusel();
            $('#ddlTipoGraficaCarrusel').on('change', dibujarGraficaCarrusel);
        });
    </script>
</asp:Content>
