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
                    dockerImage = docker.build("${REGISTRY}:${IMAGE_TAG}")
                }
            }
        }

        stage('Run & Test Container') {
            steps {
                script {
                    // Run the container in detached mode
                    def container = dockerImage.run("-d -p ${HOST_PORT}:${CONTAINER_PORT}")
                    try {
                        // Wait for the container to start
                        sh "sleep 5"
                        // Test the application
                        sh "curl -f http://localhost:${HOST_PORT} || (docker logs ${container.id} && exit 1)"
                    } finally {
                        // Stop and remove the container
                        container.stop()
                        container.remove()
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials-id') {
                        dockerImage.push(IMAGE_TAG)
                        dockerImage.push('latest')
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
