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

        stage('run the container') {
            steps {
                sh "CONTAINER_ID=`docker ps | awk '{print $1}' | tail -1`"
                sh "docker stop ${CONTAINER_ID}"
                sh "docker rm ${CONTAINER_ID}"
                sh "docker run -d -p 9090:8080 --name tomcat-container-$BUILD_NUMBER my-app:$BUILD_NUMBER"
            }
        }
    }
}
