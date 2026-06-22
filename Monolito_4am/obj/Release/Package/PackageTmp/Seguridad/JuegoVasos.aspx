<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JuegoVasos.aspx.cs" Inherits="Monolito_4am.Seguridad.JuegoVasos" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Juego de los Vasos - Nivel Pro</title>

    <style>
        :root{
            --color-vaso:#d63031;
            --color-bolita:#ffffff;
        }

        body{
            background-color:#1e272e;
            font-family:'Segoe UI';
            color:white;
            display:flex;
            flex-direction:column;
            align-items:center;
            margin:0;
        }

        .header{
            text-align:center;
            margin-top:20px;
        }

        .stats-container{
            display:flex;
            gap:15px;
            margin-top:15px;
        }

        .stat-box{
            background:#2f3640;
            padding:10px 20px;
            border-radius:12px;
            border:1px solid #7f8c8d;
            min-width:80px;
            text-align:center;
        }

        .stat-label{
            display:block;
            font-size:0.7rem;
            color:#95a5a6;
            text-transform:uppercase;
        }

        .stat-value{
            font-size:1.4rem;
            font-weight:bold;
            color:#f5f6fa;
        }

        .mesa-area{
            width:100%;
            display:flex;
            justify-content:center;
            margin-top:40px;
        }

        .mesa{
            position:relative;
            width:900px;
            height:320px;
            background:#4b3621;
            border-bottom:20px solid #2c1e12;
            border-radius:0 0 40px 40px;
            box-shadow:0 20px 50px rgba(0,0,0,0.5);
            overflow:hidden;
            display:flex;
            justify-content:center;
            align-items:flex-end;
        }

        .vaso-wrapper{
            position:absolute;
            width:110px;
            height:160px;
            transition:all 0.4s cubic-bezier(0.4,0,0.2,1);
            display:flex;
            justify-content:center;
            align-items:flex-end;
            bottom:20px;
        }

        .vaso{
            width:100px;
            height:140px;
            background-color:var(--color-vaso);
            clip-path:polygon(15% 0%,85% 0%,100% 100%,0% 100%);
            z-index:2;
            cursor:pointer;
            border-bottom:6px solid #b33939;
        }

        .revelar .vaso{
            transform:translateY(-130px);
        }

        .bolita{
            width:38px;
            height:38px;
            background-color:var(--color-bolita);
            border-radius:50%;
            position:absolute;
            bottom:5px;
            z-index:1;
            box-shadow:0 4px 8px rgba(0,0,0,0.4);
        }

        .btn-play{
            background-color:#27ae60;
            color:white;
            border:none;
            padding:15px 45px;
            border-radius:30px;
            font-size:1.2rem;
            font-weight:bold;
            cursor:pointer;
            box-shadow:0 5px 0 #1e8449;
            transition:0.2s;
            margin-top:30px;
        }

        .btn-play:active{
            transform:translateY(3px);
            box-shadow:0 2px 0 #1e8449;
        }

        .mensaje{
            display:block;
            margin-top:20px;
            font-size:1.1rem;
            color:#f1c40f;
            font-weight:bold;
            min-height:1.5em;
        }

        #copaGanador{
            display:none;
            margin-top:20px;
            animation:aparecer 1s ease;
        }

        @keyframes aparecer{
            from{
                transform:scale(0);
                opacity:0;
            }
            to{
                transform:scale(1);
                opacity:1;
            }
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <asp:ScriptManager ID="sm1" runat="server" />

    <div class="header">

        <h1>Encuentra la Bolita</h1>
        <h2 style="color:#f1c40f; margin-top:-10px;">
        <asp:Label ID="lblBienvenida" runat="server"></asp:Label>
        </h2>


        <div class="stats-container">

            <div class="stat-box">
                <span class="stat-label">Nivel</span>
                <asp:Label ID="lblNivel" runat="server" CssClass="stat-value" />
            </div>

            <div class="stat-box">
                <span class="stat-label">Vasos</span>
                <asp:Label ID="lblCantVasos" runat="server" CssClass="stat-value" />
            </div>

            <div class="stat-box">
                <span class="stat-label">Tiempo</span>
                <asp:Label ID="lblTiempo" runat="server" CssClass="stat-value">
                    00:00
                </asp:Label>
            </div>

        </div>
    </div>

    <div class="mesa-area">
        <div class="mesa" id="mesaJuego">

            <asp:PlaceHolder ID="phVasos" runat="server"></asp:PlaceHolder>

        </div>
    </div>

    <div style="text-align:center;">

        <asp:Label ID="lblMensaje"
            runat="server"
            CssClass="mensaje">
        </asp:Label>

        <div id="copaGanador">
            <h1 style="font-size:80px;">🏆</h1>
            <h2 style="color:gold;">¡ERES EL CAMPEÓN!</h2>
        </div>

        <asp:Button
            ID="btnMezclar"
            runat="server"
            Text="¡JUGAR!"
            OnClientClick="animarMezcla(); return false;"
            CssClass="btn-play" />
        <asp:Button
    ID="btnCerrarSesion"
    runat="server"
    Text="Cerrar Sesión"
    OnClick="btnCerrarSesion_Click"
    CssClass="btn-play"
    style="background-color:#e74c3c; box-shadow:0 5px 0 #c0392b; margin-left:10px;" />

        <asp:Button
            ID="btnTerminarMezcla"
            runat="server"
            OnClick="btnIniciar_Click"
            style="display:none;" />

        <asp:Timer
            ID="timerJuego"
            runat="server"
            Interval="1000"
            OnTick="timerJuego_Tick"
            Enabled="false">
        </asp:Timer>

    </div>

    <audio id="sndWin">
        <source src="https://www.myinstants.com/media/sounds/correct.mp3" type="audio/mpeg">
    </audio>

    <audio id="sndLose">
        <source src="https://www.myinstants.com/media/sounds/wronganswer.mp3" type="audio/mpeg">
    </audio>

    <audio id="sndShuffle">
        <source src="https://www.myinstants.com/media/sounds/magic-swish.mp3" type="audio/mpeg">
    </audio>

</form>

<script>

    function animarMezcla() {

        const vasos = document.querySelectorAll('.vaso-wrapper');
        const mesa = document.getElementById('mesaJuego');

        const total = vasos.length;

        const step = mesa.offsetWidth / (total + 1);

        document.getElementById('sndShuffle').play();

        vasos.forEach(v => v.classList.remove('revelar'));

        let count = 0;

        const maxSwaps = 8 + (total * 2);

        const interval = setInterval(() => {

            let indices = Array.from(Array(total).keys())
                .sort(() => Math.random() - 0.5);

            vasos.forEach((v, i) => {

                v.style.left =
                    (step * (indices[i] + 1)
                        - (v.offsetWidth / 2)) + "px";

            });

            count++;

            if (count > maxSwaps) {

                clearInterval(interval);

                setTimeout(() => {

                    document.getElementById('<%= btnTerminarMezcla.ClientID %>').click();

                }, 500);
            }

        }, 300);
    }

    function mostrarCopa() {

        const copa =
            document.getElementById("copaGanador");

        copa.style.display = "block";
    }

</script>

</body>
</html>
