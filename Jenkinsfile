pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = credentials('AWS_DEFAULT_REGION')
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        PATH = "/opt/homebrew/bin:$PATH" // Adiciona o caminho do Terraform ao PATH
        IMAGE_TAG = 'latest'
        // As variáveis abaixo serão definidas dinamicamente com base nos outputs do Terraform
        ECR_REGISTRY_URL = ''
        ECS_CLUSTER_NAME = ''
        ECS_SERVICE_NAME = ''
    }

    stages {
        stage("Checkout source") {
            steps {
                git url: 'https://github.com/Luiznonaato/desafio-devops.git', branch: 'main'
            }
        }

        stage("Execução do Terraform") {
            steps {
                script {
                    dir('terraform') {
                        // Inicializa o Terraform
                        sh 'terraform init'
                        // Aplica as configurações do Terraform, criando ou atualizando recursos
                        sh 'terraform apply -auto-approve'
                        // Captura os outputs do Terraform
                        script {
                            // O comando terraform output -raw é utilizado para capturar o valor de cada output
                            def vpcId = sh(script: "terraform output -raw vpc_id", returnStdout: true).trim()
                            def ecsServiceName = sh(script: "terraform output -raw ecs_service_name", returnStdout: true).trim()
                            def ecrRepositoryUrl = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()
                            
                            // Armazena os valores capturados em variáveis de ambiente para uso posterior
                            env.VPC_ID = vpcId
                            env.ECS_SERVICE_NAME = ecsServiceName
                            env.ECR_REPOSITORY_URL = ecrRepositoryUrl
        
                            // Opcional: Exibe os valores capturados no log do Jenkins para verificação
                            echo "Captured VPC ID: ${env.VPC_ID}"
                            echo "Captured ECS Service Name: ${env.ECS_SERVICE_NAME}"
                            echo "Captured ECR Repository URL: ${env.ECR_REPOSITORY_URL}"
                        }
                    }
                }
            }
        }



        stage('Build Docker Image') {
            steps {
                script {
                    // Constrói a imagem Docker e a taggeia para o repositório ECR
                    sh "docker build -t ${ECR_REGISTRY_URL}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Faz login no Amazon ECR
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY_URL}"
                    // Faz push da imagem para o repositório ECR
                    sh "docker push ${ECR_REGISTRY_URL}:${IMAGE_TAG}"
                }
            }
        }

        stage('Update ECS Service') {
            steps {
                script {
                    // Atualiza o serviço ECS para usar a nova imagem Docker
                    sh """
                    aws ecs update-service --cluster ${ECS_CLUSTER_NAME} --service ${ECS_SERVICE_NAME} --force-new-deployment
                    """
                }
            }
        }
    }
}
