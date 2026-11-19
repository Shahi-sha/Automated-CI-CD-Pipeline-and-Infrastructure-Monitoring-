
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t devops-monitoring-app ./app'
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying application container'

                sh '''
                    docker rm -f devops-web || true

                    docker run -d \
                        --name devops-web \
                        --restart unless-stopped \
                        -p 80:80 \
                        devops-monitoring-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'docker ps'
                sh 'curl -f http://localhost/'
            }
        }
    }
}
