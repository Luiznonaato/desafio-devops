pipeline {
    agent any

    stages {

        stage ("Checkout source") {
            steps {
                git url: 'https://github.com/Luiznonaato/desafio-devops.git', branch: 'main'
            }   
        }

        stage ("Execução do terraform") {
            environment {
                // Define as variáveis de ambiente para a autenticação da AWS
                AWS_DEFAULT_REGION = credentials('AWS_DEFAULT_REGION')
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                PATH = "/opt/homebrew/bin:$PATH" // Adiciona o caminho do Terraform ao PATH
            }
            steps {
                script {
                    // Muda para o diretório 'terraform' antes de executar os comandos
                    dir('terraform') {
                        // Inicialização do Terraform
                        sh 'terraform init'
                        // Aplica o Terraform com aprovação automática
                        sh 'terraform apply -auto-approve'
                        //Destroy
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
