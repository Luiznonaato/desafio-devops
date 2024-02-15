pipeline {
    agent any

    environment {
        // Definindo a variável de ambiente diretamente no Jenkinsfile
        //TERRAFORM_REPO_PATH = "/opt/homebrew/bin/terraform"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Preparar') {
            steps {
               // dir(env.TERRAFORM_REPO_PATH) {
                    sh 'echo Preparando o Terraform'
                }
            }
        }

        stage('Terraform Init') {
            steps {
              //  dir(env.TERRAFORM_REPO_PATH) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
               // dir(env.TERRAFORM_REPO_PATH) {
                    //sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
