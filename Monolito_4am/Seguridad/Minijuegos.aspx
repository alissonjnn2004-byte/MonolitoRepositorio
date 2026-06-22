<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeFile="Minijuegos.aspx.cs" Inherits="Monolito4am.Seguridad.Minijuegos" %>

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

        .btn-mini {
            background: linear-gradient(135deg, #a8d8ea, #8cc9e0);
            color: #2a7894;
            border: none; padding: 15px 25px; border-radius: 12px;
            cursor: pointer; font-weight: 600; font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(168, 216, 234, 0.3);
            margin: 10px;
        }
        .btn-mini:hover { transform: translateY(-2px); filter: brightness(1.05); }

        .btn-rombo {
            background: linear-gradient(135deg, #ffb3ba, #ffdfba);
            color: #c44;
            box-shadow: 0 3px 10px rgba(255, 179, 186, 0.3);
        }

        /* Modales */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(5px);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content-custom {
            background: white;
            padding: 30px;
            border-radius: 20px;
            width: 80%;
            max-width: 600px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.3);
            position: relative;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .close-modal {
            position: absolute;
            top: 15px; right: 20px;
            font-size: 24px;
            color: #999;
            cursor: pointer;
            transition: color 0.3s;
        }
        .close-modal:hover { color: #333; }

        /* Juego Vasos */
        #game-board {
            position: relative;
            width: 100%;
            height: 250px;
            margin-top: 20px;
            background: #d4a373;
            border-radius: 10px;
            border-bottom: 20px solid #bc8a5f;
            display: flex;
            justify-content: center;
            align-items: flex-end;
            padding-bottom: 20px;
        }
        .cup-container {
            position: absolute; bottom: 20px; width: 80px; height: 100px;
            transition: transform 0.4s ease-in-out, left 0.4s ease-in-out;
            cursor: pointer; display: flex; justify-content: center;
        }
        .cup {
            width: 60px; height: 90px;
            background: linear-gradient(to right, #cc0000, #ff0000, #cc0000);
            border-radius: 5px 5px 15px 15px;
            position: relative; z-index: 2;
            transition: transform 0.5s;
            box-shadow: -2px 5px 10px rgba(0,0,0,0.3);
        }
        .cup::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 8px;
            background: #fff; border-radius: 5px 5px 0 0;
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.2);
        }
        .cup.lifted { transform: translateY(-80px); }
        .ball {
            position: absolute; bottom: 0; width: 30px; height: 30px;
            background: radial-gradient(circle at 10px 10px, #fff, #ccc);
            border-radius: 50%; z-index: 1;
            box-shadow: inset -2px -2px 5px rgba(0,0,0,0.2), 2px 2px 5px rgba(0,0,0,0.3);
            display: none;
        }
        #level-info { font-size: 18px; font-weight: bold; color: #7a609b; margin-bottom: 10px; }

        /* Rombo */
        pre#rombo-container {
            font-family: monospace; font-size: 16px; line-height: 1.2;
            text-align: center; background: #f8f9fa; padding: 20px;
            border-radius: 10px; overflow-x: auto; color: #333; font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2 class="page-title">
            <i class="fas fa-gamepad" style="color: #7caf6e;"></i> 
            Minijuegos
        </h2>
    </div>

    <div style="text-align: center; padding: 40px;">
        <button type="button" class="btn-mini" onclick="openGameModal()">🎲 Jugar Vasos</button>
        <button type="button" class="btn-mini btn-rombo" onclick="openRomboModal()">♦ Ver Rombo</button>
    </div>

    <!-- Modal Rombo -->
    <div id="modalRombo" class="modal-overlay">
        <div class="modal-content-custom">
            <span class="close-modal" onclick="closeModals()">&times;</span>
            <h3 style="color:#7a609b; margin-bottom:15px;">Rombo Especial</h3>
            <div style="margin-bottom: 15px;">
                <label for="rombo-size" style="font-weight:bold; color:#2a7894;">Tamaño del rombo (radio):</label>
                <input type="number" id="rombo-size" min="1" value="9" onkeydown="if(event.key === 'Enter'){event.preventDefault(); generateAndDrawRombo(); return false;}" style="padding: 5px; border-radius: 5px; border: 1px solid #ccc; width: 60px; margin-left: 10px;">
                <button type="button" class="btn-mini" onclick="generateAndDrawRombo()" style="padding: 5px 15px; margin-left: 10px; font-size: 14px;">Generar</button>
            </div>
            <pre id="rombo-container"></pre>
        </div>
    </div>

    <!-- Modal Juego Vasos -->
    <div id="modalVasos" class="modal-overlay">
        <div class="modal-content-custom" style="max-width: 800px;">
            <span class="close-modal" onclick="closeModals()">&times;</span>
            <h3 style="color:#7a609b; margin-bottom:5px;">Juego de los Vasos</h3>
            <div id="level-info">Nivel: 1 | Vasos: 3</div>
            <button type="button" class="btn-mini" id="btn-start-game" onclick="startGame()" style="width:200px; margin-bottom:10px;">Comenzar</button>
            
            <div id="game-board">
                <!-- Vasos generados dinámicamente -->
            </div>
        </div>
    </div>

    <script>
        function openRomboModal() {
            document.getElementById('modalRombo').style.display = 'flex';
            if (!document.getElementById('rombo-size').value) {
                document.getElementById('rombo-size').value = 9;
            }
            generateAndDrawRombo();
        }

        function openGameModal() {
            document.getElementById('modalVasos').style.display = 'flex';
            if(level === 1) resetGame();
            else updateGameUI();
        }

        function closeModals() {
            document.getElementById('modalRombo').style.display = 'none';
            document.getElementById('modalVasos').style.display = 'none';
        }

        function generateAndDrawRombo() {
            const input = document.getElementById('rombo-size').value;
            const r = parseInt(input);

            if (isNaN(r) || r < 1) {
                Swal.fire('Error', 'Por favor, ingrese un tamaño válido (número positivo mayor a 0).', 'warning');
                return;
            }
            
            if (r > 50) {
                Swal.fire('Error', 'El tamaño máximo permitido es 50 para evitar problemas de rendimiento.', 'warning');
                return;
            }

            let width = 2 * r + 1;
            let height = 2 * r + 1;
            let grid = new Array(height);
            for(let i=0; i<height; i++) {
                grid[i] = new Array(width).fill(' ');
            }
            //comienza hacerse el rombo izquierdo 
            //Definen dónde empieza el dibujo.
            let x = -r;
            let y = 0;
            
            let dx = [1, 1, -1, -1];
            let dy = [1, -1, -1, 1];
            
            let dir = 0;
            let stepLen = r;
            
            for(let i=0; i<stepLen; i++) {
                grid[y + r][x + r] = '*';
                //Define que la primera dirección a la que va
                x += dx[dir];
                y += dy[dir];
            }
            dir = (dir + 1) % 4;
            
            while(stepLen > 0) {
                for(let i=0; i<stepLen; i++) {
                    grid[y + r][x + r] = '*';
                    x += dx[dir];
                    y += dy[dir];
                }
                dir = (dir + 1) % 4;
                
                for(let i=0; i<stepLen; i++) {
                    grid[y + r][x + r] = '*';
                    x += dx[dir];
                    y += dy[dir];
                }
                dir = (dir + 1) % 4;
                
                stepLen -= 2;
            }
            grid[y + r][x + r] = '*';

            //La longitud del borde será igual al ancho del rombo
            let borderLength = width;
            let topBorder = '╔' + '═'.repeat(borderLength) + '╗';
            let bottomBorder = '╚' + '═'.repeat(borderLength) + '╝';
            
            let result = topBorder + '\n';
            for(let i=0; i<height; i++) {
                result += '║' + grid[i].join('') + '║\n';
            }
            result += bottomBorder;
            
            document.getElementById('rombo-container').innerText = result;
        }

        let level = 1;
        let numCups = 3;
        let ballPosition = 0;
        let isAnimating = false;

        function resetGame() {
            level = 1; numCups = 3; updateGameUI();
        }

        function updateGameUI() {
            const board = document.getElementById('game-board');
            const cupWidth = 80;
            const totalWidth = numCups * cupWidth;
            const modalContent = document.querySelector('#modalVasos .modal-content-custom');
            
            if (totalWidth + 100 > modalContent.offsetWidth) {
                modalContent.style.width = (totalWidth + 100) + 'px';
                modalContent.style.maxWidth = '95%';
            }

            setTimeout(() => {
                document.getElementById('level-info').innerText = "Nivel: " + level + " | Vasos: " + numCups;
                document.getElementById('btn-start-game').disabled = false;
                
                board.innerHTML = '<div class="ball" id="ball"></div>';
                const startX = (board.offsetWidth - totalWidth) / 2;

                for (let i = 0; i < numCups; i++) {
                    const cupCont = document.createElement('div');
                    cupCont.className = 'cup-container';
                    cupCont.setAttribute('data-pos', i);
                    cupCont.style.left = (startX + (i * cupWidth)) + 'px';
                    cupCont.onclick = () => selectCup(i);
                    
                    const cup = document.createElement('div');
                    cup.className = 'cup';
                    cupCont.appendChild(cup);
                    
                    board.appendChild(cupCont);
                }
                isAnimating = false;
            }, 50);
        }

        function startGame() {
            if (isAnimating) return;
            isAnimating = true;
            document.getElementById('btn-start-game').disabled = true;

            ballPosition = Math.floor(Math.random() * numCups);
            
            const ball = document.getElementById('ball');
            const cups = document.querySelectorAll('.cup');
            const cupElements = document.querySelectorAll('.cup-container');
            
            const cupWidth = 80;
            const totalWidth = numCups * cupWidth;
            const startX = (document.getElementById('game-board').offsetWidth - totalWidth) / 2;
            
            let pos = parseInt(cupElements[ballPosition].getAttribute('data-pos'));
            ball.style.display = 'block';
            ball.style.left = (startX + (pos * cupWidth) + 25) + 'px';

            cups[ballPosition].classList.add('lifted');
            
            setTimeout(() => {
                cups[ballPosition].classList.remove('lifted');
                setTimeout(() => {
                    ball.style.display = 'none';
                    shuffleCups(0, 5 + level * 2);
                }, 600);
            }, 1500);
        }

        function shuffleCups(currentShuffle, maxShuffles) {
            if (currentShuffle >= maxShuffles) {
                isAnimating = false;
                document.getElementById('level-info').innerText = "Nivel: " + level + " | ¡Adivina dónde está la pelotita!";
                return;
            }

            const cupElements = document.querySelectorAll('.cup-container');
            
            let idx1 = Math.floor(Math.random() * numCups);
            let idx2 = Math.floor(Math.random() * numCups);
            while (idx1 === idx2) idx2 = Math.floor(Math.random() * numCups);

            const cupWidth = 80;
            const totalWidth = numCups * cupWidth;
            const startX = (document.getElementById('game-board').offsetWidth - totalWidth) / 2;

            let pos1 = parseInt(cupElements[idx1].getAttribute('data-pos'));
            let pos2 = parseInt(cupElements[idx2].getAttribute('data-pos'));

            cupElements[idx1].style.left = (startX + (pos2 * cupWidth)) + 'px';
            cupElements[idx2].style.left = (startX + (pos1 * cupWidth)) + 'px';

            cupElements[idx1].setAttribute('data-pos', pos2);
            cupElements[idx2].setAttribute('data-pos', pos1);

            setTimeout(() => {
                shuffleCups(currentShuffle + 1, maxShuffles);
            }, Math.max(150, 450 - (level * 30)));
        }

        function selectCup(idx) {
            if (isAnimating || !document.getElementById('btn-start-game').disabled) return;
            
            const cups = document.querySelectorAll('.cup');
            const ball = document.getElementById('ball');
            const cupElements = document.querySelectorAll('.cup-container');
            
            const cupWidth = 80;
            const totalWidth = numCups * cupWidth;
            const startX = (document.getElementById('game-board').offsetWidth - totalWidth) / 2;
            
            let posWinner = parseInt(cupElements[ballPosition].getAttribute('data-pos'));
            ball.style.left = (startX + (posWinner * cupWidth) + 25) + 'px';
            ball.style.display = 'block';

            cups[idx].classList.add('lifted');

            setTimeout(() => {
                if (idx === ballPosition) {
                    Swal.fire('¡Correcto!', '¡Avanzas al siguiente nivel!', 'success').then(() => {
                        level++; numCups++; updateGameUI();
                    });
                } else {
                    cups[ballPosition].classList.add('lifted');
                    Swal.fire('¡Fallaste!', 'La pelotita estaba en otro vaso. Fin del juego.', 'error').then(() => {
                        resetGame();
                    });
                }
            }, 800);
        }

        window.addEventListener('resize', () => {
            if (document.getElementById('modalVasos').style.display === 'flex' && !isAnimating) {
                updateGameUI();
            }
        });
    </script>
</asp:Content>
