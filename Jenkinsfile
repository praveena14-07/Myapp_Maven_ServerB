pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Get some code from a GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/praveena14-07/Myapp_Maven.git']]])
            }
        }
        
        stage('Build') {
            steps {
                // Run Maven on a Unix agent.
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

        stage('Run the container') {
            steps {
                script {
                    def containerId = sh(
                        script: "docker ps -q | head -n 1",
                        returnStdout: true
                    ).trim()

                    if (containerId) {
                        sh "docker stop ${containerId}"
                        sh "docker rm ${containerId}"
                    }

                    sh """
                    docker run -d -p 9090:8080 --name tomcat-container-${env.BUILD_NUMBER} mywebapp:v${env.BUILD_NUMBER}
                    """
                }
            }
        }
    }
}
