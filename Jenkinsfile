pipeline {
    agent any

    environment {
        TERRAFORM_FILES_PATH = "terraform"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
        PATH = "${env.PATH}:/opt/homebrew/bin"
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
    }
}
