pipeline {
    agent any

    environment {
        // A definição das credenciais AWS será feita no bloco 'withCredentials'
        PATH = "/opt/homebrew/bin:$PATH" // Adiciona o caminho do Terraform ao PATH
        IMAGE_TAG = 'latest'
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
                    withCredentials([
                        [$class: 'StringBinding', credentialsId: 'AWS_DEFAULT_REGION', variable: 'AWS_DEFAULT_REGION'],
                        [$class: 'StringBinding', credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'],
                        [$class: 'StringBinding', credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        dir('terraform') {
                            // Inicializa o Terraform
                            sh 'terraform init'
                            // Aplica as configurações do Terraform, criando ou atualizando recursos
                            sh 'terraform apply -auto-approve -var="vpc_id=${VPC_ID}" -var="subnet_id=${SUBNET_ID}"'
                            // Captura os outputs do Terraform e armazena em variáveis de ambiente
                            env.VPC_ID = sh(script: "terraform output -raw vpc_id", returnStdout: true).trim()
                            env.SUBNET_ID = sh(script: "terraform output -raw subnet_id", returnStdout: true).trim()
                            env.AMI_ID = sh(script: "terraform output -raw ami_id", returnStdout: true).trim()
                            env.ECS_SERVICE_NAME = sh(script: "terraform output -raw ecs_service_name", returnStdout: true).trim()
                            env.ECR_REGISTRY_URL = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()

                            // Opcional: Exibe os valores capturados no log do Jenkins para verificação
                            echo "Captured VPC ID: ${env.VPC_ID}"
                            echo "Captured SUBNET ID: ${env.SUBNET_ID}"
                            echo "Captured AMI ID: ${env.AMI_ID}"
                            echo "Captured ECS Service Name: ${env.ECS_SERVICE_NAME}"
                            echo "Captured ECR Repository URL: ${env.ECR_REGISTRY_URL}"
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Constrói a imagem Docker e a taggeia para o repositório ECR
                    sh "docker build -t ${env.ECR_REGISTRY_URL}:${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Faz login no Amazon ECR
                    withCredentials([
                        [$class: 'StringBinding', credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'],
                        [$class: 'StringBinding', credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        sh "aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${env.ECR_REGISTRY_URL}"
                        // Faz push da imagem para o repositório ECR
                        sh "docker push ${env.ECR_REGISTRY_URL}:${env.IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Update ECS Service') {
            steps {
                script {
                    // Atualiza o serviço ECS para usar a nova imagem Docker
                    sh """
                    aws ecs update-service --cluster ${env.ECS_CLUSTER_NAME} --service ${env.ECS_SERVICE_NAME} --force-new-deployment
                    """
                }
            }
        }
    }
}
