pipeline {
  agent any

  environment {
    REGISTRY        = "your-dockerhub-username/venky"
    CREDENTIALS_ID  = "dockerhub-credentials-id"
    IMAGE_TAG       = "${env.BUILD_NUMBER}"
    HOST_PORT       = 8088
    CONTAINER_PORT  = 80
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://your.git.repo/theaterbookings.git'
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
            // Give the container time to start
            sh "sleep 5"
            // Simple health check
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
      echo "Build #${env.BUILD_NUMBER} complete — image pushed and tested on port ${HOST_PORT}."
    }
  }
}

