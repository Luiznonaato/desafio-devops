pipeline {
    agent any

    stages {

        stage ("Checkout source") {

            steps {
                git url: 'https://github.com/Luiznonaato/desafio-devops.git', branch: 'main'
                sh 'ls'
            }   
        }

        stage ("Execução do terraform") {

            script {
                sh 'terraform init'
                sh 'terraform apply'
            }
        }
    }
}
