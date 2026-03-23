pipeline {
    agent {
        docker {
            image 'docker:24-dind'
            args '--privileged'
        }
    }

    stages {

        stage('Start Docker Daemon') {
            steps {
                sh '''
                dockerd-entrypoint.sh &
                sleep 10
                docker info
                '''
            }
        }

        stage('Install Tools') {
            steps {
                sh '''
                apk add --no-cache maven openjdk17 git
                '''
            }
        }

        stage('Checkout') {
            steps {
                git 'https://github.com/praveena14-07/Myapp_Maven_ServerB.git'
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn clean package"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t mywebapp:v${BUILD_NUMBER} ."
            }
        }
        
        stage('Publish to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                    sh "docker tag mywebapp:v${BUILD_NUMBER} ${env.dockerHubUser}/mywebapp:v${BUILD_NUMBER}"
                    sh "docker push ${env.dockerHubUser}/mywebapp:v${BUILD_NUMBER}"
                }
            }
        }

        stage('Run Container') {
            steps {
                sh """
                docker run -d -p 9090:8080 --name tomcat-container-${env.BUILD_NUMBER} mywebapp:v${env.BUILD_NUMBER}
                """
            }
        }
    }
}
