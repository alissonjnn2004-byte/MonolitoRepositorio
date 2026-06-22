pipeline {
    agent { 
        label 'windows' // Requiere que el nodo de Windows tenga esta etiqueta
    }

    environment {
        // Rutas a las herramientas necesarias en el agente Windows
        MSBUILD = "C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" // Ajusta según tu versión
        NUGET = "C:\\Herramientas\\nuget.exe" // Ajusta la ruta a donde tengas nuget.exe
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
                // Aquí deberás ajustar el comando si tienes un proyecto de pruebas (MSTest o NUnit)
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
                    // Copiar los archivos publicados a la carpeta de IIS
                    // Se requiere que el agente de Jenkins se ejecute como Administrador para escribir en inetpub
                    bat """
                        xcopy "${env.WORKSPACE}\\publish\\*" "${PUBLISH_DIR}\\" /S /Y /I
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
