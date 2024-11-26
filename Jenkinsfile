pipeline {
    agent any
    environment {
        GO_APP_IMAGE = "engineer442/simple-go-webapp"      
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials"  
        KUBE_CREDENTIALS_ID = "kubeconfig-id"       
        GO_APP_IMAGE_TAG = "${GO_APP_IMAGE}:${BUILD_ID}" 
        NAMESPACE = "production"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image ${GO_APP_IMAGE_TAG}..."
                    docker.build("${GO_APP_IMAGE_TAG}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS_ID}"]) {
                        echo "Pushing Docker image ${GO_APP_IMAGE_TAG}..."
                        sh "docker tag ${GO_APP_IMAGE_TAG} ${GO_APP_IMAGE}:latest"
                        sh "docker push ${GO_APP_IMAGE_TAG}"
                        sh "docker push ${GO_APP_IMAGE}:latest"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
    post {
        success {
            echo "Deployment to Kubernetes completed successfully."
        }
        failure {
            echo "Deployment to Kubernetes failed."
        }
        always {
            script {
                echo "Cleaning up local Docker images..."
                sh "docker rmi ${GO_APP_IMAGE_TAG} || true"
                sh "docker rmi ${GO_APP_IMAGE}:latest || true"
            }
        }
    }
}
