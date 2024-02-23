pipeline {
    agent any

    environment {
        TERRAFORM_FILES_PATH = "terraform"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '339713028644'
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

        stage('Terraform Apply') {
            steps {
                dir("${TERRAFORM_FILES_PATH}") {
                    sh 'terraform apply -auto-approve'
                }
            }  
        }

        stage('Terraform Destroy') {
            steps {
                dir("${TERRAFORM_FILES_PATH}") {
                    sh 'terraform destroy -auto-approve'
                }
            }  
        }

        stage('Construir Imagem Docker') {
            steps {
                sh '/Users/luiznonato/.docker/bin/docker build -t desafio:${IMAGE_TAG} .'
            }
        }

        stage('Verify Environment Variables') {
            steps {
                script {
                    echo "AWS Account ID: ${env.AWS_ACCOUNT_ID}"
                    echo "AWS Default Region: ${env.AWS_DEFAULT_REGION}"
                }
            }
        }

       stage('Push para ECR') {
            steps {
            retry(3) {
                sh "/usr/local/bin/aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | /Users/luiznonato/.docker/bin/docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                sh "/Users/luiznonato/.docker/bin/docker tag desafio:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/desafio:latest"
                sh "/Users/luiznonato/.docker/bin/docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/desafio:latest"
            }
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
