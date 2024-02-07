pipeline {
    agent any

            environment {
                // A definição das credenciais AWS será feita no bloco 'withCredentials
                AWS_DEFAULT_REGION    = credentials('AWS_DEFAULT_REGION')
                AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                PATH                  = "/opt/homebrew/bin:$PATH" // Adiciona o caminho do Terraform ao PATH
                IMAGE_TAG             = 'latest'
            }
            stages {
                stage("Checkout source") {
                    steps {
                        git url: 'https://github.com/Luiznonaato/desafio-devops.git', branch: 'main'
                    }
                }
                stage("Terraform Init") {
                    steps {
                        script {
                                dir('terraform') {
                                    // Inicializa o Terraform
                                    sh 'terraform init'
                                }
                        }
                    }
                }
                stage("Terraform Plan") {
                        steps {
                            script {
                                    dir('terraform') {
                                        sh "terraform plan \
                                        -var 'subnet_id=${env.subnet_id}' \
                                        -var 'vpc_id=${env.vpc_id}' \
                                        -var 'ami_id=${env.ami_id}'"

                                        /* Mostra os valores capturados para verificação
                                        echo "Captured VPC ID: ${env.VPC_ID}"
                                        echo "Captured SUBNET ID: ${env.subnet_id}"
                                        echo "Captured ECR Repository URL: ${env.ECR_REGISTRY_URL}"*/
                                    }
                            }
                        }
                }
                stage('Build Docker Image') {
                    steps {
                        script {
                            // Constrói a imagem Docker e a taggeia para o repositório ECR usando o caminho completo do executável do Docker
                            sh "/Users/luiznonato/.docker/bin/docker build -t ${env.ECR_REGISTRY_URL}:${env.IMAGE_TAG} ."
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
                                // Utiliza o caminho completo para os comandos aws e docker
                                sh "/usr/local/bin/aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | /Users/luiznonato/.docker/bin/docker login --username AWS --password-stdin ${env.ECR_REGISTRY_URL}"
                                // Faz push da imagem para o repositório ECR usando o caminho completo do Docker
                                sh "/Users/luiznonato/.docker/bin/docker push ${env.ECR_REGISTRY_URL}:${env.IMAGE_TAG}"
                            }
                        }
                    }
                }/*
                stage('Update ECS Service') {
                    steps {
                        script {
                            // Substitua 'us-east-1' pela região do seu cluster e certifique-se de que ECS_CLUSTER_NAME está definido
                            sh "/usr/local/bin/aws ecs update-service --region us-east-1 --cluster ${env.ECS_CLUSTER_NAME} --service meu-servico-ecs --force-new-deployment"
                        }
                    }
     
                }*/
            }
}