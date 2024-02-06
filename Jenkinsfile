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

        stage("Execução do terraform") {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform init'
                        // Assegura a passagem das variáveis de ambiente para o Terraform. Substitua pelos nomes corretos conforme necessário.
                        sh """
                          terraform apply -auto-approve -var "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -var "vpc_id=${VPC_ID}" -var 'subnet_ids=["id1","id2"]' -var "ami_id=${AMI_ID}" \\
                          -var 'AWS_DEFAULT_REGION=\${AWS_DEFAULT_REGION}' \\
                          -var 'vpc_id=\${VPC_ID}' \\
                          -var 'subnet_ids=[\${SUBNET_IDS}]' \\
                          -var 'ami_id=\${AMI_ID}'
                        """
                        // Captura os outputs do Terraform
                        ECR_REGISTRY_URL = sh(script: "terraform output -raw ecr_repository_url", returnStdout: true).trim()
                        ECS_CLUSTER_NAME = sh(script: "terraform output -raw ecs_cluster_name", returnStdout: true).trim()
                        ECS_SERVICE_NAME = sh(script: "terraform output -raw ecs_service_name", returnStdout: true).trim()
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
