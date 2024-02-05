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

            enviroment  {
                AWS_DEFAULT_REGION = credentials('AWS_DEFAULT_REGION')
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }
            
            steps{

                script {
                    sh 'terraform init'
                    sh 'terraform apply'
                }
            }
        }
    }
}
