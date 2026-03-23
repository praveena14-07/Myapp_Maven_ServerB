pipeline {
    agent {
        docker {
            image 'maven:3.9-eclipse-temurin-17'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "mywebapp"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/praveena14-07/Myapp_Maven_ServerB.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Verify Docker Access') {
            steps {
                sh 'docker version'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:v${BUILD_NUMBER} .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub_credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker tag ${IMAGE_NAME}:v${BUILD_NUMBER} $DOCKER_USER/${IMAGE_NAME}:v${BUILD_NUMBER}
                    docker push $DOCKER_USER/${IMAGE_NAME}:v${BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker rm -f ${IMAGE_NAME} || true
                docker run -d -p 9090:8080 --name ${IMAGE_NAME} ${IMAGE_NAME}:v${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f || true'
        }
    }
}
