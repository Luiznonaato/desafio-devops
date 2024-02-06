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
                        sh '''
                        terraform plan \
                          -var="AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}" \
                          -var="ami_id=ami-0c02fb55956c7d316" \
                          -var='subnet_ids=["subnet-12345abcde", "subnet-67890fghij"]' \
                          -var="vpc_id=vpc-12345678"
                        '''

                        // Destroy
                        // sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
