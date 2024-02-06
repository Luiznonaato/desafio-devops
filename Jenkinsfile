pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        PATH = "/opt/homebrew/bin:/usr/local/bin:$PATH" // Adiciona o caminho do Terraform e AWS CLI ao PATH
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
                        [$class: 'StringBinding', credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'],
                        [$class: 'StringBinding', credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        dir('terraform') {
                            sh 'terraform init'
                            sh "terraform plan"

                            // Aplica as configurações do Terraform se necessário
                            // sh "terraform apply -auto-approve"

                            // Captura os outputs do Terraform
                            env.VPC_ID = sh(script: "terraform output -raw vpc_id", returnStdout: true).trim()
                            env.SUBNET_ID = sh(script: "terraform output -raw subnet_id", returnStdout: true).trim()
                            env.ECS_SERVICE_NAME = sh(script: "terraform output -raw ecs_service_name", returnStdout: true).trim()
                            env.ECR_REGISTRY_URL = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()

                            // Exibe os valores capturados no log para verificação
                            echo "Captured VPC ID: ${env.VPC_ID}"
                            echo "Captured SUBNET ID: ${env.SUBNET_ID}"
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
                    sh "/Users/luiznonato/.docker/bin/docker build -t ${env.ECR_REGISTRY_URL}:${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    withCredentials([
                        [$class: 'StringBinding', credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'],
                        [$class: 'StringBinding', credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        sh "/usr/local/bin/aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | /Users/luiznonato/.docker/bin/docker login --username AWS --password-stdin ${env.ECR_REGISTRY_URL}"
                        sh "/Users/luiznonato/.docker/bin/docker push ${env.ECR_REGISTRY_URL}:${env.IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Update ECS Service') {
            steps {
                script {
                    sh "/usr/local/bin/aws ecs update-service --region ${env.AWS_DEFAULT_REGION} --cluster ${env.ECS_CLUSTER_NAME} --service ${env.ECS_SERVICE_NAME} --force-new-deployment"
                }
            }
        }
    }
}
