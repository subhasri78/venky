pipeline {
  agent any

  environment {
    REGISTRY       = "your-dockerhub-username/venky"
    CREDENTIALS_ID = "dockerhub-credentials-id"
    IMAGE_TAG      = "${env.BUILD_NUMBER}"
    HOST_PORT      = 8088          // add these if using test stage
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
          docker.withRun("-p ${HOST_PORT}:${CONTAINER_PORT}") { container ->
            sh "sleep 5"
            sh "curl -f http://localhost:${HOST_PORT} || (docker logs ${container.id} && exit 1)"
          }
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('', CREDENTIALS_ID) {
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


