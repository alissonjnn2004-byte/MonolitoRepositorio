pipeline {
    agent { 
        label 'windows' // Requiere que el nodo de Windows tenga esta etiqueta
    }

    environment {
        // Cambiamos "2022" por "18" que es la ruta real de tu máquina
        MSBUILD = "C:\\Program Files\\Microsoft Visual Studio\\18\\Community\\MSBuild\\Current\\Bin\\MSBuild.exe"
        NUGET = "C:\\Herramientas\\nuget.exe"
        IIS_SITE_NAME = "Default Web Site/Monolito"
        PUBLISH_DIR = "C:\\inetpub\\wwwroot\\Monolito"
    }
    stages {
        stage('Restaurar paquetes NuGet') {
            steps {
                script {
                    bat "\"${NUGET}\" restore Monolito_4am.sln"
                }
            }
        }

        stage('Compilar solución') {
            steps {
                script {
                    bat "\"${MSBUILD}\" Monolito_4am.sln /p:Configuration=Release /p:Platform=\"Any CPU\""
                }
            }
        }

        stage('Ejecutar pruebas') {
            steps {
                echo 'Ejecutando pruebas... (Agrega el comando vstest.console.exe si corresponde)'
            }
        }

        stage('Publicar aplicación') {
            steps {
                script {
                    // Publicamos en una carpeta temporal dentro del workspace
                    bat "\"${MSBUILD}\" Monolito_4am\\Monolito_4am.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:PublishProfile=FolderProfile /p:publishUrl=\"${env.WORKSPACE}\\publish\""
                }
            }
        }

        stage('Desplegar en IIS') {
            steps {
                script {
                    // 1. Asegurar que la carpeta de destino exista en inetpub usando PowerShell
                    powershell """
                        if (-not (Test-Path "${PUBLISH_DIR}")) {
                            New-Item -ItemType Directory -Force -Path "${PUBLISH_DIR}"
                            Write-Output "Carpeta creada exitosamente en inetpub."
                        }
                    """

                    // 2. Copiar los archivos publicados utilizando rutas de Windows totalmente normalizadas
                    bat """
                        xcopy "${env.WORKSPACE}\\publish\\*" "${PUBLISH_DIR}\\" /S /Y /I /E
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline finalizado."
        }
        success {
            echo "Despliegue exitoso."
        }
        failure {
            echo "Hubo un error en el despliegue."
        }
    }
}
