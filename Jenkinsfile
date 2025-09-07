pipeline {
    agent any

    environment {
        REGISTRY = "your-dockerhub-username/venky"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        HOST_PORT = 8088
        CONTAINER_PORT = 80
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/subhasri78/venky.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Run & Test Container') {
            steps {
                script {
                    def containerId = sh(
                        script: "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} ${REGISTRY}:${IMAGE_TAG}",
                        returnStdout: true
                    ).trim()

                    try {
                        sh "sleep 5"
                        sh "curl -f http://localhost:${HOST_PORT} || (docker logs ${containerId} && exit 1)"
                    } finally {
                        sh "docker stop ${containerId} || true"
                        sh "docker rm -f ${containerId} || true"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials-id') {
                        sh "docker push ${REGISTRY}:${IMAGE_TAG}"
                        sh "docker tag ${REGISTRY}:${IMAGE_TAG} ${REGISTRY}:latest"
                        sh "docker push ${REGISTRY}:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Build #${env.BUILD_NUMBER} completed — tested on port ${HOST_PORT} and pushed to Docker Hub."
        }
    }
}
