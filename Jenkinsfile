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


                        /* Aplica as configurações do Terraform, criando ou atualizando recursos
                        ssh "terraform plan -var 'vpc_id=${env.VPC_ID}' -var 'subnet_id_a=${env.SUBNET_ID_A}' -var 'ami_id=${env.AMI_ID}'"


                        // Captura os outputs do Terraform e armazena em variáveis de ambiente no Jenkins
                        env.VPC_ID = sh(script: "terraform output -raw vpc_id", returnStdout: true).trim()
                        env.SUBNET_ID_A = sh(script: "terraform output -raw subnet_id_a", returnStdout: true).trim()
                        env.AMI_ID = sh(script: "terraform output -raw ami_id", returnStdout: true).trim()
                        env.ECS_SERVICE_NAME = sh(script: "terraform output -raw ecs_service_name", returnStdout: true).trim()
                        env.ECR_REGISTRY_URL = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()

                        // Opcional: Exibe os valores capturados no log do Jenkins para verificação
                        echo "Captured VPC ID: ${env.VPC_ID}"
                        echo "Captured SUBNET ID A: ${env.SUBNET_ID_A}"
                        echo "Captured AMI ID: ${env.AMI_ID}"
                        echo "Captured ECS Service Name: ${env.ECS_SERVICE_NAME}"
                        echo "Captured ECR Repository URL: ${env.ECR_REGISTRY_URL}"
                        */


                        // Aplica as configurações do Terraform, criando ou atualizando recursos
                        // Assegure-se de que terraform apply é apropriado para o seu fluxo de CI/CD
                        sh 'terraform apply -auto-approve'

                        // Captura os outputs do Terraform e armazena em variáveis de ambiente no Jenkins
                        def vpcId = sh(script: "terraform output -raw vpc_id", returnStdout: true).trim()
                        def subnetIdA = sh(script: "terraform output -raw subnet_id_a", returnStdout: true).trim()
                        def amiId = sh(script: "terraform output -raw ami_id", returnStdout: true).trim()
                        def ecsServiceName = sh(script: "terraform output -raw ecs_service_name", returnStdout: true).trim()
                        def ecrRepositoryUrl = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()

                        // Define as variáveis de ambiente para uso posterior no pipeline
                        env.VPC_ID = vpcId
                        env.SUBNET_ID_A = subnetIdA
                        env.AMI_ID = amiId
                        env.ECS_SERVICE_NAME = ecsServiceName
                        env.ECR_REGISTRY_URL = ecrRepositoryUrl

                        // Mostra os valores capturados para verificação
                        echo "Captured VPC ID: ${env.VPC_ID}"
                        echo "Captured SUBNET ID A: ${env.SUBNET_ID_A}"
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

