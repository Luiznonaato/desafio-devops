pipeline {
    agent any

    environment {
        TERRAFORM_FILES_PATH = "terraform"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
        PATH = "${env.PATH}:/opt/homebrew/bin"
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Preparar') {
            steps {
                dir("${TERRAFORM_FILES_PATH}") {
                    sh 'echo Preparando o Terraform'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TERRAFORM_FILES_PATH}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TERRAFORM_FILES_PATH}") {
                    sh 'terraform plan'
                }
            }  
        }

        stage('Construir Imagem Docker') {
            steps {
                sh '/Users/luiznonato/.docker/bin/docker build -t minha-aplicacao:${IMAGE_TAG} .'
            }
        }


        stage('Push para ECR') {
            steps {
                // Assuming AWS CLI is correctly invoked now, use the full path for Docker commands as well
                sh '/usr/local/bin/aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | /Users/luiznonato/.docker/bin/docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com'
                sh '/Users/luiznonato/.docker/bin/docker tag minha-aplicacao:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/minha-aplicacao:${IMAGE_TAG}'
                sh '/Users/luiznonato/.docker/bin/docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/minha-aplicacao:${IMAGE_TAG}'
            }
        }


        stage('Atualizar Serviço ECS') {
            steps {
                // Comandos para atualizar o serviço ECS com a nova imagem
                sh 'aws ecs update-service --cluster meu-cluster --service meu-servico --force-new-deployment'
            }
        }
    }
}
