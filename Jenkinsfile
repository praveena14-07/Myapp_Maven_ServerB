pipeline {
    agent {
        docker {
            image 'docker:24-dind'
            args '--privileged -v /tmp:/tmp'
        }
    }

    environment {
        IMAGE_NAME = "mywebapp"
    }

    stages {

        stage('Start Docker Daemon') {
            steps {
                sh '''
                dockerd-entrypoint.sh > /tmp/dockerd.log 2>&1 &
                sleep 15
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

        stage('Build Maven') {
            steps {
                sh 'mvn clean package'
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
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    docker login -u $USER -p $PASS
                    docker tag ${IMAGE_NAME}:v${BUILD_NUMBER} $USER/${IMAGE_NAME}:v${BUILD_NUMBER}
                    docker push $USER/${IMAGE_NAME}:v${BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('Run Container (inside DinD)') {
            steps {
                sh '''
                docker rm -f ${IMAGE_NAME} || true
                docker run -d -p 9090:8080 --name ${IMAGE_NAME} ${IMAGE_NAME}:v${BUILD_NUMBER}
                '''
            }
        }
    }
}
